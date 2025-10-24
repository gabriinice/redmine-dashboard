#!/bin/bash

# Script para parar Backend e Frontend do Redmine Dashboard
# Execute com: bash stop-all.sh

echo "🛑 Parando Redmine Dashboard..."
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Diretório do projeto
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parar backend
if [ -f "$PROJECT_DIR/backend.pid" ]; then
    BACKEND_PID=$(cat "$PROJECT_DIR/backend.pid")
    if ps -p $BACKEND_PID > /dev/null 2>&1; then
        echo -e "${GREEN}🛑 Parando Backend (PID: $BACKEND_PID)...${NC}"
        kill $BACKEND_PID
        rm "$PROJECT_DIR/backend.pid"
        echo -e "${GREEN}✅ Backend parado${NC}"
    else
        echo -e "${RED}⚠️  Backend não está rodando${NC}"
        rm "$PROJECT_DIR/backend.pid"
    fi
else
    echo -e "${RED}⚠️  Arquivo backend.pid não encontrado${NC}"
fi

# Parar frontend
if [ -f "$PROJECT_DIR/frontend.pid" ]; then
    FRONTEND_PID=$(cat "$PROJECT_DIR/frontend.pid")
    if ps -p $FRONTEND_PID > /dev/null 2>&1; then
        echo -e "${GREEN}🛑 Parando Frontend (PID: $FRONTEND_PID)...${NC}"
        kill $FRONTEND_PID
        rm "$PROJECT_DIR/frontend.pid"
        echo -e "${GREEN}✅ Frontend parado${NC}"
    else
        echo -e "${RED}⚠️  Frontend não está rodando${NC}"
        rm "$PROJECT_DIR/frontend.pid"
    fi
else
    echo -e "${RED}⚠️  Arquivo frontend.pid não encontrado${NC}"
fi

echo ""
echo -e "${GREEN}✅ Todos os servidores foram parados!${NC}"

