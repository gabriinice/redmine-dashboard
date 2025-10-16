<template>
  <div class="px-4">
    <main>
      <!-- Cabeçalho -->
      <div class="mb-8 flex items-start justify-between">
        <div>
          <p class="mt-2 text-lg text-gray-600">
            Organize suas user stories na sprint atual
          </p>
        </div>
        <div class="flex items-center space-x-3">
          <button
            @click="openCreateModal"
            :disabled="loading"
            class="flex items-center space-x-2 px-5 py-2.5 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-lg hover:from-green-600 hover:to-green-700 transition-all shadow-lg hover:shadow-xl font-semibold"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
            <span>Nova User Story</span>
          </button>
          <button
            @click="createNewSprint"
            :disabled="loading"
            class="flex items-center space-x-2 px-4 py-2 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-lg hover:from-blue-600 hover:to-blue-700 transition-all shadow-md"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
            <span>Nova Sprint</span>
          </button>
          <button
            @click="fetchData"
            :disabled="loading"
            class="flex items-center space-x-2 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition-colors disabled:opacity-50"
          >
            <svg class="w-5 h-5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
            </svg>
            <span>{{ loading ? 'Atualizando...' : 'Atualizar' }}</span>
          </button>
        </div>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="flex justify-center items-center py-20">
        <div class="text-center">
          <div class="spinner w-12 h-12 mx-auto mb-4"></div>
          <p class="text-gray-600">Carregando...</p>
        </div>
      </div>

      <!-- Erro -->
      <div v-else-if="error" class="alert-danger">
        <p class="font-medium">Erro ao carregar dados</p>
        <p class="text-sm mt-1">{{ error }}</p>
      </div>

      <!-- Grid: Backlog e Sprint -->
      <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Backlog (User Stories sem sprint) -->
        <div class="bg-white rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-xl font-bold text-gray-900">Backlog</h3>
            <span class="px-3 py-1 bg-gray-100 text-gray-700 rounded-full text-sm font-semibold">
              {{ backlogIssues.length }} stories
            </span>
          </div>

          <div
            ref="backlogContainer"
            class="space-y-3 min-h-[400px] max-h-[600px] overflow-y-auto pr-2"
          >
            <div
              v-for="issue in backlogIssues"
              :key="issue.id"
              :data-issue-id="issue.id"
              draggable="true"
              @dragstart="handleDragStart($event, issue)"
              @dragend="handleDragEnd"
              @click="openIssueModal(issue)"
              class="bg-gray-50 border-2 border-gray-200 rounded-lg p-4 cursor-pointer hover:border-purple-400 hover:shadow-lg transition-all"
            >
              <div class="flex items-start justify-between mb-2">
                <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
                <span class="text-xs px-2 py-1 bg-blue-100 text-blue-700 rounded font-semibold">
                  {{ issue.tracker.name }}
                </span>
              </div>
              <h4 class="text-sm font-semibold text-gray-900 mb-2">{{ issue.subject }}</h4>
              <div class="flex items-center justify-between text-xs text-gray-600">
                <span>{{ issue.assigned_to?.name || 'Não atribuído' }}</span>
                <input
                  type="number"
                  v-model.number="issue.story_points"
                  @click.stop
                  placeholder="SP"
                  min="0"
                  max="100"
                  class="w-16 px-2 py-1 border border-gray-300 rounded text-center"
                />
              </div>
            </div>

            <div v-if="backlogIssues.length === 0" class="text-center py-12 text-gray-500">
              <svg class="w-16 h-16 mx-auto mb-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
              </svg>
              <p>Nenhuma user story no backlog</p>
            </div>
          </div>
        </div>

        <!-- Sprint Atual -->
        <div class="bg-white rounded-lg shadow-sm p-6">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-xl font-bold text-gray-900">Sprint Atual</h3>
            <span class="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-sm font-semibold">
              {{ sprintIssues.length }} stories
            </span>
          </div>

          <div
            ref="sprintContainer"
            @drop="handleDropSprint"
            @dragover="handleDragOver"
            @dragleave="handleDragLeave"
            class="space-y-3 min-h-[400px] max-h-[600px] overflow-y-auto pr-2 border-2 border-dashed border-gray-300 rounded-lg p-4"
            :class="{ 'border-purple-500 bg-purple-50': isDraggingOver }"
          >
            <div
              v-for="issue in sprintIssues"
              :key="issue.id"
              :data-issue-id="issue.id"
              draggable="true"
              @dragstart="handleDragStart($event, issue)"
              @dragend="handleDragEnd"
              @click="openIssueModal(issue)"
              class="bg-purple-50 border-2 border-purple-200 rounded-lg p-4 cursor-pointer hover:border-purple-500 hover:shadow-lg transition-all"
            >
              <div class="flex items-start justify-between mb-2">
                <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
                <div class="flex items-center space-x-2">
                  <span class="text-xs px-2 py-1 bg-blue-100 text-blue-700 rounded font-semibold">
                    {{ issue.tracker.name }}
                  </span>
                  <button
                    @click.stop="removeFromSprint(issue)"
                    class="text-red-500 hover:text-red-700"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                  </button>
                </div>
              </div>
              <h4 class="text-sm font-semibold text-gray-900 mb-2">{{ issue.subject }}</h4>
              <div class="flex items-center justify-between text-xs text-gray-600">
                <span>{{ issue.assigned_to?.name || 'Não atribuído' }}</span>
                <span class="px-2 py-1 bg-purple-200 text-purple-800 rounded font-bold">
                  {{ issue.story_points || 0 }} SP
                </span>
              </div>
            </div>

            <div v-if="sprintIssues.length === 0" class="text-center py-12 text-gray-400">
              <svg class="w-16 h-16 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
              </svg>
              <p>Arraste user stories para cá</p>
            </div>
          </div>

          <!-- Botão Salvar Sprint -->
          <div class="mt-4">
            <button
              @click="saveSprint"
              :disabled="saving || sprintIssues.length === 0"
              class="w-full px-4 py-3 bg-gradient-to-r from-purple-600 to-purple-700 text-white rounded-lg hover:from-purple-700 hover:to-purple-800 transition-all disabled:opacity-50 disabled:cursor-not-allowed font-semibold"
            >
              {{ saving ? 'Salvando...' : 'Salvar Sprint' }}
            </button>
          </div>
        </div>
      </div>
    </main>

    <!-- Issue Form Modal (Create/Edit) -->
    <IssueFormModal
      :is-open="isCreateModalOpen"
      :issue="editingIssue"
      @close="closeCreateModal"
      @success="handleIssueCreated"
    />

    <!-- Issue View Modal -->
    <IssueModal
      v-if="selectedIssue"
      :is-open="isViewModalOpen"
      :issue="selectedIssue"
      @close="closeIssueModal"
    />
  </div>
