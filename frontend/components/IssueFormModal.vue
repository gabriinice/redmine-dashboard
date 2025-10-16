<template>
  <div v-if="isOpen" class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="flex min-h-screen items-end justify-center px-4 pt-4 pb-20 text-center sm:block sm:p-0">
      <!-- Overlay -->
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" @click="close"></div>

      <!-- Centralização -->
      <span class="hidden sm:inline-block sm:h-screen sm:align-middle" aria-hidden="true">&#8203;</span>

      <!-- Modal -->
      <div class="relative inline-block transform overflow-hidden rounded-lg bg-white text-left align-bottom shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-4xl sm:align-middle">
        <!-- Header -->
        <div class="bg-gradient-to-r from-purple-600 to-purple-700 px-6 py-4">
          <div class="flex items-center justify-between">
            <h3 class="text-xl font-bold text-white">
              {{ isEditing ? 'Editar Issue' : 'Nova Issue' }}
            </h3>
            <button @click="close" class="text-white hover:text-gray-200 transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Formulário -->
        <form @submit.prevent="handleSubmit" class="bg-white px-6 py-6">
          <div class="space-y-6">
            <!-- Linha 1: Projeto e Tracker -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <!-- Projeto -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Projeto <span class="text-red-500">*</span>
                </label>
                <select
                  v-model="form.project_id"
                  required
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Selecione...</option>
                  <option v-for="project in projects" :key="project.id" :value="project.id">
                    {{ project.name }}
                  </option>
                </select>
              </div>

              <!-- Tracker -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Tipo <span class="text-red-500">*</span>
                </label>
                <select
                  v-model="form.tracker_id"
                  required
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Selecione...</option>
                  <option v-for="tracker in trackers" :key="tracker.id" :value="tracker.id">
                    {{ tracker.name }}
                  </option>
                </select>
              </div>
            </div>

            <!-- Título -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Título <span class="text-red-500">*</span>
              </label>
              <input
                v-model="form.subject"
                type="text"
                required
                placeholder="Ex: Adicionar filtro por status no dashboard"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
              />
            </div>

            <!-- Descrição -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Descrição
              </label>
              <textarea
                v-model="form.description"
                rows="6"
                placeholder="Descreva a tarefa em detalhes..."
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 font-mono text-sm"
              ></textarea>
            </div>

            <!-- Linha 2: Status, Prioridade e Atribuído -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <!-- Status -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Status
                </label>
                <select
                  v-model="form.status_id"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Padrão</option>
                  <option v-for="status in statuses" :key="status.id" :value="status.id">
                    {{ status.name }}
                  </option>
                </select>
              </div>

              <!-- Prioridade -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Prioridade
                </label>
                <select
                  v-model="form.priority_id"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Padrão</option>
                  <option v-for="priority in priorities" :key="priority.id" :value="priority.id">
                    {{ priority.name }}
                  </option>
                </select>
              </div>

              <!-- Atribuído -->
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Atribuído a
                </label>
                <select
                  v-model="form.assigned_to_id"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
                >
                  <option value="">Ninguém</option>
                  <option v-for="user in users" :key="user.id" :value="user.id">
                    {{ user.name }}
                  </option>
                </select>
              </div>
            </div>

            <!-- Story Points -->
            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Story Points
              </label>
              <input
                v-model.number="form.story_points"
                type="number"
                min="0"
                max="100"
                placeholder="Ex: 5"
                class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500"
              />
            </div>

            <!-- Mensagem de erro -->
            <div v-if="errorMessage" class="bg-red-50 border border-red-200 rounded-lg p-4">
              <p class="text-sm text-red-600">{{ errorMessage }}</p>
            </div>
          </div>

          <!-- Footer -->
          <div class="mt-8 flex items-center justify-between gap-4">
            <button
              v-if="form.description"
              type="button"
              @click="reviewWithAI"
              :disabled="loading || aiReviewing"
              class="px-6 py-2 bg-gradient-to-r from-blue-500 to-blue-600 text-white rounded-lg hover:from-blue-600 hover:to-blue-700 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
            >
              <svg class="w-5 h-5" :class="{ 'animate-spin': aiReviewing }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
              </svg>
              <span>{{ aiReviewing ? 'Revisando...' : 'Revisar com IA' }}</span>
            </button>

            <div class="flex-1"></div>

            <button
              type="button"
              @click="close"
              :disabled="loading"
              class="px-6 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors disabled:opacity-50"
            >
              Cancelar
            </button>

            <button
              type="submit"
              :disabled="loading"
              class="px-6 py-2 bg-gradient-to-r from-purple-600 to-purple-700 text-white rounded-lg hover:from-purple-700 hover:to-purple-800 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center space-x-2"
            >
              <svg v-if="loading" class="animate-spin w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"></path>
              </svg>
              <span>{{ loading ? 'Salvando...' : (isEditing ? 'Salvar Alterações' : 'Criar Issue') }}</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const props = defineProps({
  isOpen: {
    type: Boolean,
    required: true
  },
  issue: {
    type: Object,
    default: null
  }
})

