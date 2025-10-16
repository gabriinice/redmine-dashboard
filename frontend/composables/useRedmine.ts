/**
 * Composable para interagir com os endpoints do Redmine
 * Fornece métodos para buscar issues, boards, etc
 */
export const useRedmine = () => {
  const api = useApi()

  /**
   * Busca issues com filtros
   */
  const fetchIssues = async (filters?: {
    project_id?: string
    status_id?: number[]
    tracker_id?: number[]
    assigned_to_id?: number
    cf_11?: string
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/issues', filters)
  }

  /**
   * Busca detalhes de uma issue
   */
  const fetchIssue = async (id: number, includeJournals = false) => {
    return await api.get(`/api/v1/issues/${id}`, {
      include_journals: includeJournals,
    })
  }

  /**
   * Busca dados da Tela 1: Atividades do Time
   */
  const fetchAtividadesTime = async (filters?: {
    assigned_to_id?: number
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/atividades_time', filters)
  }

  /**
   * Busca dados da Tela 2: Features
   */
  const fetchFeatures = async (filters?: {
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/features', filters)
  }

  /**
   * Busca dados da Tela 3: Outras Atividades
   */
  const fetchOutrasAtividades = async (filters?: {
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/outras_atividades', filters)
  }

  /**
   * Busca dados da Tela 4: Alertas
   */
  const fetchAlertas = async (filters?: {
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/alertas', filters)
  }

  /**
   * Busca dados da Tela 5: Última Sprint Entregue
   */
  const fetchUltimaSprint = async (filters?: {
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/ultima_sprint', filters)
  }

  /**
   * Busca dados da Tela 6: Sprint Atual
   */
  const fetchSprintAtual = async (filters?: {
    limit?: number
    offset?: number
  }) => {
    return await api.get('/api/v1/boards/sprint_atual', filters)
  }

  /**
   * Cria uma nova issue
   */
  const createIssue = async (issueData: {
    project_id: string | number
    tracker_id: string | number
    subject: string
    description?: string
    status_id?: string | number
    priority_id?: string | number
    assigned_to_id?: string | number
    story_points?: number
  }) => {
    return await api.post('/api/v1/issues', { issue: issueData })
  }

  /**
   * Atualiza uma issue existente
   */
  const updateIssue = async (id: number, issueData: any) => {
    return await api.put(`/api/v1/issues/${id}`, { issue: issueData })
  }

  /**
   * Deleta uma issue
   */
  const deleteIssue = async (id: number) => {
    return await api.delete(`/api/v1/issues/${id}`)
  }

  /**
   * Adiciona comentário a uma issue
   */
  const addComment = async (id: number, notes: string) => {
    return await api.post(`/api/v1/issues/${id}/comments`, { notes })
  }

  /**
   * Revisa user story com IA
   */
  const reviewStoryWithAI = async (data: {
    subject: string
    description: string
  }) => {
    return await api.post('/api/v1/ai/review_story', data)
  }

  return {
    fetchIssues,
    fetchIssue,
    fetchAtividadesTime,
    fetchFeatures,
    fetchOutrasAtividades,
    fetchAlertas,
    fetchUltimaSprint,
    fetchSprintAtual,
    createIssue,
    updateIssue,
    deleteIssue,
    addComment,
    reviewStoryWithAI,
  }
}
