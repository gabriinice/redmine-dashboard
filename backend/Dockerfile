FROM ruby:3.2-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    tzdata \
    yaml-dev \
    nodejs \
    npm

# Criar diretório da aplicação
WORKDIR /app

# Copiar Gemfile
COPY Gemfile* ./

# Instalar gems
RUN bundle install

# Copiar código da aplicação
COPY . .

# Expor porta
EXPOSE 3000

# Comando padrão (será sobrescrito pelo docker-compose)
CMD ["rails", "server", "-b", "0.0.0.0"]
