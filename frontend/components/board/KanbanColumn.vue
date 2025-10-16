<template>
  <div class="kanban-column">
    <!-- Cabeçalho da coluna -->
    <div class="kanban-column-header">
      <div class="flex items-center">
        <span>{{ title }}</span>
        <span class="ml-2 text-sm font-normal text-gray-500">
          ({{ issues.length }})
        </span>
      </div>
    </div>

    <!-- Lista de issues -->
    <div class="space-y-3">
      <IssueCard
        v-for="issue in issues"
        :key="issue.id"
        :issue="issue"
        @click="handleIssueClick"
      />

      <!-- Estado vazio -->
      <div v-if="issues.length === 0" class="text-center py-8 text-gray-400 text-sm">
        Nenhuma issue
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Coluna do Kanban board
 * Exibe issues de um status específico
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
  title: string
  issues: Issue[]
}

defineProps<Props>()

const emit = defineEmits(['issue-click'])

/**
 * Emite evento quando issue é clicada
 */
const handleIssueClick = (issue: Issue) => {
  emit('issue-click', issue)
}
</script>
