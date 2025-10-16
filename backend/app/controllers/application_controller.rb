# frozen_string_literal: true

# Controller base da aplicação
# Responsável por autenticação JWT e tratamento de erros
class ApplicationController < ActionController::API
  before_action :authenticate_request

  # Atributo para armazenar usuário autenticado
  attr_reader :current_user

  private

  # Autentica requisição via JWT token
  # Token deve estar no header Authorization: Bearer <token>
  def authenticate_request
    token = extract_token_from_header

    if token
      decoded = JsonWebToken.decode(token)

      if decoded
        @current_user = decoded
      else
        render_unauthorized('Token inválido ou expirado')
      end
    else
      render_unauthorized('Token não fornecido')
    end
  end

  # Extrai token do header Authorization
  #
  # @return [String, nil] Token ou nil se não encontrado
  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split(' ')&.last
  end

  # Renderiza erro de não autorizado
  #
  # @param message [String] Mensagem de erro
  def render_unauthorized(message = 'Não autorizado')
    render json: { error: message }, status: :unauthorized
  end

  # Renderiza erro de não encontrado
  #
  # @param message [String] Mensagem de erro
  def render_not_found(message = 'Não encontrado')
    render json: { error: message }, status: :not_found
  end

  # Renderiza erro de bad request
  #
  # @param message [String] Mensagem de erro
  def render_bad_request(message = 'Requisição inválida')
    render json: { error: message }, status: :bad_request
  end
end
