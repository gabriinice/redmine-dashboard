<template>
  <div class="px-4">
    <!-- FEATURES -->
    <div v-if="issuesByTracker.feature.length > 0" class="mb-8">
      <div class="flex items-center mb-4">
        <div class="bg-purple-600 rounded-full p-2 mr-3">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Features</h2>
        <span class="ml-3 px-3 py-1 bg-purple-100 text-purple-700 rounded-full font-semibold">
          {{ issuesByTracker.feature.length }}
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <div
          v-for="issue in issuesByTracker.feature"
          :key="issue.id"
          class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-all p-5 border-l-4 border-purple-500"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
            <span class="text-xs px-3 py-1 rounded-full font-semibold" :class="getStatusBadgeClass(issue.status.name)">
              {{ issue.status.name }}
            </span>
          </div>
          <h3 class="text-sm font-bold text-gray-900 mb-3 line-clamp-2 min-h-[40px]">
            {{ issue.subject }}
          </h3>
          <div class="flex items-center text-xs text-gray-600">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            {{ issue.assigned_to?.name || 'Não atribuído' }}
          </div>
        </div>
      </div>
    </div>

    <!-- BUGS -->
    <div v-if="issuesByTracker.bug.length > 0" class="mb-8">
      <div class="flex items-center mb-4">
        <div class="bg-red-600 rounded-full p-2 mr-3">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Bugs</h2>
        <span class="ml-3 px-3 py-1 bg-red-100 text-red-700 rounded-full font-semibold">
          {{ issuesByTracker.bug.length }}
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <div
          v-for="issue in issuesByTracker.bug"
          :key="issue.id"
          class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-all p-5 border-l-4 border-red-500"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
            <span class="text-xs px-3 py-1 rounded-full font-semibold" :class="getStatusBadgeClass(issue.status.name)">
              {{ issue.status.name }}
            </span>
          </div>
          <h3 class="text-sm font-bold text-gray-900 mb-3 line-clamp-2 min-h-[40px]">
            {{ issue.subject }}
          </h3>
          <div class="flex items-center text-xs text-gray-600">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            {{ issue.assigned_to?.name || 'Não atribuído' }}
          </div>
        </div>
      </div>
    </div>

    <!-- CHORES -->
    <div v-if="issuesByTracker.chore.length > 0" class="mb-8">
      <div class="flex items-center mb-4">
        <div class="bg-yellow-600 rounded-full p-2 mr-3">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Chores</h2>
        <span class="ml-3 px-3 py-1 bg-yellow-100 text-yellow-700 rounded-full font-semibold">
          {{ issuesByTracker.chore.length }}
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <div
          v-for="issue in issuesByTracker.chore"
          :key="issue.id"
          class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-all p-5 border-l-4 border-yellow-500"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
            <span class="text-xs px-3 py-1 rounded-full font-semibold" :class="getStatusBadgeClass(issue.status.name)">
              {{ issue.status.name }}
            </span>
          </div>
          <h3 class="text-sm font-bold text-gray-900 mb-3 line-clamp-2 min-h-[40px]">
            {{ issue.subject }}
          </h3>
          <div class="flex items-center text-xs text-gray-600">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            {{ issue.assigned_to?.name || 'Não atribuído' }}
          </div>
        </div>
      </div>
    </div>

    <!-- TASKS -->
    <div v-if="issuesByTracker.task.length > 0" class="mb-8">
      <div class="flex items-center mb-4">
        <div class="bg-blue-600 rounded-full p-2 mr-3">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Tasks</h2>
        <span class="ml-3 px-3 py-1 bg-blue-100 text-blue-700 rounded-full font-semibold">
          {{ issuesByTracker.task.length }}
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <div
          v-for="issue in issuesByTracker.task"
          :key="issue.id"
          class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-all p-5 border-l-4 border-blue-500"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
            <span class="text-xs px-3 py-1 rounded-full font-semibold" :class="getStatusBadgeClass(issue.status.name)">
              {{ issue.status.name }}
            </span>
          </div>
          <h3 class="text-sm font-bold text-gray-900 mb-3 line-clamp-2 min-h-[40px]">
            {{ issue.subject }}
          </h3>
          <div class="flex items-center text-xs text-gray-600">
            <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
            {{ issue.assigned_to?.name || 'Não atribuído' }}
          </div>
        </div>
      </div>
    </div>

    <!-- OUTROS (spider, test, technical_debt, etc) -->
    <div v-if="issuesByTracker.other.length > 0" class="mb-8">
      <div class="flex items-center mb-4">
        <div class="bg-gray-600 rounded-full p-2 mr-3">
          <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-gray-900">Outros</h2>
        <span class="ml-3 px-3 py-1 bg-gray-100 text-gray-700 rounded-full font-semibold">
          {{ issuesByTracker.other.length }}
        </span>
      </div>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <div
          v-for="issue in issuesByTracker.other"
          :key="issue.id"
          class="bg-white rounded-lg shadow-lg hover:shadow-xl transition-all p-5 border-l-4 border-gray-500"
        >
          <div class="flex items-center justify-between mb-3">
            <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
            <span class="text-xs px-3 py-1 rounded-full font-semibold" :class="getStatusBadgeClass(issue.status.name)">
              {{ issue.status.name }}
            </span>
          </div>
          <h3 class="text-sm font-bold text-gray-900 mb-3 line-clamp-2 min-h-[40px]">
            {{ issue.subject }}
          </h3>
          <div class="space-y-2">
            <div class="flex items-center text-xs text-gray-600">
              <svg class="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
              </svg>
              {{ issue.assigned_to?.name || 'Não atribuído' }}
            </div>
            <span class="text-xs px-2 py-1 bg-gray-100 rounded text-gray-700">
              {{ issue.tracker.name }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Mensagem vazia -->
    <div v-if="totalIssues === 0" class="text-center py-20">
      <svg class="w-24 h-24 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
      </svg>
      <p class="text-gray-500 text-lg">Nenhuma atividade encontrada nesta sprint</p>
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Página Sprint Atual - Mostra todas as atividades da sprint separadas por tracker
 */

const redmine = useRedmine()

const sprintInfo = ref<any>({})
const issues = ref<any[]>([])

const totalIssues = computed(() => issues.value.length)

/**
 * Agrupa issues por tracker (feature, bug, chore, task, other)
 */
const issuesByTracker = computed(() => {
  const grouped: any = {
    feature: [],
    bug: [],
    chore: [],
    task: [],
    other: []
  }

  issues.value.forEach((issue: any) => {
    // Filtrar apenas issues que NÃO estão done
    const statusName = issue.status?.name?.toLowerCase() || ''
    if (statusName === 'done') {
      return  // Pula issues done
    }

    const trackerName = issue.tracker?.name?.toLowerCase() || ''

    if (trackerName === 'feature') {
      grouped.feature.push(issue)
    } else if (trackerName === 'bug') {
      grouped.bug.push(issue)
    } else if (trackerName === 'chore') {
      grouped.chore.push(issue)
    } else if (trackerName === 'task') {
      grouped.task.push(issue)
    } else {
      grouped.other.push(issue)
    }
  })

  return grouped
})

/**
 * Busca sprint atual e issues
 */
const fetchSprintData = async () => {
  try {
    const response = await redmine.fetchSprintAtual()
    sprintInfo.value = response.sprint_info || {}
    issues.value = response.issues || []
  } catch (error) {
    console.error('Erro ao buscar dados da sprint:', error)
  }
}

/**
 * Formata data
 */
const formatDate = (dateString: string) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return date.toLocaleDateString('pt-BR')
}

/**
 * Classes de badge por status
 */
const getStatusBadgeClass = (status: string) => {
  const s = status.toLowerCase()
  if (s.includes('progress')) return 'bg-purple-100 text-purple-700'
  if (s.includes('done')) return 'bg-green-100 text-green-700'
  if (s.includes('to do') || s.includes('analyze')) return 'bg-blue-100 text-blue-700'
  if (s.includes('check')) return 'bg-red-100 text-red-700'
  if (s.includes('deploy')) return 'bg-teal-100 text-teal-700'
  if (s.includes('staging')) return 'bg-pink-100 text-pink-700'
  if (s.includes('hold')) return 'bg-gray-100 text-gray-700'
  return 'bg-gray-100 text-gray-700'
}

definePageMeta({
  middleware: 'auth',
})

onMounted(() => {
  fetchSprintData()
  // Auto-refresh a cada 60 segundos
  setInterval(fetchSprintData, 60000)
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
