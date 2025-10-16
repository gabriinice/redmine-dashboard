# Frontend - Redmine Dashboard

Interface web desenvolvida com Nuxt 3 e Vue 3.

## Requisitos

- Node.js 18+
- npm ou yarn

## Instalação

```bash
# Instalar dependências
npm install

# Copiar arquivo de configuração
cp .env.example .env

# Editar .env com a URL da API backend

# Iniciar servidor de desenvolvimento
npm run dev
```

O frontend estará disponível em `http://localhost:3001`

## Estrutura

```
frontend/
├── assets/css/          # Estilos CSS
├── components/          # Componentes Vue
│   ├── board/          # Componentes do Kanban
│   ├── layout/         # Layout (Header, Sidebar)
│   └── alert/          # Componentes de alertas
├── composables/         # Lógica reutilizável
│   ├── useApi.ts       # Cliente HTTP
│   └── useRedmine.ts   # Integração com API
├── middleware/          # Middlewares (autenticação)
├── pages/              # Páginas da aplicação
│   ├── index.vue       # Dashboard principal
│   ├── login.vue       # Login
│   ├── atividades-time.vue   # Tela 1
│   ├── features.vue    # Tela 2
│   ├── outras-atividades.vue  # Tela 3
│   └── alertas.vue     # Tela 4
├── stores/             # Gerenciamento de estado (Pinia)
│   ├── auth.ts         # Store de autenticação
│   └── issues.ts       # Store de issues
└── nuxt.config.ts      # Configuração do Nuxt
```

## Páginas

### Dashboard (/)
Página inicial com resumo e links rápidos

### Login (/login)
Autenticação com credenciais do Redmine

### Tela 1: Atividades do Time (/atividades-time)
Kanban board com todas as atividades do time de desenvolvimento

### Tela 2: Features (/features)
Kanban board com todas as features (Macro)

### Tela 3: Outras Atividades (/outras-atividades)
Kanban board com bugs, chores, tasks, spiders, tests e technical debts (Macro)

### Tela 4: Alertas (/alertas)
Lista de issues que caíram em "To Check"

## Componentes

### Board/IssueCard
Card de issue para exibição no Kanban

**Props:**
- `issue`: Dados da issue

**Eventos:**
- `click`: Emitido quando card é clicado

**Exemplo:**
```vue
<IssueCard
  :issue="issue"
  @click="handleClick"
/>
```

### Board/KanbanColumn
Coluna do Kanban board

**Props:**
- `title`: Título da coluna
- `issues`: Array de issues

**Eventos:**
- `issue-click`: Emitido quando issue é clicada

**Exemplo:**
```vue
<KanbanColumn
  title="To Do"
  :issues="issues"
  @issue-click="handleIssueClick"
/>
```

### Layout/Header
Cabeçalho da aplicação com navegação

## Composables

### useApi
Cliente HTTP com autenticação automática

```typescript
const api = useApi()

// GET
const data = await api.get('/api/v1/issues')

// POST
const response = await api.post('/api/v1/auth/login', { ... })
```

### useRedmine
Métodos para interagir com a API do Redmine

```typescript
const redmine = useRedmine()

// Buscar issues
const issues = await redmine.fetchIssues({ project_id: 'dev' })

// Buscar features
const features = await redmine.fetchFeatures()

// Buscar alertas
const alerts = await redmine.fetchAlertas()
```

## Stores

### Auth Store
Gerencia autenticação e estado do usuário

```typescript
const authStore = useAuthStore()

// Login
await authStore.login('usuario', 'senha')

// Logout
await authStore.logout()

// Verificar se está autenticado
if (authStore.isAuthenticated) {
  // ...
}

// Dados do usuário
console.log(authStore.user)
```

## Estilização

O projeto usa Tailwind CSS para estilização.

### Classes customizadas

- `.issue-card`: Card de issue
- `.kanban-column`: Coluna do Kanban
- `.priority-urgent`: Borda vermelha (prioridade urgente)
- `.priority-high`: Borda laranja (prioridade alta)
- `.priority-normal`: Borda azul (prioridade normal)
- `.priority-low`: Borda verde (prioridade baixa)

## Build

```bash
# Build para produção
npm run build

# Preview do build
npm run preview
```

## Deploy

### Vercel
```bash
npm run build
vercel --prod
```

### Netlify
```bash
npm run generate
netlify deploy --prod --dir=.output/public
```

## Desenvolvimento

### Adicionar nova página

1. Criar arquivo em `pages/nome-da-pagina.vue`
2. Adicionar link no Header
3. Adicionar middleware de autenticação se necessário

### Adicionar novo componente

1. Criar arquivo em `components/categoria/NomeComponente.vue`
2. Componente estará disponível globalmente

### Adicionar nova store

1. Criar arquivo em `stores/nome-store.ts`
2. Usar `defineStore` do Pinia
3. Importar onde necessário

## Troubleshooting

### Erro de autenticação
- Verificar se API backend está rodando
- Verificar URL da API no `.env`
- Verificar token no localStorage (DevTools)

### Erro ao buscar dados
- Verificar logs do console
- Verificar token de autenticação
- Verificar se backend está respondendo
