# frozen_string_literal: true

module Api
  module V1
    # Controller responsável pela autenticação de usuários
    # Login é feito diretamente no Redmine, sem armazenar senhas
    class AuthController < ApplicationController
      skip_before_action :authenticate_request, only: [:login]

      # POST /api/v1/auth/login
      # Autentica usuário no Redmine e retorna JWT token
      #
      # Params:
      #   - login: Login do usuário no Redmine
      #   - password: Senha do usuário no Redmine
      #
      # Response:
      #   - token: JWT token para uso nas próximas requisições
      #   - user: Dados do usuário
      def login
        user_data = Redmine::Authenticator.authenticate(login_params[:login], login_params[:password])

        if user_data
          token = JsonWebToken.encode(
            user_id: user_data[:id],
            login: user_data[:login],
            credentials: user_data[:credentials]
          )

          render json: {
            token: token,
            user: {
              id: user_data[:id],
              login: user_data[:login],
              name: "#{user_data[:firstname]} #{user_data[:lastname]}",
              email: user_data[:mail]
            }
          }, status: :ok
        else
          render json: { error: 'Login ou senha inválidos' }, status: :unauthorized
        end
      end

      # POST /api/v1/auth/logout
      # Logout do usuário (apenas retorna sucesso, token expira naturalmente)
      def logout
        render json: { message: 'Logout realizado com sucesso' }, status: :ok
      end

      # GET /api/v1/auth/me
      # Retorna dados do usuário autenticado
      def me
        client = Redmine::Client.new(@current_user[:credentials])
        user_data = client.fetch_current_user

        if user_data
          render json: {
            user: {
              id: user_data['id'],
              login: user_data['login'],
              name: "#{user_data['firstname']} #{user_data['lastname']}",
              email: user_data['mail']
            }
          }, status: :ok
        else
          render json: { error: 'Erro ao buscar dados do usuário' }, status: :unprocessable_entity
        end
      end

      private

      def login_params
        params.require(:auth).permit(:login, :password)
      end
    end
  end
end
