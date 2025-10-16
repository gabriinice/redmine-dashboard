# Backend - Redmine Dashboard

API Rails para integração com Redmine.

## Requisitos

- Ruby 3.2+
- PostgreSQL 14+
- Redis 7+

## Instalação

```bash
# Instalar dependências
bundle install

# Copiar arquivo de configuração
cp .env.example .env

# Editar .env com suas configurações
# Gerar JWT_SECRET com: rails secret

# Criar banco de dados
rails db:create

# Executar migrations
rails db:migrate

# Iniciar servidor
rails server
```

O servidor estará disponível em `http://localhost:3000`

## Autenticação

O sistema usa autenticação via Redmine + JWT.

### Fluxo de autenticação:

1. Usuário envia login e senha via `POST /api/v1/auth/login`
2. Backend valida credenciais no Redmine
3. Se válido, retorna JWT token
4. Cliente envia token em todas as requisições: `Authorization: Bearer <token>`
5. Backend decodifica token e usa credenciais do usuário para buscar dados no Redmine

**Importante**: Senhas não são armazenadas no banco de dados.

## Endpoints

### Autenticação

```
POST /api/v1/auth/login
Body: { "auth": { "login": "usuario", "password": "senha" } }
Response: { "token": "...", "user": {...} }

GET /api/v1/auth/me
Headers: Authorization: Bearer <token>
Response: { "user": {...} }

POST /api/v1/auth/logout
Headers: Authorization: Bearer <token>
Response: { "message": "Logout realizado com sucesso" }
```

### Issues

```
GET /api/v1/issues
Query params:
  - project_id: ID do projeto
  - status_id: ID(s) do status (pode ser array: status_id[]=1&status_id[]=2)
  - tracker_id: ID(s) do tracker (pode ser array)
  - assigned_to_id: ID do usuário atribuído
  - cf_11: Valor do custom field 11
  - limit: Limite de resultados (padrão: 100)
  - offset: Offset para paginação (padrão: 0)

GET /api/v1/issues/:id
Query params:
  - include_journals: true para incluir comentários
```

### Boards (Telas)

```
GET /api/v1/boards/atividades_time
Tela 1: Atividades do time de desenvolvimento

GET /api/v1/boards/features
Tela 2: Features (Macro)

GET /api/v1/boards/outras_atividades
Tela 3: Outras atividades (Macro)

GET /api/v1/boards/alertas
Tela 4: Alertas (To Check)
```

## Estrutura

```
app/
├── controllers/
│   ├── application_controller.rb     # Controller base com autenticação JWT
│   └── api/v1/
│       ├── auth_controller.rb        # Autenticação
│       ├── issues_controller.rb      # CRUD de issues
│       └── boards_controller.rb      # Telas específicas
├── services/
│   ├── json_web_token.rb             # Serviço JWT
│   └── redmine/
│       ├── authenticator.rb          # Autenticação no Redmine
│       └── client.rb                 # Cliente HTTP para Redmine
```

## Serviços

### Redmine::Authenticator

Responsável por autenticar usuários no Redmine.

```ruby
# Autentica usuário
user_data = Redmine::Authenticator.authenticate('login', 'senha')

# Valida credenciais
valid = Redmine::Authenticator.valid_credentials?(credentials)
```

### Redmine::Client

Cliente HTTP para comunicação com Redmine.

```ruby
# Criar cliente
client = Redmine::Client.new(credentials)

# Buscar issues
issues = client.fetch_issues(project_id: 'dev', status_id: [1, 3, 4])

# Buscar issue específica
issue = client.fetch_issue(123, include_journals: true)

# Buscar usuário atual
user = client.fetch_current_user
```

### JsonWebToken

Serviço para codificação/decodificação de JWT.

```ruby
# Codificar
token = JsonWebToken.encode({ user_id: 1, credentials: '...' })

# Decodificar
payload = JsonWebToken.decode(token)
```

## Testes

```bash
# Rodar todos os testes
rspec

# Rodar teste específico
rspec spec/controllers/api/v1/auth_controller_spec.rb
```

## Código Limpo

### Princípios:

1. **Comentários profissionais e didáticos**: Cada método tem documentação clara
2. **Sem over-engineering**: Soluções diretas e pragmáticas
3. **Separação de responsabilidades**: Controllers, Services e Models bem definidos
4. **Tratamento de erros**: Erros são tratados e logados adequadamente

### Exemplo de comentário:

```ruby
# Autentica usuário no Redmine usando login e senha
#
# @param login [String] Login do usuário no Redmine
# @param password [String] Senha do usuário no Redmine
# @return [Hash, nil] Dados do usuário se autenticado, nil se falhar
def self.authenticate(login, password)
  # implementação...
end
```

## Troubleshooting

### Erro de conexão com Redmine

Verificar:
- URL do Redmine no .env está correta
- Redmine está acessível
- Credenciais são válidas

### Token inválido

- Token expirou (24 horas)
- Fazer novo login

### Erro 500 ao buscar issues com múltiplos filtros

Verificar sintaxe dos parâmetros:
- Usar array syntax: `status_id[]=1&status_id[]=2`
- Não usar vírgula: `status_id=1,2` (incorreto)
