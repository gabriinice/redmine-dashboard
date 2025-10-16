<template>
  <div class="px-4 pt-6">
    <main>
      <!-- Cabeçalho com destaque -->
      <div class="mb-8 flex items-start justify-between">
        <div class="flex items-center space-x-4 mb-4">
          <div class="bg-red-500 rounded-full p-3">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
            </svg>
          </div>
          <div>
            <p class="mt-1 text-lg text-gray-600">
              Issues que precisam de atenção URGENTE
            </p>
          </div>
        </div>
        <button
          @click="fetchAlertas"
          :disabled="loading"
          class="flex items-center space-x-2 px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <svg class="w-5 h-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
          </svg>
          <span>{{ loading ? 'Atualizando...' : 'Atualizar' }}</span>
        </button>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center items-center py-20">
        <div class="text-center">
          <div class="spinner w-12 h-12 mx-auto mb-4"></div>
          <p class="text-gray-600">Carregando alertas...</p>
        </div>
      </div>

      <!-- Erro -->
      <div v-else-if="error" class="alert-danger">
        <p class="font-medium">Erro ao carregar alertas</p>
        <p class="text-sm mt-1">{{ error }}</p>
      </div>

      <!-- Conteúdo -->
      <div v-else>
        <!-- Alerta principal -->
        <div
          v-if="totalCount > 0"
          class="mb-6 bg-gradient-to-r from-red-500 to-red-600 rounded-lg shadow-lg p-6 text-white"
        >
          <div class="flex items-center justify-between">
            <div class="flex items-center space-x-4">
              <div class="bg-white bg-opacity-20 rounded-full p-4">
                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                </svg>
              </div>
              <div>
                <p class="text-5xl font-bold mb-2">{{ totalCount }}</p>
                <p class="text-xl text-red-100">
                  {{ totalCount === 1 ? 'Issue precisa' : 'Issues precisam' }} ser verificada{{ totalCount === 1 ? '' : 's' }}
                </p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-2xl font-bold">{{ urgentCount }}</p>
              <p class="text-sm text-red-100">Urgentes (7+ dias)</p>
            </div>
          </div>
        </div>

        <!-- Filtros rápidos -->
        <div class="mb-6 flex space-x-4">
          <button
            @click="filterBy = 'all'"
            :class="filterBy === 'all' ? 'bg-blue-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
            class="px-4 py-2 rounded-lg font-medium transition-colors"
          >
            Todos ({{ totalCount }})
          </button>
          <button
            @click="filterBy = 'urgent'"
            :class="filterBy === 'urgent' ? 'bg-red-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
            class="px-4 py-2 rounded-lg font-medium transition-colors"
          >
            Urgentes ({{ urgentCount }})
          </button>
          <button
            @click="filterBy = 'warning'"
            :class="filterBy === 'warning' ? 'bg-yellow-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
            class="px-4 py-2 rounded-lg font-medium transition-colors"
          >
            Atenção ({{ warningCount }})
          </button>
          <button
            @click="filterBy = 'recent'"
            :class="filterBy === 'recent' ? 'bg-gray-600 text-white' : 'bg-white text-gray-700 hover:bg-gray-50'"
            class="px-4 py-2 rounded-lg font-medium transition-colors"
          >
            Recentes ({{ recentCount }})
          </button>
        </div>

        <!-- Lista de alertas -->
        <div class="space-y-4">
          <div
            v-for="alert in filteredAlerts"
            :key="alert.id"
            class="bg-white rounded-lg shadow-sm hover:shadow-xl transition-all cursor-pointer overflow-hidden"
            :class="{
              'ring-4 ring-red-500 ring-opacity-50': alert.days_stale >= 7,
              'ring-2 ring-yellow-500 ring-opacity-50': alert.days_stale >= 3 && alert.days_stale < 7,
            }"
            @click="handleAlertClick(alert)"
          >
            <div class="flex">
              <!-- Barra lateral colorida -->
              <div
                class="w-2"
                :class="{
                  'bg-red-600': alert.days_stale >= 7,
                  'bg-yellow-500': alert.days_stale >= 3 && alert.days_stale < 7,
                  'bg-blue-500': alert.days_stale < 3,
                }"
              ></div>

              <!-- Conteúdo -->
              <div class="flex-1 p-6">
                <div class="flex items-start justify-between">
                  <!-- Informações principais -->
                  <div class="flex-1 mr-6">
                    <!-- Badges -->
                    <div class="flex items-center space-x-3 mb-3">
                      <span class="text-sm font-mono text-gray-500 bg-gray-100 px-3 py-1 rounded">
                        #{{ alert.id }}
                      </span>
                      <span
                        class="text-xs px-3 py-1 rounded-full font-semibold"
                        :class="getTrackerBadgeClass(alert.tracker.name)"
                      >
                        {{ alert.tracker.name }}
                      </span>
                      <span class="text-xs px-3 py-1 rounded-full font-semibold bg-red-100 text-red-700">
                        TO CHECK
                      </span>
                      <span
                        class="text-xs px-3 py-1 rounded-full font-semibold"
                        :class="getPriorityBadgeClass(alert.priority.name)"
                      >
                        {{ alert.priority.name }}
                      </span>
                    </div>

                    <!-- Título -->
                    <h3 class="text-xl font-bold text-gray-900 mb-3">
                      {{ alert.subject }}
                    </h3>

                    <!-- Descrição -->
                    <p v-if="alert.description" class="text-sm text-gray-600 mb-4 line-clamp-2">
                      {{ alert.description }}
                    </p>

                    <!-- Rodapé -->
                    <div class="flex items-center space-x-6 text-sm text-gray-600">
                      <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                        <span class="font-medium">{{ alert.assigned_to?.name || 'Não atribuído' }}</span>
                      </div>
                      <div class="flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                        </svg>
                        <span>Atualizado há {{ alert.days_stale }} {{ alert.days_stale === 1 ? 'dia' : 'dias' }}</span>
                      </div>
                    </div>
                  </div>

                  <!-- Indicador de tempo parado -->
                  <div class="flex-shrink-0 text-center">
                    <div
                      class="w-24 h-24 rounded-full flex items-center justify-center mb-2"
                      :class="{
                        'bg-red-100': alert.days_stale >= 7,
                        'bg-yellow-100': alert.days_stale >= 3 && alert.days_stale < 7,
                        'bg-blue-100': alert.days_stale < 3,
                      }"
                    >
                      <div>
                        <p
                          class="text-4xl font-bold"
                          :class="{
                            'text-red-600': alert.days_stale >= 7,
                            'text-yellow-600': alert.days_stale >= 3 && alert.days_stale < 7,
                            'text-blue-600': alert.days_stale < 3,
                          }"
                        >
                          {{ alert.days_stale }}
                        </p>
                        <p
                          class="text-xs font-semibold"
                          :class="{
                            'text-red-600': alert.days_stale >= 7,
                            'text-yellow-600': alert.days_stale >= 3 && alert.days_stale < 7,
                            'text-blue-600': alert.days_stale < 3,
                          }"
                        >
                          {{ alert.days_stale === 1 ? 'DIA' : 'DIAS' }}
                        </p>
                      </div>
                    </div>
                    <p class="text-xs text-gray-500 font-medium">PARADO</p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Estado vazio -->
          <div v-if="filteredAlerts.length === 0" class="text-center py-20 bg-white rounded-lg shadow-sm">
            <svg class="w-24 h-24 mx-auto text-green-500 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
            </svg>
            <h3 class="text-2xl font-bold text-gray-900 mb-2">Tudo certo!</h3>
            <p class="text-gray-600">{{ filterBy === 'all' ? 'Nenhum alerta no momento' : 'Nenhum alerta nesta categoria' }}</p>
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
 * Tela 4: Alertas
 * Issues em "To Check" que precisam de atenção
 */

