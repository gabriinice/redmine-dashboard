#!/bin/bash

# Script para iniciar Backend e Frontend do Redmine Dashboard
# Execute com: bash start-all.sh

echo "🚀 Iniciando Redmine Dashboard..."
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar Ruby
if ! command_exists ruby; then
    echo -e "${RED}❌ Ruby não encontrado. Instale Ruby 3.2+ primeiro.${NC}"
    exit 1
fi

# Verificar Node
if ! command_exists node; then
    echo -e "${RED}❌ Node.js não encontrado. Instale Node.js primeiro.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Ruby $(ruby --version)${NC}"
echo -e "${GREEN}✅ Node $(node --version)${NC}"
echo ""

# Diretório do projeto
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"

# Função para iniciar backend
start_backend() {
    echo -e "${BLUE}📦 Iniciando Backend Rails...${NC}"
    cd "$BACKEND_DIR"
    
    # Verificar se bundle está instalado
    if ! command_exists bundle; then
        echo -e "${RED}❌ Bundler não encontrado. Instalando...${NC}"
        gem install bundler
    fi
    
    # Instalar dependências se necessário
    if [ ! -d "vendor/bundle" ] && [ ! -f "Gemfile.lock" ]; then
        echo -e "${BLUE}📥 Instalando dependências do backend...${NC}"
        bundle install
    fi
    
    # Iniciar servidor Rails na porta 3001
    echo -e "${GREEN}🚀 Iniciando Rails na porta 3001...${NC}"
    rails s -p 3001 &
    BACKEND_PID=$!
    echo $BACKEND_PID > "$PROJECT_DIR/backend.pid"
    echo -e "${GREEN}✅ Backend iniciado (PID: $BACKEND_PID)${NC}"
}

# Função para iniciar frontend
start_frontend() {
    echo -e "${BLUE}📦 Iniciando Frontend Nuxt...${NC}"
    cd "$FRONTEND_DIR"
    
    # Instalar dependências se necessário
    if [ ! -d "node_modules" ]; then
        echo -e "${BLUE}📥 Instalando dependências do frontend...${NC}"
        npm install
    fi
    
    # Iniciar servidor Nuxt
    echo -e "${GREEN}🚀 Iniciando Nuxt em modo desenvolvimento...${NC}"
    npm run dev &
    FRONTEND_PID=$!
    echo $FRONTEND_PID > "$PROJECT_DIR/frontend.pid"
    echo -e "${GREEN}✅ Frontend iniciado (PID: $FRONTEND_PID)${NC}"
}

# Iniciar backend
start_backend
sleep 3

# Iniciar frontend
start_frontend
sleep 3

echo ""
echo -e "${GREEN}✅ Tudo iniciado com sucesso!${NC}"
echo ""
echo -e "${BLUE}📍 URLs:${NC}"
echo -e "   Backend:  http://localhost:3001"
echo -e "   Frontend: http://localhost:3000"
echo ""
echo -e "${BLUE}📝 Para parar os servidores:${NC}"
echo -e "   bash stop-all.sh"
echo ""
echo -e "${BLUE}📋 PIDs salvos em:${NC}"
echo -e "   Backend:  backend.pid"
echo -e "   Frontend: frontend.pid"
echo ""

# Manter o script rodando
wait

