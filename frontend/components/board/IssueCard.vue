<template>
  <div
    class="issue-card"
    :class="priorityClass"
    @click="$emit('click', issue)"
  >
    <!-- Cabeçalho com ID e Tracker -->
    <div class="flex items-center justify-between mb-2">
      <span class="text-xs font-mono text-gray-500">#{{ issue.id }}</span>
      <span class="text-xs px-2 py-1 rounded bg-gray-200 text-gray-700">
        {{ issue.tracker.name }}
      </span>
    </div>

    <!-- Título da issue -->
    <h3 class="text-sm font-medium text-gray-900 mb-2 line-clamp-2">
      {{ issue.subject }}
    </h3>

    <!-- Rodapé com informações -->
    <div class="flex items-center justify-between text-xs text-gray-500">
      <!-- Usuário atribuído -->
      <div v-if="issue.assigned_to" class="flex items-center">
        <span class="truncate max-w-[120px]">
          {{ issue.assigned_to.name }}
        </span>
      </div>
      <span v-else class="text-gray-400">Não atribuído</span>

      <!-- Dias parado -->
      <div v-if="issue.days_stale > 0" class="flex items-center">
        <span
          :class="{
            'text-yellow-600': issue.days_stale >= 3 && issue.days_stale < 7,
            'text-red-600': issue.days_stale >= 7,
          }"
        >
          {{ issue.days_stale }}d
        </span>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Card de issue para o Kanban board
 * Exibe informações básicas da issue com cores por prioridade
 */

interface Issue {
  id: number
  subject: string
  tracker: { id: number; name: string }
  status: { id: number; name: string }
  priority: { id: number; name: string }
  assigned_to?: { id: number; name: string }
  days_stale: number
}

interface Props {
  issue: Issue
}

const props = defineProps<Props>()

defineEmits(['click'])

/**
 * Retorna classe CSS baseada na prioridade
 */
const priorityClass = computed(() => {
  const priorityName = props.issue.priority.name.toLowerCase()

  if (priorityName.includes('urgent')) {
    return 'priority-urgent'
  }
  if (priorityName.includes('high')) {
    return 'priority-high'
  }
  if (priorityName.includes('low')) {
    return 'priority-low'
  }
  return 'priority-normal'
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
