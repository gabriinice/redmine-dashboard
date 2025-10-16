<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow-md">
      <div>
        <h2 class="text-center text-3xl font-bold text-gray-900">
          Redmine Dashboard
        </h2>
        <p class="mt-2 text-center text-sm text-gray-600">
          Faça login com suas credenciais do Redmine
        </p>
      </div>

      <form class="mt-8 space-y-6" @submit.prevent="handleLogin">
        <div class="space-y-4">
          <!-- Login -->
          <div>
            <label for="login" class="block text-sm font-medium text-gray-700">
              Login
            </label>
            <input
              id="login"
              v-model="login"
              type="text"
              required
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="seu.usuario"
            />
          </div>

          <!-- Senha -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700">
              Senha
            </label>
            <input
              id="password"
              v-model="password"
              type="password"
              required
              class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              placeholder="••••••••"
            />
          </div>
        </div>

        <!-- Mensagem de erro -->
        <div v-if="error" class="rounded-md bg-red-50 p-4">
          <div class="flex">
            <div class="ml-3">
              <h3 class="text-sm font-medium text-red-800">
                {{ error }}
              </h3>
            </div>
          </div>
        </div>

        <!-- Botão de login -->
        <div>
          <button
            type="submit"
            :disabled="loading"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="loading" class="spinner mr-2"></span>
            {{ loading ? 'Entrando...' : 'Entrar' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
/**
 * Página de login
 * Autentica usuário usando credenciais do Redmine
 */

const authStore = useAuthStore()
const router = useRouter()

const login = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')

/**
 * Processa login do usuário
 */
const handleLogin = async () => {
  loading.value = true
  error.value = ''

  try {
    const result = await authStore.login(login.value, password.value)

    if (result.success) {
      // Redirecionar para dashboard
      await router.push('/')
    } else {
      error.value = result.error || 'Erro ao fazer login'
    }
  } catch (e) {
    error.value = 'Erro ao fazer login. Tente novamente.'
  } finally {
    loading.value = false
  }
}

// Se já estiver autenticado, redirecionar
onMounted(() => {
  if (authStore.isAuthenticated) {
    router.push('/')
  }
})
</script>
