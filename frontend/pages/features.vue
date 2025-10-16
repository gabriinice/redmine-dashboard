<template>
  <div class="px-4">
    <main>
      <!-- Cabeçalho -->
      <div class="mb-8 flex items-start justify-between">
        <div>
          <p class="mt-2 text-lg text-gray-600">
            Acompanhamento de todas as features Macro em desenvolvimento
          </p>
        </div>
        <button
          @click="fetchFeatures"
          :disabled="loading"
          class="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg class="w-5 h-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
          </svg>
          <span>{{ loading ? 'Atualizando...' : 'Atualizar' }}</span>
        </button>
      </div>

      <!-- Estatísticas rápidas -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-blue-500">
          <p class="text-sm font-medium text-gray-600 mb-1">Total de Features</p>
          <p class="text-4xl font-bold text-blue-600">{{ totalCount }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-red-500">
          <p class="text-sm font-medium text-gray-600 mb-1">To Check</p>
          <p class="text-4xl font-bold text-red-600">{{ getIssuesByStatus(29).length }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-purple-500">
          <p class="text-sm font-medium text-gray-600 mb-1">In Progress</p>
          <p class="text-4xl font-bold text-purple-600">{{ getIssuesByStatus(3).length }}</p>
        </div>
        <div class="bg-white rounded-lg shadow-sm p-6 border-l-4 border-teal-500">
          <p class="text-sm font-medium text-gray-600 mb-1">Awaiting Deploy</p>
          <p class="text-4xl font-bold text-teal-600">{{ getIssuesByStatus(5).length }}</p>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center items-center py-20">
        <div class="text-center">
          <div class="spinner w-12 h-12 mx-auto mb-4"></div>
          <p class="text-gray-600">Carregando features...</p>
        </div>
      </div>

      <!-- Erro -->
      <div v-else-if="error" class="alert-danger">
        <p class="font-medium">Erro ao carregar dados</p>
        <p class="text-sm mt-1">{{ error }}</p>
      </div>

      <!-- Kanban Board -->
      <div v-else class="overflow-x-auto pb-4">
        <div class="inline-flex space-x-4 min-w-full">
          <div
            v-for="column in statusColumns"
            :key="column.id"
            class="flex-shrink-0 bg-white rounded-lg shadow-sm"
            style="width: 320px;"
          >
            <!-- Cabeçalho da coluna -->
            <div class="px-4 py-4 border-b-2" :style="{ borderColor: column.color }">
              <div class="flex items-center justify-between mb-2">
                <h3 class="font-bold text-gray-900">{{ column.name }}</h3>
                <span
                  class="px-3 py-1 rounded-full text-sm font-bold text-white"
                  :style="{ backgroundColor: column.color }"
                >
                  {{ getIssuesByStatus(column.id).length }}
                </span>
              </div>
              <p class="text-xs text-gray-500">
                {{ getIssuesByStatus(column.id).length === 1 ? '1 feature' : `${getIssuesByStatus(column.id).length} features` }}
              </p>
            </div>

            <!-- Issues da coluna -->
            <div class="p-4 space-y-3" style="max-height: 600px; overflow-y: auto;">
              <div
                v-for="issue in getIssuesByStatus(column.id)"
                :key="issue.id"
                class="bg-gray-50 rounded-lg p-4 hover:shadow-lg transition-all cursor-pointer border-l-4"
                :class="getPriorityBorderClass(issue.priority.name)"
                @click="handleIssueClick(issue)"
              >
                <!-- Cabeçalho -->
                <div class="flex items-start justify-between mb-2">
                  <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
                  <span
                    class="w-3 h-3 rounded-full"
                    :class="getPriorityDotClass(issue.priority.name)"
                    :title="issue.priority.name"
                  ></span>
                </div>

                <!-- Título -->
                <h4 class="text-sm font-semibold text-gray-900 mb-3 line-clamp-3">
                  {{ issue.subject }}
                </h4>

                <!-- Rodapé -->
                <div class="space-y-2">
                  <!-- Usuário -->
                  <div v-if="issue.assigned_to" class="flex items-center space-x-2">
                    <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    <span class="text-xs text-gray-600 truncate">{{ issue.assigned_to.name }}</span>
                  </div>

                  <!-- Dias parado -->
                  <div v-if="issue.days_stale > 0" class="flex items-center justify-between">
                    <span class="text-xs text-gray-500">Tempo parado:</span>
                    <span
                      class="text-xs font-bold px-2 py-1 rounded"
                      :class="{
                        'bg-yellow-100 text-yellow-700': issue.days_stale >= 3 && issue.days_stale < 7,
                        'bg-red-100 text-red-700': issue.days_stale >= 7,
                        'bg-gray-100 text-gray-600': issue.days_stale < 3,
                      }"
                    >
                      {{ issue.days_stale }} {{ issue.days_stale === 1 ? 'dia' : 'dias' }}
                    </span>
                  </div>
                </div>
              </div>

              <!-- Coluna vazia -->
              <div v-if="getIssuesByStatus(column.id).length === 0" class="text-center py-8">
                <svg class="w-12 h-12 mx-auto text-gray-300 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                </svg>
                <p class="text-sm text-gray-400">Vazio</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Resumo -->
      <div class="mt-8 bg-white rounded-lg shadow-sm p-6">
        <h3 class="text-lg font-bold text-gray-900 mb-4">Resumo do Fluxo</h3>
        <div class="grid grid-cols-3 md:grid-cols-5 gap-4">
          <div class="text-center">
            <p class="text-2xl font-bold text-orange-600">{{ getIssuesByStatus(29).length + getIssuesByStatus(28).length }}</p>
            <p class="text-xs text-gray-600">Para Analisar</p>
          </div>
          <div class="text-center">
            <p class="text-2xl font-bold text-yellow-600">{{ getIssuesByStatus(30).length + getIssuesByStatus(31).length }}</p>
            <p class="text-xs text-gray-600">Para Planejar</p>
          </div>
          <div class="text-center">
            <p class="text-2xl font-bold text-blue-600">{{ getIssuesByStatus(1).length }}</p>
            <p class="text-xs text-gray-600">Pronto para Fazer</p>
          </div>
          <div class="text-center">
            <p class="text-2xl font-bold text-purple-600">{{ getIssuesByStatus(3).length }}</p>
            <p class="text-xs text-gray-600">Desenvolvimento</p>
          </div>
          <div class="text-center">
            <p class="text-2xl font-bold text-teal-600">{{ getIssuesByStatus(4).length + getIssuesByStatus(5).length }}</p>
            <p class="text-xs text-gray-600">Quase Pronto</p>
          </div>
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
  </div>
</template>

<script setup lang="ts">
/**
 * Tela 2: Features (Macro)
 * Exibe todas as features com cf_11 = Macro em um Kanban board
 */

const redmine = useRedmine()

const loading = ref(true)
const error = ref('')
const totalCount = ref(0)
const issuesByStatus = ref<Record<number, any>>({})
const statusColumns = ref([
  { id: 29, name: 'To Check', color: '#EF4444' },
  { id: 28, name: 'To Analyze', color: '#F97316' },
  { id: 30, name: 'To Prioritize', color: '#F59E0B' },
  { id: 31, name: 'To Estimate', color: '#EAB308' },
  { id: 1, name: 'To Do', color: '#3B82F6' },
  { id: 15, name: 'On Hold', color: '#6B7280' },
  { id: 3, name: 'In Progress', color: '#8B5CF6' },
  { id: 4, name: 'Staging', color: '#EC4899' },
  { id: 5, name: 'Awaiting Deploy', color: '#14B8A6' },
])

/**
 * Busca features do Redmine
 */
const fetchFeatures = async () => {
  loading.value = true
  error.value = ''

  try {
    const data = await redmine.fetchFeatures()

    totalCount.value = data.total_count
    issuesByStatus.value = data.issues_by_status || {}
  } catch (e: any) {
    console.error('Erro ao buscar features:', e)
    error.value = e.message || 'Erro ao buscar features. Tente novamente.'
  } finally {
    loading.value = false
  }
}

/**
 * Retorna issues de um status específico
 */
const getIssuesByStatus = (statusId: number) => {
  const statusData = issuesByStatus.value[statusId]
  return statusData?.issues || []
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
 * Classes CSS por prioridade
 */
const getPriorityBorderClass = (priority: string) => {
  const p = priority.toLowerCase()
  if (p.includes('urgent')) return '!border-l-red-500'
  if (p.includes('high')) return '!border-l-orange-500'
  if (p.includes('low')) return '!border-l-green-500'
  return '!border-l-blue-500'
}

const getPriorityDotClass = (priority: string) => {
  const p = priority.toLowerCase()
  if (p.includes('urgent')) return 'bg-red-500'
  if (p.includes('high')) return 'bg-orange-500'
  if (p.includes('low')) return 'bg-green-500'
  return 'bg-blue-500'
}

// Middleware de autenticação
definePageMeta({
  middleware: 'auth',
})

// Estado do modal
const selectedIssue = ref<any>(null)
const isModalOpen = ref(false)

// Buscar dados ao montar
onMounted(() => {
  fetchFeatures()
})
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>
