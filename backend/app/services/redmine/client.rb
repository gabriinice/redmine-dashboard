# frozen_string_literal: true

module Redmine
  # Cliente HTTP para comunicação com a API do Redmine
  # Usa a sintaxe CORRETA da documentação oficial
  class Client
    REDMINE_URL = ENV.fetch('REDMINE_URL', 'https://redmine.platform.brobot.com.br')

    attr_reader :credentials

    def initialize(credentials)
      @credentials = credentials
    end

    # Busca issues com filtros usando PIPE notation
    # Sintaxe VALIDADA: status_id=1|2|3 (testado com curl!)
    #
    # @param filters [Hash] Filtros
    # @return [Hash] { total_count, issues }
    def fetch_issues(filters = {})
      query_string = build_query_string(filters)

      Rails.logger.info("🔍 Fetching issues: #{query_string}")

      result = get("/issues.json?#{query_string}") || { 'total_count' => 0, 'issues' => [] }

      Rails.logger.info("✅ Received #{result['total_count']} issues")

      result
    end

    # Busca detalhes de uma issue
    def fetch_issue(issue_id, include_journals: false)
      params = include_journals ? { include: 'journals' } : {}
      data = get("/issues/#{issue_id}.json", params)
      data&.dig('issue')
    end

    # Busca usuário atual
    def fetch_current_user
      data = get('/users/current.json')
      data&.dig('user')
    end

    # Busca sprints do Agile
    def fetch_agile_sprints(project_id)
      get("/projects/#{project_id}/agile_sprints.json")
    end

    # Cria uma nova issue
    #
    # @param issue_params [Hash] Parâmetros da issue
    # @return [Hash, nil] Resposta do Redmine
    def create_issue(issue_params)
      Rails.logger.info("📝 Creating issue: #{issue_params[:subject]}")

      response = post('/issues.json', { issue: issue_params })

      if response
        Rails.logger.info("✅ Issue created successfully: ##{response.dig('issue', 'id')}")
      else
        Rails.logger.error("❌ Failed to create issue")
      end

      response
    end

    # Atualiza uma issue existente
    #
    # @param issue_id [Integer] ID da issue
    # @param issue_params [Hash] Parâmetros da issue
    # @return [Boolean] true se sucesso
    def update_issue(issue_id, issue_params)
      Rails.logger.info("📝 Updating issue ##{issue_id}")

      response = put("/issues/#{issue_id}.json", { issue: issue_params })

      if response
        Rails.logger.info("✅ Issue ##{issue_id} updated successfully")
        true
      else
        Rails.logger.error("❌ Failed to update issue ##{issue_id}")
        false
      end
    end

    # Deleta uma issue
    #
    # @param issue_id [Integer] ID da issue
    # @return [Boolean] true se sucesso
    def delete_issue(issue_id)
      Rails.logger.info("🗑️ Deleting issue ##{issue_id}")

      response = delete("/issues/#{issue_id}.json")

      if response
        Rails.logger.info("✅ Issue ##{issue_id} deleted successfully")
        true
      else
        Rails.logger.error("❌ Failed to delete issue ##{issue_id}")
        false
      end
    end

    # Adiciona comentário a uma issue
    #
    # @param issue_id [Integer] ID da issue
    # @param notes [String] Texto do comentário
    # @return [Boolean] true se sucesso
    def add_comment(issue_id, notes)
      Rails.logger.info("💬 Adding comment to issue ##{issue_id}")

      response = put("/issues/#{issue_id}.json", { issue: { notes: notes } })

      if response
        Rails.logger.info("✅ Comment added successfully to issue ##{issue_id}")
        true
      else
        Rails.logger.error("❌ Failed to add comment to issue ##{issue_id}")
        false
      end
    end

    private

    # Faz requisição GET (endpoint já inclui query string)
    def get(endpoint, params = {})
      response = connection.get(endpoint) do |req|
        req.params = params unless params.empty?
      end

      return nil unless response.success?

      response.body
    rescue Faraday::Error => e
      Rails.logger.error("❌ Erro ao buscar #{endpoint}: #{e.message}")
      nil
    end

    # Faz requisição POST
    def post(endpoint, body = {})
      response = connection.post(endpoint) do |req|
        req.body = body
      end

      return nil unless response.success?

      response.body
    rescue Faraday::Error => e
      Rails.logger.error("❌ Erro ao criar #{endpoint}: #{e.message}")
      nil
    end

    # Faz requisição PUT
    def put(endpoint, body = {})
      response = connection.put(endpoint) do |req|
        req.body = body
      end

      response.success?
    rescue Faraday::Error => e
      Rails.logger.error("❌ Erro ao atualizar #{endpoint}: #{e.message}")
      false
    end

    # Faz requisição DELETE
    def delete(endpoint)
      response = connection.delete(endpoint)

      response.success?
    rescue Faraday::Error => e
      Rails.logger.error("❌ Erro ao deletar #{endpoint}: #{e.message}")
      false
    end

    # Cria conexão Faraday
    def connection
      @connection ||= Faraday.new(url: REDMINE_URL) do |conn|
        # Detecta se é API Key (40 chars hex) ou credenciais codificadas
        if credentials.length == 40 && credentials.match?(/^[a-f0-9]{40}$/)
          conn.headers['X-Redmine-API-Key'] = credentials
        else
          login, password = Authenticator.decode_credentials(credentials)
          conn.request :authorization, :basic, login, password
        end

        conn.request :json
        conn.request :retry, max: 2, interval: 0.5
        conn.response :json
        conn.adapter Faraday.default_adapter
        conn.options.timeout = 15
        conn.options.open_timeout = 10
      end
    end

    # Constrói query string usando PIPE (sintaxe VALIDADA com testes reais!)
    # TESTADO E FUNCIONA: status_id=1|2|3&tracker_id=1|2
    def build_query_string(filters)
      parts = []

      # Limit e offset (simples)
      parts << "limit=#{filters[:limit] || 100}"
      parts << "offset=#{filters[:offset] || 0}"

      # Projeto
      parts << "project_id=#{filters[:project_id]}" if filters[:project_id]

      # Status - PIPE notation (TESTADO!)
      if filters[:status_id].present?
        status_ids = Array(filters[:status_id]).join('|')
        parts << "status_id=#{status_ids}"
      end

      # Tracker - PIPE notation (TESTADO!)
      if filters[:tracker_id].present?
        tracker_ids = Array(filters[:tracker_id]).join('|')
        parts << "tracker_id=#{tracker_ids}"
      end

      # Usuário atribuído
      parts << "assigned_to_id=#{filters[:assigned_to_id]}" if filters[:assigned_to_id]

      # Custom field cf_11 (Kind: Macro, Task, Group) - suporta múltiplos valores com PIPE
      if filters[:cf_11].present?
        # Se for array ou string com vírgulas, converte para PIPE notation
        cf_11_values = filters[:cf_11].is_a?(Array) ? filters[:cf_11] : filters[:cf_11].to_s.split(',')
        cf_11_query = cf_11_values.map { |v| CGI.escape(v.strip) }.join('|')
        parts << "cf_11=#{cf_11_query}"
      end

      # Updated on (date filter)
      parts << "updated_on=#{CGI.escape(filters[:updated_on])}" if filters[:updated_on]

      # Closed on (date filter)
      parts << "closed_on=#{CGI.escape(filters[:closed_on])}" if filters[:closed_on]

      # Agile sprint ID
      parts << "agile_sprint_id=#{filters[:agile_sprint_id]}" if filters[:agile_sprint_id]

      # Include (journals, attachments, etc)
      parts << "include=#{filters[:include]}" if filters[:include]

      parts.join('&')
    end
  end
end
