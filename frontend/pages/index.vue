<template>
  <div class="px-4">
    <!-- Cabeçalho com boas-vindas -->
    <div class="mb-6">
        <h1 class="text-3xl font-bold text-gray-900 mb-1">
          Olá, {{ authStore.user?.name?.split(' ')[0] || 'Usuário' }}!
        </h1>
        <p class="text-lg text-gray-600">
          Bem-vindo ao Dashboard de Monitoramento do Redmine
        </p>
      </div>

      <!-- Alerta de urgência se houver -->
      <div v-if="alertCount > 0" class="mb-6 bg-gradient-to-r from-red-500 to-red-600 shadow-lg p-6 text-white">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-4">
            <div class="bg-white bg-opacity-20 rounded-full p-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
              </svg>
            </div>
            <div>
              <h3 class="text-2xl font-bold mb-1">ATENÇÃO: {{ alertCount }} {{ alertCount === 1 ? 'Alerta Ativo' : 'Alertas Ativos' }}</h3>
              <p class="text-red-100">Issues em "To Check" precisam de sua atenção imediata!</p>
            </div>
          </div>
          <NuxtLink
            to="/alertas"
            class="bg-white text-red-600 px-6 py-3 rounded-lg font-bold hover:bg-red-50 transition-colors"
          >
            VER ALERTAS
          </NuxtLink>
        </div>
      </div>

      <!-- Cards de Métricas - NO TOPO -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
        <!-- Atividades do Time -->
        <NuxtLink
          to="/atividades-time"
          class="bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all transform hover:-translate-y-1 cursor-pointer border-t-4 border-blue-500"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="bg-blue-100 rounded-full p-3">
              <svg class="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
              </svg>
            </div>
            <span class="text-4xl font-bold text-blue-600">{{ stats.team }}</span>
          </div>
          <h3 class="text-lg font-bold text-gray-900 mb-2">Atividades do Time</h3>
          <p class="text-sm text-gray-600 mb-4">
            Veja o que cada pessoa está fazendo agora
          </p>
          <div class="flex items-center text-blue-600 font-medium">
            <span>Acessar</span>
            <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </div>
        </NuxtLink>

        <!-- Features -->
        <NuxtLink
          to="/features"
          class="bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all transform hover:-translate-y-1 cursor-pointer border-t-4 border-purple-500"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="bg-purple-100 rounded-full p-3">
              <svg class="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
              </svg>
            </div>
            <span class="text-4xl font-bold text-purple-600">{{ stats.features }}</span>
          </div>
          <h3 class="text-lg font-bold text-gray-900 mb-2">Features (Macro)</h3>
          <p class="text-sm text-gray-600 mb-4">
            Todas as features em desenvolvimento
          </p>
          <div class="flex items-center text-purple-600 font-medium">
            <span>Acessar</span>
            <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </div>
        </NuxtLink>

        <!-- Outras Atividades -->
        <NuxtLink
          to="/outras-atividades"
          class="bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all transform hover:-translate-y-1 cursor-pointer border-t-4 border-green-500"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="bg-green-100 rounded-full p-3">
              <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
              </svg>
            </div>
            <span class="text-4xl font-bold text-green-600">{{ stats.others }}</span>
          </div>
          <h3 class="text-lg font-bold text-gray-900 mb-2">Outras Atividades</h3>
          <p class="text-sm text-gray-600 mb-4">
            Bugs, tasks, spiders e mais
          </p>
          <div class="flex items-center text-green-600 font-medium">
            <span>Acessar</span>
            <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </div>
        </NuxtLink>

        <!-- Alertas -->
        <NuxtLink
          to="/alertas"
          class="bg-white rounded-xl shadow-lg p-6 hover:shadow-2xl transition-all transform hover:-translate-y-1 cursor-pointer border-t-4"
          :class="alertCount > 0 ? 'border-red-500' : 'border-gray-300'"
        >
          <div class="flex items-center justify-between mb-4">
            <div class="rounded-full p-3" :class="alertCount > 0 ? 'bg-red-100' : 'bg-gray-100'">
              <svg class="w-8 h-8" :class="alertCount > 0 ? 'text-red-600' : 'text-gray-600'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
              </svg>
            </div>
            <span class="text-4xl font-bold" :class="alertCount > 0 ? 'text-red-600' : 'text-gray-600'">
              {{ alertCount }}
            </span>
          </div>
          <h3 class="text-lg font-bold text-gray-900 mb-2">Alertas</h3>
          <p class="text-sm text-gray-600 mb-4">
            {{ alertCount > 0 ? 'Issues precisam de atenção!' : 'Tudo tranquilo por aqui' }}
          </p>
          <div class="flex items-center font-medium" :class="alertCount > 0 ? 'text-red-600' : 'text-gray-600'">
            <span>{{ alertCount > 0 ? 'VER AGORA' : 'Acessar' }}</span>
            <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </div>
        </NuxtLink>
      </div>

      <!-- Momento atual - Atividades EM PROGRESSO -->
      <div v-if="inProgressActivities.length > 0" class="mb-8 bg-white shadow-lg p-8">
        <div class="flex items-center justify-between mb-6">
          <div class="flex items-center">
            <div class="bg-gradient-to-r from-purple-600 to-purple-700 rounded-full p-3 mr-3">
              <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
              </svg>
            </div>
            <div>
              <h3 class="text-2xl font-bold text-gray-900">Momento Atual - Em Progresso</h3>
              <p class="text-gray-600">Atividades que estão sendo desenvolvidas agora</p>
            </div>
          </div>
          <span class="px-4 py-2 bg-purple-100 text-purple-700 rounded-full font-bold">
            {{ inProgressActivities.length }} {{ inProgressActivities.length === 1 ? 'atividade' : 'atividades' }}
          </span>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <div
            v-for="[userId, userData] in inProgressActivities"
            :key="userId"
            class="bg-gradient-to-br from-purple-50 to-purple-100 border-2 border-purple-300 rounded-lg p-5 hover:shadow-xl transition-all"
          >
            <!-- Avatar e nome -->
            <div class="flex items-center space-x-3 mb-4 pb-4 border-b-2 border-purple-200">
              <div class="bg-gradient-to-br from-purple-600 to-purple-700 rounded-full p-3 shadow-md">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
              </div>
              <div class="flex-1">
                <h4 class="font-bold text-lg text-gray-900 leading-tight">
                  {{ userData.user.name || 'Não atribuído' }}
                </h4>
                <span class="text-xs text-purple-700 font-semibold">
                  {{ userData.issues.length }} {{ userData.issues.length === 1 ? 'atividade' : 'atividades' }}
                </span>
              </div>
            </div>

            <!-- Activities list -->
            <div v-if="userData.issues.length > 0" class="space-y-2 max-h-64 overflow-y-auto">
              <div
                v-for="issue in userData.issues.slice(0, 5)"
                :key="issue.id"
                class="bg-white rounded-lg p-3 border border-purple-200 hover:border-purple-400 transition-colors"
              >
                <div class="flex items-center justify-between mb-1">
                  <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
                  <span class="text-xs px-2 py-1 bg-purple-100 text-purple-700 rounded-full font-semibold">
                    IN PROGRESS
                  </span>
                </div>
                <h5 class="text-xs font-semibold text-gray-900 line-clamp-2 mb-1">
                  {{ issue.subject }}
                </h5>
                <span class="text-xs px-2 py-0.5 bg-gray-200 rounded text-gray-700">
                  {{ issue.tracker.name }}
                </span>
              </div>
              <div v-if="userData.issues.length > 5" class="text-center pt-2">
                <span class="text-xs text-purple-600 font-semibold">
                  +{{ userData.issues.length - 5 }} mais
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Atividades Entregues na Última Sprint -->
      <div v-if="deliveredByUser.length > 0" class="mb-8">
        <div class="flex items-center mb-6">
          <div class="bg-gradient-to-r from-green-600 to-green-700 rounded-full p-3 mr-3">
            <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
          </div>
          <div>
            <h3 class="text-2xl font-bold text-gray-900">Atividades Entregues na Última Sprint</h3>
            <p class="text-gray-600">Total: {{ lastSprintActivities.length }} atividades concluídas</p>
          </div>
        </div>

        <!-- Cards por pessoa -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
          <div
            v-for="[userId, userData] in deliveredByUser"
            :key="userId"
            class="bg-white rounded-xl shadow-lg overflow-hidden border-l-4 border-green-500 hover:shadow-2xl transition-all"
          >
            <!-- Header do card - clicável -->
            <div
              @click="toggleUserDelivered(userId)"
              class="p-5 cursor-pointer hover:bg-green-50 transition-colors"
            >
              <div class="flex items-center justify-between mb-2">
                <div class="flex items-center space-x-3">
                  <div class="bg-gradient-to-br from-green-600 to-green-700 rounded-full p-2">
                    <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                  </div>
                  <div>
                    <h4 class="font-bold text-gray-900">
                      {{ userData.user.name || 'Não atribuído' }}
                    </h4>
                  </div>
                </div>
                <svg
                  class="w-5 h-5 text-gray-400 transition-transform"
                  :class="{ 'rotate-180': expandedUsers[userId] }"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                </svg>
              </div>
              <div class="text-center mt-3">
                <div class="text-4xl font-bold text-green-600">{{ userData.issues.length }}</div>
                <div class="text-sm text-gray-600">{{ userData.issues.length === 1 ? 'tarefa entregue' : 'tarefas entregues' }}</div>
              </div>
            </div>

            <!-- Lista de atividades - expansível -->
            <div v-if="expandedUsers[userId]" class="px-5 pb-5 space-y-2 bg-gray-50 border-t">
              <div
                v-for="issue in userData.issues"
                :key="issue.id"
                class="bg-white rounded-lg p-3 border border-gray-200 hover:border-green-400 transition-colors"
              >
                <div class="flex items-center justify-between mb-1">
                  <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
                  <span class="text-xs px-2 py-1 bg-green-100 text-green-700 rounded-full font-semibold">
                    DONE
                  </span>
                </div>
                <h5 class="text-xs font-semibold text-gray-900 line-clamp-2 mb-1">
                  {{ issue.subject }}
                </h5>
                <span class="text-xs px-2 py-0.5 bg-gray-200 rounded text-gray-700">
                  {{ issue.tracker.name }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

  </div>
</template>

<script setup lang="ts">
/**
 * Página principal do dashboard
 * Exibe resumo e acesso rápido às 4 telas
 */

const authStore = useAuthStore()
const redmine = useRedmine()

const alertCount = ref(0)
const teamActivities = ref<any>({})
const lastSprintActivities = ref<any[]>([])
const expandedUsers = ref<Record<string, boolean>>({})
const stats = ref({
  team: 0,
  features: 0,
  others: 0
})

/**
 * Agrupa atividades entregues por usuário
 */
const deliveredByUser = computed(() => {
  const grouped: Record<string, any> = {}

  lastSprintActivities.value.forEach((issue: any) => {
    const userId = issue.assigned_to?.id || 'unassigned'
    const userName = issue.assigned_to?.name || 'Não atribuído'

    if (!grouped[userId]) {
      grouped[userId] = {
        user: { id: userId, name: userName },
        issues: []
      }
    }

    grouped[userId].issues.push(issue)
  })

  return Object.entries(grouped).sort((a, b) => b[1].issues.length - a[1].issues.length)
})

/**
 * Toggle expansão do card de usuário
 */
const toggleUserDelivered = (userId: string) => {
  expandedUsers.value[userId] = !expandedUsers.value[userId]
}

/**
 * Filtra SOMENTE atividades EM PROGRESSO
 */
const inProgressActivities = computed(() => {
  const entries = Object.entries(teamActivities.value)
  const result: any[] = []

  entries.forEach(([userId, userData]: [string, any]) => {
    // Filtra apenas issues que estão "In Progress"
    const inProgressIssues = userData.issues.filter((issue: any) => {
      const statusName = issue.status?.name?.toLowerCase() || ''
      return statusName.includes('progress')
    })

    // Só adiciona se tiver pelo menos 1 issue em progresso
    if (inProgressIssues.length > 0) {
      result.push([userId, {
        user: userData.user,
        issues: inProgressIssues
      }])
    }
  })

  return result
})

/**
 * Busca estatísticas
 */
const fetchStats = async () => {
  try {
    // Buscar alertas
    const alertData = await redmine.fetchAlertas({ limit: 1 })
    alertCount.value = alertData.total_count || 0

    // Buscar features
    const featuresData = await redmine.fetchFeatures({ limit: 1 })
    stats.value.features = featuresData.total_count || 0

    // Buscar outras atividades
    const othersData = await redmine.fetchOutrasAtividades({ limit: 1 })
    stats.value.others = othersData.total_count || 0

    // Buscar atividades do time
    const teamData = await redmine.fetchAtividadesTime({ limit: 1 })
    stats.value.team = teamData.total_count || 0

    // Buscar atividades do time agrupadas por pessoa (TODOS os desenvolvedores)
    const fullTeamData = await redmine.fetchAtividadesTime({ limit: 100 })
    teamActivities.value = fullTeamData.issues_by_user || {}

    // Buscar última sprint entregue
    const sprintData = await redmine.fetchUltimaSprint({ limit: 100 })
    console.log('Sprint Data:', sprintData)
    lastSprintActivities.value = sprintData.issues || sprintData.activities || []
  } catch (error) {
    console.error('Erro ao buscar estatísticas:', error)
  }
}

/**
 * Retorna classe de badge por status
 */
const getStatusBadgeClass = (status: string) => {
  const s = status.toLowerCase()
  if (s.includes('progress')) return 'bg-purple-100 text-purple-700'
  if (s.includes('check')) return 'bg-red-100 text-red-700'
  if (s.includes('deploy')) return 'bg-teal-100 text-teal-700'
  if (s.includes('staging')) return 'bg-pink-100 text-pink-700'
  if (s.includes('hold')) return 'bg-gray-100 text-gray-700'
  if (s.includes('done')) return 'bg-green-100 text-green-700'
  if (s.includes('analyze')) return 'bg-yellow-100 text-yellow-700'
  return 'bg-blue-100 text-blue-700'
}

// Middleware de autenticação
definePageMeta({
  middleware: 'auth',
})

onMounted(() => {
  fetchStats()
  // Auto-refresh a cada 60 segundos
  setInterval(fetchStats, 60000)
})
</script>

<style scoped>
.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
