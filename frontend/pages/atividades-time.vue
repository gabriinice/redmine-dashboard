<template>
  <div class="px-4 pt-6">
    <main>
      <!-- Cabeçalho -->
      <PageHeader>
        <template #title>Atividades do Time</template>
        <template #subtitle>Veja o que cada desenvolvedor está fazendo agora</template>
        <template #actions>
        <button
          @click="openCreateModal"
          class="flex items-center space-x-2 px-4 py-2 bg-gradient-to-r from-emerald-600 to-teal-600 text-white rounded-lg hover:from-emerald-700 hover:to-teal-700 transition-all shadow-md hover:shadow-lg transform hover:-translate-y-0.5"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
          </svg>
          <span>Nova Issue</span>
        </button>
        <button
          @click="fetchData"
          :disabled="loading"
          class="flex items-center space-x-2 px-4 py-2 bg-gradient-to-r from-blue-700 to-indigo-700 text-white rounded-lg hover:from-blue-800 hover:to-indigo-800 transition-all shadow-md hover:shadow-lg disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg class="w-5 h-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
          </svg>
          <span>{{ loading ? 'Atualizando...' : 'Atualizar' }}</span>
        </button>
        </template>
      </PageHeader>

      <!-- Estatísticas rápidas -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-blue-700 hover:shadow-xl transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-600">Total de Issues</p>
              <p class="text-3xl font-bold bg-gradient-to-r from-blue-800 to-blue-600 bg-clip-text text-transparent">{{ totalCount }}</p>
            </div>
            <div class="bg-gradient-to-br from-blue-100 to-blue-200 rounded-full p-3">
              <svg class="w-8 h-8 text-blue-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
              </svg>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-indigo-600 hover:shadow-xl transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-600">Em Progresso</p>
              <p class="text-3xl font-bold bg-gradient-to-r from-indigo-700 to-indigo-500 bg-clip-text text-transparent">{{ inProgressCount }}</p>
            </div>
            <div class="bg-gradient-to-br from-indigo-100 to-indigo-200 rounded-full p-3">
              <svg class="w-8 h-8 text-indigo-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
              </svg>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-cyan-600 hover:shadow-xl transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-600">Aguardando Deploy</p>
              <p class="text-3xl font-bold bg-gradient-to-r from-cyan-700 to-cyan-500 bg-clip-text text-transparent">{{ awaitingDeployCount }}</p>
            </div>
            <div class="bg-gradient-to-br from-cyan-100 to-cyan-200 rounded-full p-3">
              <svg class="w-8 h-8 text-cyan-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
              </svg>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-xl shadow-lg p-6 border-l-4 border-slate-600 hover:shadow-xl transition-shadow">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-slate-600">Pessoas Ativas</p>
              <p class="text-3xl font-bold bg-gradient-to-r from-slate-800 to-slate-600 bg-clip-text text-transparent">{{ activeUsersCount }}</p>
            </div>
            <div class="bg-gradient-to-br from-slate-100 to-slate-200 rounded-full p-3">
              <svg class="w-8 h-8 text-slate-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
              </svg>
            </div>
          </div>
        </div>
      </div>

      <!-- Filtros -->
      <div class="mb-6 bg-white rounded-xl shadow-lg p-6 border-t-4 border-blue-700">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <!-- Filtro por pessoa -->
          <div class="flex flex-col space-y-2">
              <label class="text-sm font-semibold text-slate-700">Filtrar por Pessoa:</label>
              <select
                v-model="selectedUser"
                @change="fetchData"
                class="px-4 py-3 border-2 border-slate-200 rounded-lg focus:ring-2 focus:ring-blue-600 focus:border-blue-600 bg-white hover:border-blue-400 transition-colors"
              >
                <option value="">Todas as pessoas</option>
                <option v-for="user in users" :key="user.id" :value="user.id">
                  {{ user.name }}
                </option>
              </select>
            </div>

            <!-- Filtro por status -->
            <div class="flex flex-col space-y-2">
              <label class="text-sm font-semibold text-slate-700">Filtrar por Status:</label>
              <div class="flex items-center space-x-2">
                <select
                  v-model="selectedStatuses"
                  multiple
                  @change="fetchData"
                  class="flex-1 px-4 py-3 border-2 border-slate-200 rounded-lg focus:ring-2 focus:ring-indigo-600 focus:border-indigo-600 bg-white hover:border-indigo-400 transition-colors h-auto"
                  size="3"
                >
                  <option v-for="status in availableStatuses" :key="status.id" :value="status.id">
                    {{ status.name }}
                  </option>
                </select>
                <button
                  v-if="selectedStatuses.length > 0"
                  @click="clearStatusFilter"
                  class="px-3 py-3 bg-slate-100 text-slate-600 hover:bg-red-100 hover:text-red-600 rounded-lg transition-colors"
                  title="Limpar filtro de status"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                  </svg>
                </button>
              </div>
            </div>
        </div>

        <!-- Filtros ativos -->
        <div v-if="selectedUser || selectedStatuses.length > 0" class="mt-4 flex items-center space-x-2 p-3 bg-blue-50 rounded-lg">
          <svg class="w-5 h-5 text-blue-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <span class="text-sm font-medium text-blue-800">Filtros ativos</span>
          <button
            @click="clearAllFilters"
            class="ml-auto px-4 py-1.5 bg-red-600 text-white hover:bg-red-700 rounded-lg transition-colors text-sm font-medium"
          >
            Limpar todos
          </button>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center items-center py-20">
        <div class="text-center bg-white rounded-xl shadow-lg p-12 border-2 border-blue-200">
          <div class="spinner w-16 h-16 mx-auto mb-6 !border-4 !border-blue-700 !border-t-transparent"></div>
          <p class="text-slate-700 text-lg font-semibold">Carregando atividades do time...</p>
          <p class="text-slate-500 text-sm mt-2">Aguarde enquanto buscamos os dados</p>
        </div>
      </div>

      <!-- Erro -->
      <div v-else-if="error" class="bg-red-50 border-2 border-red-300 rounded-xl p-8 shadow-lg">
        <div class="flex items-start space-x-4">
          <svg class="w-10 h-10 text-red-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <div class="flex-1">
            <p class="font-bold text-red-900 text-xl mb-2">Erro ao carregar dados</p>
            <p class="text-red-700 text-base">{{ error }}</p>
            <button
              @click="fetchData"
              class="mt-4 px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors font-semibold"
            >
              Tentar novamente
            </button>
          </div>
        </div>
      </div>

      <!-- Atividades por pessoa -->
      <div v-else class="space-y-6">
        <div v-for="(userData, userId) in filteredIssues" :key="userId" class="bg-white rounded-xl shadow-xl overflow-hidden border-2 border-slate-100 hover:border-blue-300 transition-all">
          <!-- Cabeçalho da pessoa -->
          <div class="bg-gradient-to-r from-blue-800 via-blue-700 to-indigo-700 px-6 py-5">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-4">
                <div class="bg-white rounded-full p-3 shadow-lg">
                  <svg class="w-7 h-7 text-blue-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                  </svg>
                </div>
                <div>
                  <h3 class="text-2xl font-bold text-white drop-shadow-md">
                    {{ userData.user.name || 'Não atribuído' }}
                  </h3>
                  <p class="text-blue-100 text-sm font-medium">
                    {{ userData.issues.length }} {{ userData.issues.length === 1 ? 'tarefa' : 'tarefas' }}
                  </p>
                </div>
              </div>
              <div class="bg-white bg-opacity-20 backdrop-blur-sm rounded-full px-5 py-2 border border-white border-opacity-30">
                <span class="text-white font-bold text-2xl">{{ userData.issues.length }}</span>
              </div>
            </div>
          </div>

          <!-- Issues da pessoa -->
          <div class="p-6 bg-gradient-to-br from-slate-50 to-blue-50">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
              <div
                v-for="issue in userData.issues"
                :key="issue.id"
                class="bg-white rounded-xl p-5 hover:shadow-xl transition-all cursor-pointer border-2 border-slate-200 hover:border-blue-500 transform hover:-translate-y-1"
                :class="getPriorityBorderClass(issue.priority.name)"
                @click="handleIssueClick(issue)"
              >
                <!-- Badge de status -->
                <div class="flex items-center justify-between mb-3">
                  <span class="text-xs font-mono font-semibold text-slate-600 bg-slate-100 px-2 py-1 rounded">#{{ issue.id }}</span>
                  <span
                    class="px-3 py-1 rounded-full text-xs font-bold"
                    :class="getStatusBadgeClass(issue.status.name)"
                  >
                    {{ issue.status.name }}
                  </span>
                </div>

                <!-- Título -->
                <h4 class="text-sm font-bold text-slate-800 mb-3 line-clamp-2 leading-snug">
                  {{ issue.subject }}
                </h4>

                <!-- Tracker -->
                <div class="flex items-center justify-between">
                  <span class="text-xs px-3 py-1 bg-gradient-to-r from-blue-100 to-indigo-100 border border-blue-200 rounded-lg text-blue-800 font-semibold">
                    {{ issue.tracker.name }}
                  </span>

                  <!-- Dias parado -->
                  <span
                    v-if="issue.days_stale > 0"
                    class="text-xs font-bold px-2 py-1 rounded-full"
                    :class="{
                      'bg-yellow-100 text-yellow-700 border border-yellow-300': issue.days_stale >= 3 && issue.days_stale < 7,
                      'bg-red-100 text-red-700 border border-red-300': issue.days_stale >= 7,
                      'bg-slate-100 text-slate-600 border border-slate-200': issue.days_stale < 3,
                    }"
                  >
                    {{ issue.days_stale }}d
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Estado vazio -->
        <div v-if="Object.keys(filteredIssues).length === 0" class="text-center py-20 bg-gradient-to-br from-white to-blue-50 rounded-xl shadow-xl border-2 border-blue-100">
          <svg class="w-32 h-32 mx-auto text-blue-200 mb-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
          </svg>
          <h3 class="text-2xl font-bold bg-gradient-to-r from-slate-700 to-blue-700 bg-clip-text text-transparent mb-3">
            Nenhuma atividade encontrada
          </h3>
          <p class="text-slate-600 text-lg mb-6">Tente limpar os filtros ou aguarde novas tarefas.</p>
          <button
            v-if="selectedUser || selectedStatuses.length > 0"
            @click="clearAllFilters"
            class="px-6 py-3 bg-gradient-to-r from-blue-600 to-indigo-600 text-white rounded-lg hover:from-blue-700 hover:to-indigo-700 transition-all shadow-md hover:shadow-lg font-semibold"
          >
            Limpar Filtros
          </button>
        </div>
      </div>
    </main>

    <!-- Modal de Detalhes -->
    <IssueModal
      v-if="selectedIssue"
      :issue="selectedIssue"
      :is-open="isModalOpen"
      @close="closeModal"
    />

    <!-- Modal de Criar/Editar Issue -->
    <IssueFormModal
      :is-open="isFormModalOpen"
      :issue="editingIssue"
      @close="closeFormModal"
      @success="handleFormSuccess"
    />
  </div>
