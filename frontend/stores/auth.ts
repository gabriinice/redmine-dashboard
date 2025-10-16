import { defineStore } from 'pinia'

interface User {
  id: number
  login: string
  name: string
  email: string
}

interface AuthState {
  token: string | null
  user: User | null
  isAuthenticated: boolean
}

/**
 * Store de autenticação
 * Gerencia login, logout e estado do usuário
 */
export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    token: null,
    user: null,
    isAuthenticated: false,
  }),

  actions: {
    /**
     * Realiza login no sistema
     * @param login Login do usuário no Redmine
     * @param password Senha do usuário no Redmine
     */
    async login(login: string, password: string) {
      const config = useRuntimeConfig()
      const apiUrl = config.public.apiUrl

      try {
        const response = await $fetch<{ token: string; user: User }>(
          `${apiUrl}/api/v1/auth/login`,
          {
            method: 'POST',
            body: {
              auth: {
                login,
                password,
              },
            },
          }
        )

        this.token = response.token
        this.user = response.user
        this.isAuthenticated = true

        // Salvar token no localStorage
        if (process.client) {
          localStorage.setItem('token', response.token)
        }

        return { success: true }
      } catch (error: any) {
        console.error('Erro ao fazer login:', error)
        return {
          success: false,
          error: error.data?.error || 'Erro ao fazer login'
        }
      }
    },

    /**
     * Realiza logout do sistema
     */
    async logout() {
      this.token = null
      this.user = null
      this.isAuthenticated = false

      // Remover token do localStorage
      if (process.client) {
        localStorage.removeItem('token')
      }

      // Redirecionar para login
      await navigateTo('/login')
    },

    /**
     * Recupera sessão do localStorage
     */
    async restoreSession() {
      if (!process.client) return

      const token = localStorage.getItem('token')

      if (!token) return

      this.token = token

      // Buscar dados do usuário
      try {
        const config = useRuntimeConfig()
        const apiUrl = config.public.apiUrl

        const response = await $fetch<{ user: User }>(
          `${apiUrl}/api/v1/auth/me`,
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        )

        this.user = response.user
        this.isAuthenticated = true
      } catch (error) {
        console.error('Erro ao restaurar sessão:', error)
        // Token inválido, fazer logout
        await this.logout()
      }
    },
  },
})
