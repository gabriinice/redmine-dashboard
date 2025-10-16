# frozen_string_literal: true

# Configuração de CORS para permitir requisições do frontend
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Em desenvolvimento, permite localhost
    # Em produção, trocar pelo domínio do frontend
    origins ENV.fetch('FRONTEND_URL', 'http://localhost:3001')

    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head],
             credentials: true,
             expose: ['Authorization']
  end
end