</template>

<script setup lang="ts">
/**
 * Tela 1: Atividades do Time
 * Mostra todas as atividades agrupadas por pessoa
 */

const redmine = useRedmine()

const loading = ref(true)
const error = ref('')
const selectedUser = ref('')
const selectedStatuses = ref([])
const users = ref([])
const issuesByUser = ref({})

const totalCount = ref(0)
const inProgressCount = ref(0)
const awaitingDeployCount = ref(0)
const activeUsersCount = ref(0)

// Lista de status disponíveis (IDs do Redmine)
const availableStatuses = ref([
  { id: 1, name: 'New' },
  { id: 2, name: 'Awaiting Check' },
  { id: 3, name: 'In Progress' },
  { id: 7, name: 'Ready to Check' },
  { id: 8, name: 'Awaiting Deploy' },
  { id: 9, name: 'On Staging' },
  { id: 10, name: 'On Hold' },
  { id: 5, name: 'Closed' },
])

/**
 * Busca atividades do time
 */
const fetchData = async () => {
  loading.value = true
  error.value = ''

  try {
    const filters: any = {}

    if (selectedUser.value) {
      filters.assigned_to_id = selectedUser.value
    }

    if (selectedStatuses.value.length > 0) {
      filters.status_id = selectedStatuses.value.join(',')
    }

    const data = await redmine.fetchAtividadesTime(filters)

    issuesByUser.value = data.issues_by_user || {}

    // Extrair lista de usuários únicos
    const usersSet = new Set()
    Object.values(issuesByUser.value).forEach((userData: any) => {
      if (userData.user.name) {
        usersSet.add(JSON.stringify(userData.user))
      }
    })
    users.value = Array.from(usersSet).map((u: any) => JSON.parse(u))

    // Calcular estatísticas
    calculateStats()
  } catch (e: any) {
    console.error('Erro ao buscar atividades:', e)
    error.value = e.message || 'Erro ao buscar atividades. Tente novamente.'
  } finally {
    loading.value = false
  }
}