const redmine = useRedmine()

const loading = ref(true)
const error = ref('')
const totalCount = ref(0)
const alerts = ref([])
const filterBy = ref('all')

const urgentCount = computed(() => alerts.value.filter((a: any) => a.days_stale >= 7).length)
const warningCount = computed(() => alerts.value.filter((a: any) => a.days_stale >= 3 && a.days_stale < 7).length)
const recentCount = computed(() => alerts.value.filter((a: any) => a.days_stale < 3).length)

/**
 * Alertas filtrados
 */
const filteredAlerts = computed(() => {
  if (filterBy.value === 'urgent') {
    return alerts.value.filter((a: any) => a.days_stale >= 7)
  }
  if (filterBy.value === 'warning') {
    return alerts.value.filter((a: any) => a.days_stale >= 3 && a.days_stale < 7)
  }
  if (filterBy.value === 'recent') {
    return alerts.value.filter((a: any) => a.days_stale < 3)
  }
  return alerts.value
})

/**
 * Busca alertas
 */
const fetchAlertas = async () => {
  loading.value = true
  error.value = ''

  try {
    const data = await redmine.fetchAlertas()

    totalCount.value = data.total_count
    alerts.value = data.alerts || []
  } catch (e: any) {
    console.error('Erro ao buscar alertas:', e)
    error.value = e.message || 'Erro ao buscar alertas. Tente novamente.'
  } finally {
    loading.value = false
  }
}

/**
 * Abre modal com detalhes do alerta
 */
const handleAlertClick = (alert: any) => {
  selectedIssue.value = alert
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
 * Classes CSS
 */
const getTrackerBadgeClass = (tracker: string) => {
  const t = tracker.toLowerCase()
  if (t.includes('bug')) return 'bg-red-100 text-red-700'
  if (t.includes('feature')) return 'bg-blue-100 text-blue-700'
  if (t.includes('chore')) return 'bg-yellow-100 text-yellow-700'
  return 'bg-gray-100 text-gray-700'
}

const getPriorityBadgeClass = (priority: string) => {
  const p = priority.toLowerCase()
  if (p.includes('urgent')) return 'bg-red-200 text-red-800'
  if (p.includes('high')) return 'bg-orange-200 text-orange-800'
  if (p.includes('low')) return 'bg-green-200 text-green-800'
  return 'bg-blue-200 text-blue-800'
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
  fetchAlertas()
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
