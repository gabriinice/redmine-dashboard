/**
 * Middleware de autenticação
 * Verifica se usuário está autenticado antes de acessar rotas protegidas
 */
export default defineNuxtRouteMiddleware(async (to, from) => {
  const authStore = useAuthStore()

  // Se não estiver autenticado, tentar restaurar sessão
  if (!authStore.isAuthenticated) {
    await authStore.restoreSession()
  }

  // Se ainda não estiver autenticado, redirecionar para login
  if (!authStore.isAuthenticated && to.path !== '/login') {
    return navigateTo('/login')
  }

  // Se estiver autenticado e tentar acessar login, redirecionar para home
  if (authStore.isAuthenticated && to.path === '/login') {
    return navigateTo('/')
  }
})