/**
 * Calcula estatísticas
 */
const calculateStats = () => {
  let total = 0
  let inProgress = 0
  let awaitingDeploy = 0

  Object.values(issuesByUser.value).forEach((userData: any) => {
    total += userData.issues.length

    userData.issues.forEach((issue: any) => {
      if (issue.status.name.toLowerCase().includes('progress')) {
        inProgress++
      }
      if (issue.status.name.toLowerCase().includes('deploy')) {
        awaitingDeploy++
      }
    })
  })

  totalCount.value = total
  inProgressCount.value = inProgress
  awaitingDeployCount.value = awaitingDeploy
  activeUsersCount.value = Object.keys(issuesByUser.value).length
}

/**
 * Issues filtradas
 */
const filteredIssues = computed(() => {
  if (!selectedUser.value) return issuesByUser.value

  return Object.fromEntries(
    Object.entries(issuesByUser.value).filter(([userId, userData]: any) => {
      return userData.user.id === parseInt(selectedUser.value)
    })
  )
})

/**
 * Limpa filtro de status
 */
const clearStatusFilter = () => {
  selectedStatuses.value = []
  fetchData()
}

/**
 * Limpa todos os filtros
 */
const clearAllFilters = () => {
  selectedUser.value = ''
  selectedStatuses.value = []
  fetchData()
}