</template>

<script setup lang="ts">
const redmine = useRedmine()

const loading = ref(true)
const saving = ref(false)
const error = ref('')
const isDraggingOver = ref(false)
const draggedIssue = ref<any>(null)

const backlogIssues = ref<any[]>([])
const sprintIssues = ref<any[]>([])

const currentSprint = ref({
  id: null,
  name: 'Sprint 1'
})

// Modal states
const isCreateModalOpen = ref(false)
const isViewModalOpen = ref(false)
const selectedIssue = ref<any>(null)
const editingIssue = ref<any>(null)

/**
 * Total de story points na sprint
 */
const sprintTotalPoints = computed(() => {
  return sprintIssues.value.reduce((total, issue) => {
    return total + (parseInt(issue.story_points) || 0)
  }, 0)
})

/**
 * Busca dados
 */
const fetchData = async () => {
  loading.value = true
  error.value = ''

  try {
    console.log('Buscando user stories do backlog...')

    // Buscar user stories (tracker_id=3) sem sprint (fixed_version_id vazio)
    // Se não encontrar com tracker_id=3, buscar todos os trackers
    const result = await redmine.fetchIssues({
      tracker_id: 3, // User Story (pode ser diferente em cada Redmine)
      status_id: '1|2|3', // New, Awaiting Check, In Progress (pipe syntax)
      limit: 100
    })

    console.log('Resultado da API:', result)
    console.log('Issues encontradas:', result.issues?.length || 0)

    if (!result.issues || result.issues.length === 0) {
      console.warn('Nenhuma issue encontrada com os filtros atuais. Tentando buscar todas as issues abertas...')

      // Fallback: buscar todas as issues abertas sem filtro de tracker
      const fallbackResult = await redmine.fetchIssues({
        status_id: '1|2|3',
        limit: 100
      })

      console.log('Fallback - Issues encontradas:', fallbackResult.issues?.length || 0)

      backlogIssues.value = (fallbackResult.issues || []).map((issue: any) => ({
        ...issue,
        story_points: issue.story_points || 0
      }))
    } else {
      // Separar entre backlog e sprint
      // Por enquanto, todas vão para backlog (sem fixed_version_id)
      backlogIssues.value = (result.issues || []).map((issue: any) => ({
        ...issue,
        story_points: issue.story_points || 0
      }))
    }

    sprintIssues.value = []

    console.log('Backlog carregado com', backlogIssues.value.length, 'issues')
  } catch (e: any) {
    console.error('Erro ao buscar dados:', e)
    error.value = e.message || 'Erro ao carregar dados'
  } finally {
    loading.value = false
  }
}

