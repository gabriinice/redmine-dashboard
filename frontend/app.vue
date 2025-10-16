<template>
  <div>
    <!-- Layout com sidebar para páginas autenticadas -->
    <div v-if="!isLoginPage" class="flex min-h-screen bg-gradient-to-br from-gray-50 to-blue-50">
      <!-- Sidebar -->
      <LayoutSidebar />

      <!-- Conteúdo principal -->
      <div class="flex-1 ml-64">
        <!-- Barra superior com título da página -->
        <header class="bg-[#0f172a] shadow-2xl border-b border-slate-800 sticky top-0 z-40">
          <div class="px-6 py-6">
            <h2 class="text-2xl font-bold text-white">
              {{ pageTitle }}
            </h2>
            <p v-if="pageDescription" class="text-sm text-slate-300 mt-1">
              {{ pageDescription }}
            </p>
          </div>
        </header>

        <!-- Conteúdo da página -->
        <main class="pt-6">
          <NuxtPage />
        </main>
      </div>
    </div>

    <!-- Layout para página de login (sem sidebar) -->
    <div v-else>
      <NuxtPage />
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Layout principal da aplicação
 * Integra sidebar em todas as páginas exceto login
 */

const route = useRoute()

/**
 * Verifica se é página de login
 */
const isLoginPage = computed(() => {
  return route.path === '/login'
})

/**
 * Título da página atual
 */
const pageTitle = computed(() => {
  const titles: Record<string, string> = {
    '/': 'Dashboard',
    '/atividades-time': 'Atividades do Time',
    '/features': 'Features (Macro)',
    '/outras-atividades': 'Outras Atividades',
    '/alertas': 'Alertas',
    '/sprint-atual': 'Sprint Atual',
    '/sprint-planning': 'Sprint Planning'
  }
  return titles[route.path] || 'Redmine Dashboard'
})

/**
 * Descrição da página atual
 */
const pageDescription = computed(() => {
  const descriptions: Record<string, string> = {
    '/': 'Visão geral do monitoramento do Redmine',
    '/atividades-time': 'Veja o que cada desenvolvedor está fazendo agora',
    '/features': 'Kanban board com todas as features em desenvolvimento',
    '/outras-atividades': 'Bugs, tasks, spiders e outros tipos de atividades',
    '/alertas': 'Issues em "To Check" que precisam de atenção imediata',
    '/sprint-atual': 'Todas as atividades da sprint em andamento',
    '/sprint-planning': 'Planejamento e organização das sprints'
  }
  return descriptions[route.path] || ''
})
</script>

<style>
/* Estilos globais */
body {
  margin: 0;
  padding: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

/* Scrollbar customizada */
::-webkit-scrollbar {
  width: 10px;
  height: 10px;
}

::-webkit-scrollbar-track {
  background: #f1f5f9;
}

::-webkit-scrollbar-thumb {
  background: #cbd5e1;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: #94a3b8;
}

/* Transições suaves */
* {
  transition: background-color 0.2s ease, color 0.2s ease, border-color 0.2s ease;
}
</style>
