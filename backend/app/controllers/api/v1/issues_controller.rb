# frozen_string_literal: true

module Api
  module V1
    # Controller para gerenciar issues do Redmine
    # Todas as requisições usam credenciais do usuário autenticado
    class IssuesController < ApplicationController
      # GET /api/v1/issues
      # Busca issues com filtros
      #
      # Params:
      #   - project_id: ID ou identificador do projeto
      #   - status_id: ID(s) do status (pode ser array)
      #   - tracker_id: ID(s) do tracker (pode ser array)
      #   - assigned_to_id: ID do usuário atribuído
      #   - cf_11: Valor do custom field 11 (Macro)
      #   - limit: Limite de resultados (padrão: 100)
      #   - offset: Offset para paginação (padrão: 0)
      def index
        client = redmine_client
        filters = build_filters

        result = client.fetch_issues(filters)

        render json: {
          total_count: result['total_count'],
          limit: filters[:limit],
          offset: filters[:offset],
          issues: format_issues(result['issues'])
        }, status: :ok
      end

      # GET /api/v1/issues/:id
      # Busca detalhes de uma issue específica
      #
      # Params:
      #   - include_journals: true para incluir comentários
      def show
        client = redmine_client
        include_journals = params[:include_journals] == 'true'

        issue = client.fetch_issue(params[:id], include_journals: include_journals)

        if issue
          render json: { issue: format_issue(issue, include_journals: include_journals) }, status: :ok
        else
          render_not_found('Issue não encontrada')
        end
      end

      # POST /api/v1/issues
      # Cria uma nova issue no Redmine
      #
      # Params (JSON):
      #   - project_id: ID do projeto (obrigatório)
      #   - tracker_id: ID do tracker (obrigatório)
      #   - subject: Título (obrigatório)
      #   - description: Descrição
      #   - status_id: ID do status
      #   - priority_id: ID da prioridade
      #   - assigned_to_id: ID do usuário atribuído
      #   - custom_fields: Array de custom fields (ex: story_points)
      def create
        client = redmine_client

        issue_params = build_issue_params

        result = client.create_issue(issue_params)

        if result && result['issue']
          render json: {
            success: true,
            message: 'Issue criada com sucesso',
            issue: format_issue(result['issue'])
          }, status: :created
        else
          render json: {
            success: false,
            message: 'Erro ao criar issue',
            errors: result&.dig('errors') || ['Erro desconhecido']
          }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/issues/:id
      # Atualiza uma issue existente
      #
      # Params (JSON): mesmos do create
      def update
        client = redmine_client

        issue_params = build_issue_params

        result = client.update_issue(params[:id], issue_params)

        if result
          render json: {
            success: true,
            message: 'Issue atualizada com sucesso'
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Erro ao atualizar issue'
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issues/:id
      # Deleta uma issue
      def destroy
        client = redmine_client

        result = client.delete_issue(params[:id])

        if result
          render json: {
            success: true,
            message: 'Issue deletada com sucesso'
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Erro ao deletar issue'
          }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/issues/:id/comments
      # Adiciona um comentário a uma issue
      #
      # Params (JSON):
      #   - notes: Texto do comentário (obrigatório)
      def add_comment
        client = redmine_client

        notes = params[:notes] || params.dig(:issue, :notes)

        if notes.blank?
          return render json: {
            success: false,
            message: 'Comentário não pode estar vazio'
          }, status: :unprocessable_entity
        end

        result = client.add_comment(params[:id], notes)

        if result
          render json: {
            success: true,
            message: 'Comentário adicionado com sucesso'
          }, status: :ok
        else
          render json: {
            success: false,
            message: 'Erro ao adicionar comentário'
          }, status: :unprocessable_entity
        end
      end

      private

      # Cria instância do cliente Redmine com credenciais do usuário
      #
      # @return [Redmine::Client]
      def redmine_client
        Redmine::Client.new(current_user[:credentials])
      end

      # Constrói hash de filtros a partir dos params
      #
      # @return [Hash]
      def build_filters
        filters = {}

        filters[:project_id] = params[:project_id] if params[:project_id].present?
        filters[:limit] = params[:limit].to_i if params[:limit].present?
        filters[:offset] = params[:offset].to_i if params[:offset].present?
        filters[:assigned_to_id] = params[:assigned_to_id] if params[:assigned_to_id].present?
        filters[:cf_11] = params[:cf_11] if params[:cf_11].present?

        # Status pode ser array ou string
        if params[:status_id].present?
          filters[:status_id] = parse_ids(params[:status_id])
        end

        # Tracker pode ser array ou string
        if params[:tracker_id].present?
          filters[:tracker_id] = parse_ids(params[:tracker_id])
        end

        filters
      end

      # Parseia IDs que podem vir como array ou string separada por vírgula
      #
      # @param value [String, Array] Valor a ser parseado
      # @return [Array<Integer>]
      def parse_ids(value)
        if value.is_a?(Array)
          value.map(&:to_i)
        else
          value.to_s.split(',').map(&:to_i)
        end
      end

      # Constrói hash de parâmetros para criar/atualizar issue
      #
      # @return [Hash]
      def build_issue_params
        issue_data = params[:issue] || params

        result = {}

        result[:project_id] = issue_data[:project_id] if issue_data[:project_id].present?
        result[:tracker_id] = issue_data[:tracker_id] if issue_data[:tracker_id].present?
        result[:subject] = issue_data[:subject] if issue_data[:subject].present?
        result[:description] = issue_data[:description] if issue_data[:description].present?
        result[:status_id] = issue_data[:status_id] if issue_data[:status_id].present?
        result[:priority_id] = issue_data[:priority_id] if issue_data[:priority_id].present?
        result[:assigned_to_id] = issue_data[:assigned_to_id] if issue_data[:assigned_to_id].present?

        # Custom fields (ex: story_points)
        if issue_data[:custom_fields].present?
          result[:custom_fields] = issue_data[:custom_fields]
        elsif issue_data[:story_points].present?
          result[:custom_fields] = [
            { id: 1, value: issue_data[:story_points] } # Ajustar ID conforme custom field
          ]
        end

        result
      end

      # Formata lista de issues para resposta
      #
      # @param issues [Array<Hash>] Issues do Redmine
      # @return [Array<Hash>] Issues formatadas
      def format_issues(issues)
        issues.map { |issue| format_issue(issue) }
      end

      # Formata uma issue para resposta
      # Calcula dias parado e extrai último comentário
      #
      # @param issue [Hash] Issue do Redmine
      # @param include_journals [Boolean] Incluir journals
      # @return [Hash] Issue formatada
      def format_issue(issue, include_journals: false)
        formatted = {
          id: issue['id'],
          subject: issue['subject'],
          description: issue['description'],
          tracker: {
            id: issue.dig('tracker', 'id'),
            name: issue.dig('tracker', 'name')
          },
          status: {
            id: issue.dig('status', 'id'),
            name: issue.dig('status', 'name')
          },
          priority: {
            id: issue.dig('priority', 'id'),
            name: issue.dig('priority', 'name')
          },
          assigned_to: issue['assigned_to'] ? {
            id: issue.dig('assigned_to', 'id'),
            name: issue.dig('assigned_to', 'name')
          } : nil,
          project: {
            id: issue.dig('project', 'id'),
            name: issue.dig('project', 'name')
          },
          created_on: issue['created_on'],
          updated_on: issue['updated_on'],
          days_stale: calculate_days_stale(issue['updated_on'])
        }

        # Adicionar journals se solicitado
        if include_journals && issue['journals'].present?
          formatted[:journals] = format_journals(issue['journals'])
          formatted[:last_comment] = extract_last_comment(issue['journals'])
        end

        formatted
      end

      # Formata journals (comentários e alterações)
      #
      # @param journals [Array<Hash>] Journals do Redmine
      # @return [Array<Hash>] Journals formatados
      def format_journals(journals)
        journals.map do |journal|
          {
            id: journal['id'],
            notes: journal['notes'],
            created_on: journal['created_on'],
            user: {
              id: journal.dig('user', 'id'),
              name: journal.dig('user', 'name')
            }
          }
        end
      end

      # Extrai último comentário dos journals
      #
      # @param journals [Array<Hash>] Journals do Redmine
      # @return [Hash, nil] Último comentário ou nil
      def extract_last_comment(journals)
        # Busca o último journal que tenha notes (comentário)
        last_with_notes = journals.reverse.find { |j| j['notes'].present? }

        return nil unless last_with_notes

        {
          text: last_with_notes['notes'],
          created_on: last_with_notes['created_on'],
          user: {
            id: last_with_notes.dig('user', 'id'),
            name: last_with_notes.dig('user', 'name')
          }
        }
      end

      # Calcula quantos dias a issue está parada (sem atualizações)
      #
      # @param updated_on [String] Data da última atualização (ISO 8601)
      # @return [Integer] Dias parados
      def calculate_days_stale(updated_on)
        return 0 unless updated_on

        updated_date = Time.parse(updated_on)
        ((Time.now - updated_date) / 1.day).to_i
      end
    end
  end
end
