# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # API v1
  namespace :api do
    namespace :v1 do
      # Autenticação
      post 'auth/login', to: 'auth#login'
      post 'auth/logout', to: 'auth#logout'
      get 'auth/me', to: 'auth#me'

      # Issues
      resources :issues, only: [:index, :show, :create, :update, :destroy] do
        member do
          post 'comments', to: 'issues#add_comment'
        end
      end

      # Boards (telas específicas)
      get 'boards/atividades_time', to: 'boards#atividades_time'
      get 'boards/features', to: 'boards#features'
      get 'boards/outras_atividades', to: 'boards#outras_atividades'
      get 'boards/alertas', to: 'boards#alertas'
      get 'boards/sprint_atual', to: 'boards#sprint_atual'
      get 'boards/ultima_sprint', to: 'boards#ultima_sprint'

      # AI
      namespace :ai do
        post 'review_story', to: 'ai#review_story'
      end
    end
  end

  # Health check
  get 'health', to: proc { [200, {}, ['OK']] }
end
