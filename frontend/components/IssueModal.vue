<template>
  <Teleport to="body">
    <Transition name="modal">
      <div
        v-if="isOpen"
        class="fixed inset-0 z-50 overflow-y-auto"
        @click.self="close"
      >
        <!-- Overlay -->
        <div class="fixed inset-0 bg-black bg-opacity-50 transition-opacity"></div>

        <!-- Modal -->
        <div class="flex min-h-screen items-center justify-center p-4">
          <div
            class="relative bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-hidden"
            @click.stop
          >
            <!-- Header -->
            <div class="sticky top-0 bg-white border-b px-6 py-4 flex items-center justify-between z-10">
              <div class="flex-1">
                <div class="flex items-center space-x-3">
                  <span class="text-sm font-mono text-gray-500">#{{ issue.id }}</span>
                  <span
                    class="px-2 py-1 rounded text-xs font-medium"
                    :style="{ backgroundColor: getStatusColor(issue.status.name), color: 'white' }"
                  >
                    {{ translateStatus(issue.status.name) }}
                  </span>
                  <span
                    class="px-2 py-1 rounded text-xs font-medium"
                    :class="getPriorityClass(issue.priority.name)"
                  >
                    {{ translatePriority(issue.priority.name) }}
                  </span>
                </div>
                <h2 class="text-xl font-bold text-gray-900 mt-2">
                  {{ issue.subject }}
                </h2>
              </div>
              <button
                @click="close"
                class="ml-4 text-gray-400 hover:text-gray-600 transition-colors"
              >
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
            </div>

            <!-- Content -->
            <div class="px-6 py-4 overflow-y-auto" style="max-height: calc(90vh - 140px);">
              <!-- Informações principais -->
              <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-6">
                <div>
                  <p class="text-sm font-medium text-gray-500">Tipo</p>
                  <p class="text-base text-gray-900">{{ translateTracker(issue.tracker.name) }}</p>
                </div>
                <div v-if="issue.assigned_to">
                  <p class="text-sm font-medium text-gray-500">Atribuído para</p>
                  <p class="text-base text-gray-900">{{ issue.assigned_to.name }}</p>
                </div>
                <div>
                  <p class="text-sm font-medium text-gray-500">Atualizado</p>
                  <p class="text-base text-gray-900">{{ formatDate(issue.updated_on) }}</p>
                </div>
                <div>
                  <p class="text-sm font-medium text-gray-500">Criado</p>
                  <p class="text-base text-gray-900">{{ formatDate(issue.created_on) }}</p>
                </div>
                <div v-if="issue.days_stale !== undefined">
                  <p class="text-sm font-medium text-gray-500">Tempo parado</p>
                  <p
                    class="text-base font-bold"
                    :class="{
                      'text-red-600': issue.days_stale >= 7,
                      'text-yellow-600': issue.days_stale >= 3 && issue.days_stale < 7,
                      'text-gray-600': issue.days_stale < 3,
                    }"
                  >
                    {{ issue.days_stale }} {{ issue.days_stale === 1 ? 'dia' : 'dias' }}
                  </p>
                </div>
              </div>

              <!-- Descrição -->
              <div v-if="issue.description" class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Descrição</h3>
                <div class="bg-gray-50 rounded-lg p-4">
                  <div class="text-sm text-gray-700 whitespace-pre-wrap description-content" v-html="renderDescription(issue.description, issue.attachments)"></div>
                </div>
              </div>

              <!-- Anexos -->
              <div v-if="issue.attachments && issue.attachments.length > 0" class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Anexos ({{ issue.attachments.length }})</h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div
                    v-for="attachment in issue.attachments"
                    :key="attachment.id"
                    class="bg-gray-50 rounded-lg p-3 border border-gray-200 hover:border-blue-400 transition-colors"
                  >
                    <!-- Informações do anexo -->
                    <div class="flex items-center justify-between">
                      <div class="flex items-center space-x-2 min-w-0 flex-1">
                        <svg class="w-5 h-5 text-gray-400 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13"></path>
                        </svg>
                        <div class="min-w-0 flex-1">
                          <p class="text-sm font-medium text-gray-700 truncate">{{ attachment.filename }}</p>
                          <p class="text-xs text-gray-500">{{ formatFileSize(attachment.filesize) }}</p>
                        </div>
                      </div>
                      <a
                        :href="attachment.content_url"
                        target="_blank"
                        class="ml-2 text-blue-600 hover:text-blue-700 flex-shrink-0"
                        title="Baixar"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path>
                        </svg>
                      </a>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Último comentário -->
              <div v-if="issue.last_comment" class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Último Comentário</h3>
                <div class="bg-blue-50 rounded-lg p-4 border-l-4 border-blue-500">
                  <div class="flex items-center space-x-2 mb-2">
                    <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                    </svg>
                    <span class="text-sm font-medium text-blue-900">{{ issue.last_comment.user?.name || 'Usuário' }}</span>
                    <span class="text-xs text-blue-600">{{ formatDate(issue.last_comment.created_on) }}</span>
                  </div>
                  <p class="text-sm text-gray-700 whitespace-pre-wrap">{{ issue.last_comment.notes }}</p>
                </div>
              </div>

              <!-- Sem comentários -->
              <div v-else class="mb-6">
                <h3 class="text-lg font-semibold text-gray-900 mb-2">Comentários</h3>
                <p class="text-sm text-gray-500 italic">Nenhum comentário ainda</p>
              </div>
            </div>

            <!-- Footer -->
            <div class="sticky bottom-0 bg-gray-50 border-t px-6 py-4 flex items-center justify-between">
              <a
                :href="`https://redmine.platform.brobot.com.br/issues/${issue.id}`"
                target="_blank"
                class="inline-flex items-center space-x-2 text-blue-600 hover:text-blue-700 font-medium"
              >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                </svg>
                <span>Abrir no Redmine</span>
              </a>
              <button
                @click="close"
                class="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors"
              >
                Fechar
              </button>
            </div>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