const emit = defineEmits(['close', 'success'])

const redmine = useRedmine()

const loading = ref(false)
const aiReviewing = ref(false)
const errorMessage = ref('')

const isEditing = computed(() => props.issue !== null)

// Formulário
const form = ref({
  project_id: '',
  tracker_id: '',
  subject: '',
  description: '',
  status_id: '',
  priority_id: '',
  assigned_to_id: '',
  story_points: null
})

// Listas de opções
const projects = ref([
  { id: 1, name: 'Brobot Platform' },
  { id: 2, name: 'Internal Tools' }
])

const trackers = ref([
  { id: 1, name: 'Bug' },
  { id: 2, name: 'Feature' },
  { id: 3, name: 'User Story' },
  { id: 4, name: 'Task' }
])

const statuses = ref([
  { id: 1, name: 'New' },
  { id: 2, name: 'Awaiting Check' },
  { id: 3, name: 'In Progress' },
  { id: 7, name: 'Ready to Check' },
  { id: 8, name: 'Awaiting Deploy' },
  { id: 9, name: 'On Staging' },
  { id: 10, name: 'On Hold' }
])

const priorities = ref([
  { id: 1, name: 'Low' },
  { id: 2, name: 'Normal' },
  { id: 3, name: 'High' },
  { id: 4, name: 'Urgent' },
  { id: 5, name: 'Immediate' }
])

const users = ref([
  { id: 1, name: 'Rolf' },
  { id: 2, name: 'Gabriel' },
  { id: 3, name: 'Pedro' }
])

/**
 * Reseta formulário
 */
const resetForm = () => {
  form.value = {
    project_id: '',
    tracker_id: '',
    subject: '',
    description: '',
    status_id: '',
    priority_id: '',
    assigned_to_id: '',
    story_points: null
  }
  errorMessage.value = ''
}

/**
 * Inicializa formulário com dados da issue (se editing)
 */
watch(() => props.issue, (newIssue) => {
  if (newIssue) {
    form.value = {
      project_id: newIssue.project?.id || '',
      tracker_id: newIssue.tracker?.id || '',
      subject: newIssue.subject || '',
      description: newIssue.description || '',
      status_id: newIssue.status?.id || '',
      priority_id: newIssue.priority?.id || '',
      assigned_to_id: newIssue.assigned_to?.id || '',
      story_points: null
    }
  } else {
    resetForm()
  }
}, { immediate: true })

/**
 * Fecha modal
 */
const close = () => {
  if (!loading.value) {
    resetForm()
    emit('close')
  }
}

/**
 * Submete formulário
 */
const handleSubmit = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    if (isEditing.value) {
      await redmine.updateIssue(props.issue.id, form.value)
    } else {
      await redmine.createIssue(form.value)
    }

    emit('success')
    close()
  } catch (error: any) {
    console.error('Erro ao salvar issue:', error)
    errorMessage.value = error.message || 'Erro ao salvar issue. Tente novamente.'
  } finally {
    loading.value = false
  }
}

/**
 * Revisa descrição com IA
 */
const reviewWithAI = async () => {
  if (!form.value.description) return

  aiReviewing.value = true
  errorMessage.value = ''

  try {
    const result = await redmine.reviewStoryWithAI({
      subject: form.value.subject,
      description: form.value.description
    })

    if (result.improved_description) {
      form.value.description = result.improved_description
    }

    if (result.improved_subject) {
      form.value.subject = result.improved_subject
    }
  } catch (error: any) {
    console.error('Erro ao revisar com IA:', error)
    errorMessage.value = 'Erro ao revisar com IA. Tente novamente.'
  } finally {
    aiReviewing.value = false
  }
}
</script>