/**
 * Drag start
 */
const handleDragStart = (event: DragEvent, issue: any) => {
  draggedIssue.value = issue
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'move'
    event.dataTransfer.setData('text/html', (event.target as HTMLElement).innerHTML)
  }
}

/**
 * Drag end
 */
const handleDragEnd = () => {
  isDraggingOver.value = false
}

/**
 * Drag over
 */
const handleDragOver = (event: DragEvent) => {
  event.preventDefault()
  isDraggingOver.value = true
  if (event.dataTransfer) {
    event.dataTransfer.dropEffect = 'move'
  }
}

/**
 * Drag leave
 */
const handleDragLeave = () => {
  isDraggingOver.value = false
}

/**
 * Drop na sprint
 */
const handleDropSprint = (event: DragEvent) => {
  event.preventDefault()
  isDraggingOver.value = false

  if (!draggedIssue.value) return

  // Remover do backlog
  const index = backlogIssues.value.findIndex((i) => i.id === draggedIssue.value.id)
  if (index !== -1) {
    const issue = backlogIssues.value.splice(index, 1)[0]

    // Adicionar na sprint
    sprintIssues.value.push(issue)
  }

  draggedIssue.value = null
}

/**
 * Remove issue da sprint
 */
const removeFromSprint = (issue: any) => {
  const index = sprintIssues.value.findIndex((i) => i.id === issue.id)
  if (index !== -1) {
    const removedIssue = sprintIssues.value.splice(index, 1)[0]
    backlogIssues.value.push(removedIssue)
  }
}

/**
 * Salva sprint
 */
const saveSprint = async () => {
  saving.value = true

  try {
    // Aqui você atualizaria cada issue com a sprint (fixed_version_id)
    // Por enquanto, apenas simulando
    await new Promise((resolve) => setTimeout(resolve, 1000))

    alert(`Sprint salva com sucesso! Total: ${sprintTotalPoints.value} story points`)
  } catch (e: any) {
    console.error('Erro ao salvar sprint:', e)
    alert('Erro ao salvar sprint')
  } finally {
    saving.value = false
  }
}

/**
 * Abre modal para criar nova user story
 */
const openCreateModal = () => {
  editingIssue.value = null
  isCreateModalOpen.value = true
}

/**
 * Fecha modal de criação
 */
const closeCreateModal = () => {
  isCreateModalOpen.value = false
  editingIssue.value = null
}

/**
 * Handler quando issue é criada com sucesso
 */
const handleIssueCreated = () => {
  closeCreateModal()
  fetchData() // Recarrega dados para mostrar nova issue
}

/**
 * Abre modal para visualizar issue
 */
const openIssueModal = async (issue: any) => {
  try {
    // Buscar detalhes completos da issue incluindo journals/comentários
    const result = await redmine.fetchIssue(issue.id, true)
    selectedIssue.value = result.issue
    isViewModalOpen.value = true
  } catch (e: any) {
    console.error('Erro ao buscar detalhes da issue:', e)
    alert('Erro ao carregar detalhes da issue')
  }
}

/**
 * Fecha modal de visualização
 */
const closeIssueModal = () => {
  isViewModalOpen.value = false
  selectedIssue.value = null
}

/**
 * Cria nova sprint
 */
const createNewSprint = () => {
  const name = prompt('Nome da nova sprint:', `Sprint ${Date.now()}`)
  if (name) {
    currentSprint.value = {
      id: Date.now(),
      name
    }
    alert('Sprint criada! (Em produção, isso criaria uma versão no Redmine)')
  }
}

// Middleware de autenticação
definePageMeta({
  middleware: 'auth',
})

// Buscar dados ao montar
onMounted(() => {
  fetchData()
})
</script>

<style scoped>
/* Estilo para drag and drop */
[draggable="true"] {
  user-select: none;
}

.spinner {
  border: 3px solid rgba(0, 0, 0, 0.1);
  border-top-color: #9333ea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Scrollbar customizada */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb {
  background: #9333ea;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #7e22ce;
}
</style>
