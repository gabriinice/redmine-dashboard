# frozen_string_literal: true

module Redmine
  # Serviço responsável por autenticar usuários no Redmine
  # Valida credenciais diretamente na API do Redmine sem armazenar senhas
  class Authenticator
    REDMINE_URL = ENV.fetch('REDMINE_URL', 'https://redmine.platform.brobot.com.br')

    # Autentica usuário no Redmine usando login e senha
    #
    # @param login [String] Login do usuário no Redmine
    # @param password [String] Senha do usuário no Redmine
    # @return [Hash, nil] Dados do usuário se autenticado, nil se falhar
    def self.authenticate(login, password)
      # Cria conexão Faraday com Basic Auth
      conn = Faraday.new(url: REDMINE_URL) do |f|
        f.request :authorization, :basic, login, password
        f.adapter Faraday.default_adapter
      end

      response = conn.get('/users/current.json') do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['Accept'] = 'application/json'
        req.options.timeout = 10
      end

      return nil unless response.success?

      # Parse JSON manualmente pois não configuramos response :json nesta conexão
      user_data = JSON.parse(response.body)['user']

      Rails.logger.info("DEBUG - User data from Redmine: #{user_data.inspect}")

      # Retorna a API Key do usuário para usar nas próximas requisições
      api_key = user_data['api_key']

      # Se não tiver api_key, codifica login:senha em Base64 como fallback
      if api_key.blank?
        Rails.logger.warn("User #{login} não tem API Key no Redmine, usando Basic Auth como fallback")
        api_key = encode_credentials(login, password)
      else
        Rails.logger.info("DEBUG - Using API Key for user #{login}: #{api_key}")
      end

      {
        id: user_data['id'],
        login: user_data['login'],
        firstname: user_data['firstname'],
        lastname: user_data['lastname'],
        mail: user_data['mail'],
        # Usa a API Key do usuário ao invés de codificar login/senha
        credentials: api_key
      }
    rescue Faraday::Error, JSON::ParserError => e
      Rails.logger.error("Erro ao autenticar no Redmine: #{e.message}")
      nil
    end

    # Valida se as credenciais ainda são válidas
    #
    # @param credentials [String] Credenciais codificadas em Base64
    # @return [Boolean] true se válido, false caso contrário
    def self.valid_credentials?(credentials)
      login, password = decode_credentials(credentials)
      authenticate(login, password).present?
    end

    # Codifica login e senha em Base64 para armazenamento temporário
    # Não é armazenado em banco, apenas em memória/cache
    #
    # @param login [String] Login do usuário
    # @param password [String] Senha do usuário
    # @return [String] Credenciais codificadas
    def self.encode_credentials(login, password)
      Base64.strict_encode64("#{login}:#{password}")
    end

    # Decodifica credenciais Base64
    #
    # @param credentials [String] Credenciais codificadas
    # @return [Array<String>] [login, password]
    def self.decode_credentials(credentials)
      decoded = Base64.strict_decode64(credentials)
      decoded.split(':', 2)
    end
  end
end
