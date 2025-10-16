# frozen_string_literal: true

# Serviço para codificação e decodificação de JWT tokens
# Tokens incluem credenciais do Redmine para uso nas requisições
class JsonWebToken
  SECRET_KEY = ENV.fetch('JWT_SECRET') { Rails.application.secret_key_base }
  ALGORITHM = 'HS256'
  EXPIRATION_TIME = 24.hours

  # Codifica payload em JWT token
  #
  # @param payload [Hash] Dados a serem codificados
  # @param exp [Time] Tempo de expiração (padrão: 24 horas)
  # @return [String] JWT token
  def self.encode(payload, exp = EXPIRATION_TIME.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  # Decodifica JWT token
  #
  # @param token [String] JWT token
  # @return [HashWithIndifferentAccess, nil] Payload decodificado ou nil se inválido
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, algorithm: ALGORITHM)
    HashWithIndifferentAccess.new(decoded[0])
  rescue JWT::DecodeError, JWT::ExpiredSignature => e
    Rails.logger.info("Token inválido ou expirado: #{e.message}")
    nil
  end
end
