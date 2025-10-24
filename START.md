# 🚀 Como Iniciar o Redmine Dashboard

## Opção 1: Script Automático (Recomendado)

### No Git Bash:

```bash
# Navegar até a pasta do projeto
cd "/c/Users/gabri/OneDrive/Desktop/Automacao Gabi/Automacao Gabi/redmine-dashboard"

# Iniciar tudo (backend + frontend)
bash start-all.sh

# Para parar tudo
bash stop-all.sh
```

---

## Opção 2: Manual (Dois Terminais)

### Terminal 1 - Backend (Git Bash):

```bash
cd "/c/Users/gabri/OneDrive/Desktop/Automacao Gabi/Automacao Gabi/redmine-dashboard/backend"
rails s -p 3001
```

### Terminal 2 - Frontend (Git Bash ou PowerShell):

```bash
cd "/c/Users/gabri/OneDrive/Desktop/Automacao Gabi/Automacao Gabi/redmine-dashboard/frontend"
npm run dev
```

---

## Opção 3: PowerShell (Apenas Frontend)

Se o backend já estiver rodando em outro terminal:

```powershell
cd "C:\Users\gabri\OneDrive\Desktop\Automacao Gabi\Automacao Gabi\redmine-dashboard\frontend"
npm run dev
```

---

## 📍 URLs

Após iniciar:

- **Backend API**: http://localhost:3001
- **Frontend**: http://localhost:3000

---

## ✅ Verificar se Está Rodando

### Backend:
```bash
curl http://localhost:3001/api/v1/health
```

### Frontend:
Abra http://localhost:3000 no navegador

---

## 🛑 Parar os Servidores

### Se usou o script automático:
```bash
bash stop-all.sh
```

### Se iniciou manualmente:
Pressione `Ctrl+C` em cada terminal

---

## 🔧 Troubleshooting

### "rails: command not found"
- Use Git Bash em vez de PowerShell
- Ou instale Ruby no PATH do Windows

### "npm: command not found"
- Instale Node.js: https://nodejs.org/

### Porta 3001 já em uso
```bash
# Windows
netstat -ano | findstr :3001
taskkill /PID <PID> /F

# Git Bash
lsof -ti:3001 | xargs kill -9
```

### Porta 3000 já em uso
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Git Bash
lsof -ti:3000 | xargs kill -9
```

---

## 📦 Primeira Vez?

Se é a primeira vez rodando o projeto:

### Backend:
```bash
cd backend
bundle install
cp .env.example .env
# Edite o .env com suas configurações
rails db:create
rails db:migrate
```

### Frontend:
```bash
cd frontend
npm install
```

---

## 🎯 Testando as Alterações do Filtro "Kind"

Após iniciar o projeto:

1. Acesse http://localhost:3000
2. Faça login
3. Vá para "Atividades do Time"
4. Use o filtro "Filtrar por Tipo"
5. Selecione "Task"
6. Verifique se mostra todas as 15 tarefas (não apenas 3)

---

## 📝 Logs

### Backend (Git Bash):
Os logs aparecem no terminal onde você rodou `rails s`

Procure por:
```
Atividades Time - Total no Redmine: 15, Retornadas: 15
Filtros aplicados: {:project_id=>"dev", :limit=>300, ...}
```

### Frontend:
Os logs aparecem no terminal onde você rodou `npm run dev`

