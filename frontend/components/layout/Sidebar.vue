<template>
  <aside class="fixed left-0 top-0 h-screen w-64 bg-[#0f172a] shadow-2xl flex flex-col z-50">
    <!-- Logo Brobot -->
    <div class="px-6 py-6">
      <div class="flex items-center justify-center">
        <img
          src="https://brobot.com.br/wp-content/webp-express/webp-images/uploads/2021/07/logo-brobot-ic.png.webp"
          alt="Brobot Logo"
          class="h-12 w-auto"
        />
      </div>
    </div>

    <!-- Navegação -->
    <nav class="flex-1 px-3 py-6 space-y-1 overflow-y-auto">
      <!-- Dashboard -->
      <NuxtLink
        to="/"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
        </svg>
        <span class="font-medium">Dashboard</span>
        <div v-if="isActive('/')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Atividades do Time -->
      <NuxtLink
        to="/atividades-time"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/atividades-time')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
        </svg>
        <span class="font-medium">Atividades do Time</span>
        <div v-if="isActive('/atividades-time')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Features -->
      <NuxtLink
        to="/features"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/features')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
        </svg>
        <span class="font-medium">Features</span>
        <div v-if="isActive('/features')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Outras Atividades -->
      <NuxtLink
        to="/outras-atividades"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/outras-atividades')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"></path>
        </svg>
        <span class="font-medium">Outras Atividades</span>
        <div v-if="isActive('/outras-atividades')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Alertas -->
      <NuxtLink
        to="/alertas"
        class="flex items-center px-4 py-3 rounded-lg transition-all group relative"
        :class="isActive('/alertas')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path>
        </svg>
        <span class="font-medium">Alertas</span>
        <span v-if="alertCount > 0" class="ml-auto px-2 py-0.5 text-xs rounded-full bg-red-500 text-white font-bold shadow-lg animate-pulse">
          {{ alertCount }}
        </span>
        <div v-if="isActive('/alertas')" class="ml-2 w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Sprint Atual -->
      <NuxtLink
        to="/sprint-atual"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/sprint-atual')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
        </svg>
        <span class="font-medium">Sprint Atual</span>
        <div v-if="isActive('/sprint-atual')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>

      <!-- Sprint Planning -->
      <NuxtLink
        to="/sprint-planning"
        class="flex items-center px-4 py-3 rounded-lg transition-all group"
        :class="isActive('/sprint-planning')
          ? 'bg-gradient-to-r from-blue-600 to-blue-700 text-white shadow-lg shadow-blue-900/50'
          : 'text-white hover:bg-blue-800/50'"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
        </svg>
        <span class="font-medium">Sprint Planning</span>
        <div v-if="isActive('/sprint-planning')" class="ml-auto w-1 h-8 bg-white rounded-full"></div>
      </NuxtLink>
    </nav>

    <!-- Usuário e logout -->
    <div class="px-3 py-4 border-t border-blue-800/50">
      <!-- Info do usuário -->
      <div class="px-4 py-3 mb-2 bg-blue-800/30 rounded-lg border border-blue-700/50">
        <div class="flex items-center space-x-3">
          <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-full p-2 shadow-md">
            <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
          </div>
          <div class="flex-1 min-w-0">
            <p class="text-sm font-medium text-white truncate">
              {{ userName }}
            </p>
            <p class="text-xs text-blue-300">
              Desenvolvedor
            </p>
          </div>
        </div>
      </div>

      <!-- Botão de logout -->
      <button
        @click="handleLogout"
        class="w-full flex items-center px-4 py-3 rounded-lg text-blue-200 hover:bg-red-600 hover:text-white transition-all group"
      >
        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
        </svg>
        <span class="font-medium">Sair</span>
      </button>
    </div>
  </aside>
</template>

<script setup lang="ts">
/**
 * Sidebar lateral com navegação principal
 * Design dark blue profissional e bonito
 */

const authStore = useAuthStore()
const router = useRouter()
const route = useRoute()

// Contador de alertas
const alertCount = ref(0)

/**
 * Nome do usuário
 */
const userName = computed(() => {
  return authStore.user?.name || 'Usuário'
})

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

<style scoped>
/* Custom scrollbar para a navegação */
nav::-webkit-scrollbar {
  width: 6px;
}

nav::-webkit-scrollbar-track {
  background: rgba(30, 58, 138, 0.3);
  border-radius: 3px;
}

nav::-webkit-scrollbar-thumb {
  background: rgba(59, 130, 246, 0.5);
  border-radius: 3px;
}

nav::-webkit-scrollbar-thumb:hover {
  background: rgba(59, 130, 246, 0.7);
}

/* Animação suave para links */
a {
  position: relative;
  overflow: hidden;
}

a::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: rgba(255, 255, 255, 0.1);
  transition: left 0.3s ease;
}

a:hover::before {
  left: 100%;
}
</style>