interface Props {
  issue: any
  isOpen: boolean
}

const props = defineProps<Props>()
const emit = defineEmits(['close'])

const close = () => {
  emit('close')
}

// Renderiza descrição com imagens inline
const renderDescription = (description: string, attachments: any[] = []) => {
  if (!description) return ''

  let html = description

  // Criar mapa de attachments por filename
  const attachmentMap: Record<string, string> = {}
  if (attachments && attachments.length > 0) {
    attachments.forEach((att: any) => {
      attachmentMap[att.filename] = att.content_url
    })
  }

  // Converter markdown de imagens: ![alt](filename.png) ou ![](filename.png)
  html = html.replace(/!\[([^\]]*)\]\(([^)]+)\)/g, (match, alt, filename) => {
    // Buscar URL completa do attachment
    const url = attachmentMap[filename] || `https://redmine.platform.brobot.com.br/attachments/download/${filename}`

    // Verificar se é imagem
    if (isImageFilename(filename)) {
      return `<img src="${url}" alt="${alt || filename}" class="max-w-full h-auto rounded-lg my-2 cursor-pointer" onclick="window.open('${url}', '_blank')" />`
    }

    // Se não for imagem, retornar link de download
    return `<a href="${url}" target="_blank" class="text-blue-600 hover:underline">${alt || filename}</a>`
  })

  // Converter quebras de linha
  html = html.replace(/\r\n/g, '\n').replace(/\n/g, '<br>')

  // Converter links simples
  html = html.replace(/(https?:\/\/[^\s<]+)/g, '<a href="$1" target="_blank" class="text-blue-600 hover:underline">$1</a>')

  // Converter negrito: *texto* ou **texto**
  html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>')
  html = html.replace(/\*([^*]+)\*/g, '<em>$1</em>')

  return html
}

// Verifica se é imagem pelo filename
const isImageFilename = (filename: string) => {
  if (!filename) return false
  const ext = filename.toLowerCase().split('.').pop()
  return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg', 'webp'].includes(ext || '')
}

// Formata tamanho de arquivo
const formatFileSize = (bytes: number) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

// Tradução de status
const translateStatus = (status: string) => {
  const translations: Record<string, string> = {
    'to check': 'Para Verificar',
    'to analyze': 'Para Analisar',
    'to prioritize': 'Para Priorizar',
    'to estimate': 'Para Estimar',
    'to do': 'Para Fazer',
    'on hold': 'Pausado',
    'in progress': 'Em Progresso',
    'staging': 'Em Staging',
    'awaiting deploy': 'Aguardando Deploy',
    'done': 'Concluído',
  }
  return translations[status.toLowerCase()] || status
}

// Tradução de prioridade
const translatePriority = (priority: string) => {
  const translations: Record<string, string> = {
    'urgent': 'Urgente',
    'high': 'Alta',
    'normal': 'Normal',
    'low': 'Baixa',
  }
  return translations[priority.toLowerCase()] || priority
}

// Tradução de tracker
const translateTracker = (tracker: string) => {
  const translations: Record<string, string> = {
    'feature': 'Funcionalidade',
    'bug': 'Bug',
    'chore': 'Tarefa',
    'task': 'Atividade',
    'spider': 'Spider',
    'test': 'Teste',
    'technical debt': 'Débito Técnico',
  }
  return translations[tracker.toLowerCase()] || tracker
}

// Cor por status
const getStatusColor = (status: string) => {
  const colors: Record<string, string> = {
    'to check': '#EF4444',
    'to analyze': '#F97316',
    'to prioritize': '#F59E0B',
    'to estimate': '#EAB308',
    'to do': '#3B82F6',
    'on hold': '#6B7280',
    'in progress': '#8B5CF6',
    'staging': '#EC4899',
    'awaiting deploy': '#14B8A6',
    'done': '#10B981',
  }
  return colors[status.toLowerCase()] || '#6B7280'
}

// Classe CSS por prioridade
const getPriorityClass = (priority: string) => {
  const p = priority.toLowerCase()
  if (p.includes('urgent')) return 'bg-red-100 text-red-700'
  if (p.includes('high')) return 'bg-orange-100 text-orange-700'
  if (p.includes('low')) return 'bg-green-100 text-green-700'
  return 'bg-blue-100 text-blue-700'
}

// Formata data
const formatDate = (dateString: string) => {
  if (!dateString) return 'N/A'
  const date = new Date(dateString)
  return date.toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.description-content :deep(img) {
  max-width: 100%;
  height: auto;
  border-radius: 0.5rem;
  margin: 0.5rem 0;
}

.description-content :deep(a) {
  color: #2563eb;
  text-decoration: none;
}

.description-content :deep(a:hover) {
  text-decoration: underline;
}
</style>
