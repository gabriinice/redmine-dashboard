<template>
  <header class="bg-[#0f172a] shadow-2xl">
    <div class="mx-auto px-6">
      <div class="flex justify-between items-center py-6">
        <!-- Logo Brobot -->
        <div class="flex items-center">
          <img
            src="https://brobot.com.br/wp-content/webp-express/webp-images/uploads/2021/07/logo-brobot-ic.png.webp"
            alt="Brobot Logo"
            class="h-10 w-auto"
          />
        </div>

        <!-- Navegação -->
        <nav class="hidden md:flex space-x-4">
          <NuxtLink
            to="/"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Dashboard
          </NuxtLink>
          <NuxtLink
            to="/atividades-time"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/atividades-time') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Atividades do Time
          </NuxtLink>
          <NuxtLink
            to="/features"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/features') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Features
          </NuxtLink>
          <NuxtLink
            to="/outras-atividades"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/outras-atividades') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Outras Atividades
          </NuxtLink>
          <NuxtLink
            to="/alertas"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/alertas') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Alertas
            <span v-if="alertCount > 0" class="ml-1 px-2 py-0.5 text-xs rounded-full bg-red-500 text-white">
              {{ alertCount }}
            </span>
          </NuxtLink>
          <NuxtLink
            to="/sprint-planning"
            class="px-3 py-2 rounded-md text-sm font-medium"
            :class="isActive('/sprint-planning') ? 'bg-blue-700 text-white' : 'text-blue-200 hover:bg-blue-800/50 hover:text-white'"
          >
            Sprint Planning
          </NuxtLink>
        </nav>

        <!-- Usuário e logout -->
        <div class="flex items-center space-x-4">
          <span class="text-sm text-white">
            {{ authStore.user?.name }}
          </span>
          <button
            @click="handleLogout"
            class="text-sm text-blue-200 hover:text-white"
          >
            Sair
          </button>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
/**
 * Header da aplicação
 * Contém navegação e informações do usuário
 */

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

// Contador de alertas (buscar da API)
const alertCount = ref(0)

/**
 * Verifica se rota está ativa
 */
const isActive = (path: string) => {
  return route.path === path
}

/**
 * Realiza logout
 */
const handleLogout = async () => {
  await authStore.logout()
  await router.push('/login')
}

/**
 * Busca contagem de alertas
 */
const fetchAlertCount = async () => {
  try {
    const redmine = useRedmine()
    const data = await redmine.fetchAlertas({ limit: 1 })
    alertCount.value = data.total_count || 0
  } catch (error) {
    console.error('Erro ao buscar alertas:', error)
  }
}

// Buscar alertas ao montar e a cada 30 segundos
onMounted(() => {
  fetchAlertCount()
  setInterval(fetchAlertCount, 30000)
})
</script>
