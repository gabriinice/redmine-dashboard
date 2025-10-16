<template>
  <div class="mb-6 bg-[#0f172a] rounded-xl shadow-xl px-8 py-6">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-white mb-1">
          <slot name="title"></slot>
        </h1>
        <p class="text-slate-300 text-base">
          <slot name="subtitle"></slot>
        </p>
      </div>
      <div v-if="$slots.actions" class="flex items-center space-x-3">
        <slot name="actions"></slot>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Componente de header padrão para páginas
 * Azul escuro com títulos brancos
 */
</script>