/**
 * Abre modal com detalhes da issue
 */
const handleIssueClick = (issue: any) => {
  selectedIssue.value = issue
  isModalOpen.value = true
}

/**
 * Fecha modal
 */
const closeModal = () => {
  isModalOpen.value = false
  selectedIssue.value = null
}

/**
 * Retorna classe de borda por prioridade
 */
const getPriorityBorderClass = (priority: string) => {
  const p = priority.toLowerCase()
  if (p.includes('urgent') || p.includes('immediate')) return 'border-l-4 !border-l-red-600 shadow-lg shadow-red-200'
  if (p.includes('high')) return 'border-l-4 !border-l-orange-600 shadow-lg shadow-orange-200'
  if (p.includes('low')) return 'border-l-4 !border-l-emerald-600 shadow-lg shadow-emerald-200'
  return 'border-l-4 !border-l-blue-700 shadow-lg shadow-blue-200'
}

/**
 * Retorna classe de badge por status
 */
const getStatusBadgeClass = (status: string) => {
  const s = status.toLowerCase()
  if (s.includes('progress')) return 'bg-gradient-to-r from-indigo-100 to-indigo-200 text-indigo-800 border border-indigo-300'
  if (s.includes('check')) return 'bg-gradient-to-r from-red-100 to-red-200 text-red-800 border border-red-300'
  if (s.includes('deploy')) return 'bg-gradient-to-r from-cyan-100 to-cyan-200 text-cyan-800 border border-cyan-300'
  if (s.includes('staging')) return 'bg-gradient-to-r from-pink-100 to-pink-200 text-pink-800 border border-pink-300'
  if (s.includes('hold')) return 'bg-gradient-to-r from-slate-100 to-slate-200 text-slate-800 border border-slate-300'
  if (s.includes('new')) return 'bg-gradient-to-r from-emerald-100 to-emerald-200 text-emerald-800 border border-emerald-300'
  if (s.includes('done') || s.includes('closed')) return 'bg-gradient-to-r from-green-100 to-green-200 text-green-800 border border-green-300'
  return 'bg-gradient-to-r from-blue-100 to-blue-200 text-blue-800 border border-blue-300'
}

// Middleware de autenticação
definePageMeta({
  middleware: 'auth',
})

// Estado do modal de detalhes
const selectedIssue = ref<any>(null)
const isModalOpen = ref(false)

// Estado do modal de criar/editar
const isFormModalOpen = ref(false)
const editingIssue = ref<any>(null)

/**
 * Abre modal para criar issue
 */
const openCreateModal = () => {
  editingIssue.value = null
  isFormModalOpen.value = true
}

/**
 * Fecha modal de criar/editar
 */
const closeFormModal = () => {
  isFormModalOpen.value = false
  editingIssue.value = null
}

/**
 * Callback de sucesso ao criar/editar issue
 */
const handleFormSuccess = () => {
  fetchData()
}

// Buscar dados ao montar
onMounted(() => {
  fetchData()
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
