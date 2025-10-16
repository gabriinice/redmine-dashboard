# Como Rodar com Docker

## Pré-requisitos

- Docker Desktop instalado e rodando

## Passo a Passo

### 1. Abrir terminal na pasta do projeto

```bash
cd "d:\Automacao Gabi\redmine-dashboard"
```

### 2. Rodar tudo com um comando

```bash
docker-compose up --build
```

Isso vai:
- Criar banco PostgreSQL (automacao-redmine-db)
- Criar Redis (automacao-redmine-redis)
- Criar e rodar Backend Rails (automacao-redmine-backend)
- Criar e rodar Frontend Nuxt (automacao-redmine-frontend)

### 3. Aguardar subir (pode levar 2-3 minutos na primeira vez)

Você verá logs de todos os containers. Aguarde até ver:

```
automacao-redmine-backend  | * Listening on http://0.0.0.0:3000
automacao-redmine-frontend | ✔ Nuxt DevTools is enabled
```

### 4. Acessar no navegador

http://localhost:3001

### 5. Fazer login

Use suas credenciais do Redmine!

## Comandos Úteis

### Parar tudo
```bash
docker-compose down
```

### Ver logs
```bash
docker-compose logs -f
```

### Ver apenas logs do backend
```bash
docker-compose logs -f backend
```

### Ver apenas logs do frontend
```bash
docker-compose logs -f frontend
```

### Reconstruir (se mudar código)
```bash
docker-compose up --build
```

### Limpar tudo e recomeçar
```bash
docker-compose down -v
docker-compose up --build
```

## Containers Criados

- **automacao-redmine-db** - PostgreSQL na porta 5432
- **automacao-redmine-redis** - Redis na porta 6379
- **automacao-redmine-backend** - Rails API na porta 3000
- **automacao-redmine-frontend** - Nuxt na porta 3001

## Troubleshooting

### "Port already in use"
Algum serviço está usando porta 3000 ou 3001. Parar o serviço ou mudar porta no docker-compose.yml

### "Cannot connect to Docker"
Docker Desktop não está rodando. Abrir Docker Desktop.

### Backend não inicia
Ver logs: `docker-compose logs backend`
Geralmente é problema com Gemfile. Verificar se Ruby version está 3.2.0

### Frontend não inicia
Ver logs: `docker-compose logs frontend`
Verificar se .env existe em frontend/

## Pronto!

Após rodar `docker-compose up --build`, aguardar 2-3 minutos e acessar:

http://localhost:3001

Fazer login com credenciais do Redmine e usar as 4 telas!
