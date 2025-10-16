/**
 * Composable para fazer requisições à API
 * Adiciona automaticamente o token de autenticação
 */
export const useApi = () => {
  const config = useRuntimeConfig()
  const authStore = useAuthStore()
  const apiUrl = config.public.apiUrl

  /**
   * Faz requisição GET para a API
   * @param endpoint Endpoint da API
   * @param params Query params
   */
  const get = async <T>(endpoint: string, params?: Record<string, any>): Promise<T> => {
    try {
      const response = await $fetch<T>(`${apiUrl}${endpoint}`, {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
        params,
      })

      return response
    } catch (error: any) {
      // Se erro 401, fazer logout
      if (error.status === 401) {
        await authStore.logout()
      }

      throw error
    }
  }

  /**
   * Faz requisição POST para a API
   * @param endpoint Endpoint da API
   * @param body Corpo da requisição
   */
  const post = async <T>(endpoint: string, body?: any): Promise<T> => {
    try {
      const response = await $fetch<T>(`${apiUrl}${endpoint}`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
        body,
      })

      return response
    } catch (error: any) {
      if (error.status === 401) {
        await authStore.logout()
      }

      throw error
    }
  }

  /**
   * Faz requisição PUT para a API
   * @param endpoint Endpoint da API
   * @param body Corpo da requisição
   */
  const put = async <T>(endpoint: string, body?: any): Promise<T> => {
    try {
      const response = await $fetch<T>(`${apiUrl}${endpoint}`, {
        method: 'PUT',
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
        body,
      })

      return response
    } catch (error: any) {
      if (error.status === 401) {
        await authStore.logout()
      }

      throw error
    }
  }

  /**
   * Faz requisição DELETE para a API
   * @param endpoint Endpoint da API
   */
  const deleteRequest = async <T>(endpoint: string): Promise<T> => {
    try {
      const response = await $fetch<T>(`${apiUrl}${endpoint}`, {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${authStore.token}`,
        },
      })

      return response
    } catch (error: any) {
      if (error.status === 401) {
        await authStore.logout()
      }

      throw error
    }
  }

  return {
    get,
    post,
    put,
    delete: deleteRequest,
  }
}
