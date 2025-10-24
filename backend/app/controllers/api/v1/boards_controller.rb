# frozen_string_literal: true

module Api
  module V1
    # Controller para os boards - USA FILTROS DIRETOS NA API DO REDMINE
    # Sintaxe correta: status_id=1,2,3 (vírgulas)
    class BoardsController < ApplicationController
      # GET /api/v1/boards/atividades_time
      # Tela 1: Atividades do time
      def atividades_time
        client = redmine_client

        # Status padrão se não fornecido
        default_status_ids = [29, 28, 30, 31, 1, 3, 15, 4, 5]  # to check, to analyze, to prioritize, to estimate, to do, in progress, on hold, staging, awaiting deploy

        filters = {
          project_id: params[:project_id] || 'dev',
          limit: params[:limit] || 300,  # Aumentado para capturar todas as issues
          offset: params[:offset] || 0
          # Removido: include: 'journals,attachments'
        }

        # Filtro por status - suporta filtro do frontend
        if params[:status_id].present?
          # Converte string "1,2,3" para array [1,2,3]
          status_ids = params[:status_id].to_s.split(',').map(&:to_i)
          filters[:status_id] = status_ids
        else
          filters[:status_id] = default_status_ids
        end

        # Filtro por pessoa se fornecido
        filters[:assigned_to_id] = params[:assigned_to_id] if params[:assigned_to_id].present?

        # Filtro por kind (cf_11: Macro, Task, Group)
        filters[:cf_11] = params[:cf_11] if params[:cf_11].present?

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Log para debug
        Rails.logger.info "Atividades Time - Total no Redmine: #{result['total_count']}, Retornadas: #{issues.count}"
        Rails.logger.info "Filtros aplicados: #{filters.inspect}"

        # Agrupar por usuário
        issues_by_user = group_by_assigned_user(issues)

        render json: {
          total_count: result['total_count'],
          issues_count: issues.count,
          issues_by_user: issues_by_user
        }, status: :ok
      end

      # GET /api/v1/boards/features
      # Tela 2: Features (Macro)
      def features
        client = redmine_client

        filters = {
          project_id: params[:project_id] || 'dev',
          tracker_id: [1],  # feature
          cf_11: 'Macro',
          status_id: [29, 28, 30, 31, 1, 15, 3, 4, 5],  # to check até awaiting deploy
          limit: params[:limit] || 50,  # Reduzido de 100 para 50
          offset: params[:offset] || 0
          # Removido: include: 'journals,attachments'
        }

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Agrupar por status
        issues_by_status = group_by_status(issues)

        render json: {
          total_count: result['total_count'],
          issues_by_status: issues_by_status
        }, status: :ok
      end

      # GET /api/v1/boards/outras_atividades
      # Tela 3: Outras atividades (bug, chore, task, spider, test, technical_debt)
      def outras_atividades
        client = redmine_client

        filters = {
          project_id: params[:project_id] || 'dev',
          tracker_id: [2, 6, 7, 10, 11, 14],
          cf_11: 'Macro',
          status_id: [29, 28, 30, 31, 1, 15, 3, 4, 5],
          limit: params[:limit] || 50,  # Reduzido de 100 para 50
          offset: params[:offset] || 0
          # Removido: include: 'journals,attachments'
        }

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Agrupar por status
        issues_by_status = group_by_status(issues)

        render json: {
          total_count: result['total_count'],
          issues_by_status: issues_by_status
        }, status: :ok
      end

      # GET /api/v1/boards/alertas
      # Tela 4: Alertas - Issues no status "To Check" (29)
      def alertas
        client = redmine_client

        filters = {
          project_id: params[:project_id] || 'dev',
          status_id: [29],  # to check
          limit: params[:limit] || 50,  # Reduzido de 100 para 50
          offset: params[:offset] || 0
          # Removido: include: 'journals,attachments'
        }

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Formatar e ordenar por dias parado
        alerts = issues.map { |issue| format_issue_with_details(issue) }
                       .sort_by { |i| -i[:days_stale] }

        render json: {
          total_count: result['total_count'],
          alerts: alerts
        }, status: :ok
      end

      # GET /api/v1/boards/sprint_atual
      # Tela 6: Sprint Atual - Issues da sprint em andamento
      def sprint_atual
        client = redmine_client
        project_id = params[:project_id] || 'dev'

        # Buscar todas as sprints do projeto
        sprints_response = client.fetch_agile_sprints(project_id)
        sprints = sprints_response['sprints'] || []

        # Encontrar a sprint que contém a data de hoje
        today = Date.today
        current_sprint = sprints.find do |sprint|
          start_date = Date.parse(sprint['start_date'])
          end_date = Date.parse(sprint['end_date'])
          today >= start_date && today <= end_date
        end

        if current_sprint.nil?
          return render json: { total_count: 0, issues: [], sprint_info: {} }, status: :ok
        end

        # Buscar issues da sprint (exceto Done)
        # Status open: todos exceto done (2)
        filters = {
          project_id: project_id,
          agile_sprint_id: current_sprint['id'],
          status_id: 'open',  # Todos os status abertos (não Done)
          limit: 1000,
          offset: 0
        }

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Formatar issues
        formatted_issues = issues.map { |issue| format_issue_basic(issue) }

        render json: {
          total_count: result['total_count'],
          issues: formatted_issues,
          sprint_info: current_sprint
        }, status: :ok
      end

      # GET /api/v1/boards/ultima_sprint
      # Tela 5: Última Sprint Entregue - Issues FECHADAS na última semana (7 dias atrás)
      def ultima_sprint
        client = redmine_client
        project_id = params[:project_id] || 'dev'

        # Calcular período da última sprint (semana passada: 7-14 dias atrás)
        hoje = Date.today
        sprint_end = (hoje - 7.days).strftime('%Y-%m-%d')
        sprint_start = (hoje - 14.days).strftime('%Y-%m-%d')
        sprint_name = "Última Semana (#{sprint_start} a #{sprint_end})"

        filters = {
          project_id: project_id,
          status_id: [2],  # done
          closed_on: "><#{sprint_start}|#{sprint_end}",  # Issues fechadas na última semana
          limit: params[:limit] || 200,
          offset: params[:offset] || 0
          # Removido: include: 'journals,attachments'
        }

        result = client.fetch_issues(filters)
        issues = result['issues'] || []

        # Formatar issues
        completed_activities = issues.map { |issue| format_issue_basic(issue) }
                                     .sort_by { |i| i[:updated_on] }
                                     .reverse

        render json: {
          total_count: result['total_count'],
          activities: completed_activities,
          sprint_name: sprint_name,
          sprint_start: sprint_start,
          sprint_end: sprint_end
        }, status: :ok
      end

      private

      def redmine_client
        Redmine::Client.new(current_user[:credentials])
      end

      # Agrupa issues por usuário
      def group_by_assigned_user(issues)
        grouped = issues.group_by { |i| i.dig('assigned_to', 'id') }

        grouped.transform_values do |user_issues|
          {
            user: user_issues.first['assigned_to'] || { id: nil, name: 'Não atribuído' },
            issues: user_issues.map { |i| format_issue_basic(i) }
          }
        end
      end

      # Agrupa issues por status
      def group_by_status(issues)
        grouped = issues.group_by { |i| i.dig('status', 'id') }

        grouped.transform_values do |status_issues|
          {
            status: status_issues.first['status'],
            issues: status_issues.map { |i| format_issue_basic(i) }
          }
        end
      end

      # Formata issue básica
      def format_issue_basic(issue)
        {
          id: issue['id'],
          subject: issue['subject'],
          description: issue['description'],
          tracker: issue['tracker'],
          status: issue['status'],
          priority: issue['priority'],
          assigned_to: issue['assigned_to'],
          updated_on: issue['updated_on'],
          created_on: issue['created_on'],
          days_stale: calculate_days_stale(issue['updated_on']),
          last_comment: extract_last_comment(issue),
          attachments: issue['attachments'] || []
        }
      end

      # Formata issue com detalhes
      def format_issue_with_details(issue)
        basic = format_issue_basic(issue)
        basic[:author] = issue['author']
        basic
      end

      # Extrai último comentário
      def extract_last_comment(issue)
        journals = issue['journals'] || []
        last_journal = journals.reverse.find { |j| j['notes'].present? }

        return nil unless last_journal

        {
          user: last_journal['user'],
          notes: last_journal['notes'],
          created_on: last_journal['created_on']
        }
      end

      # Calcula dias parado
      def calculate_days_stale(updated_on)
        return 0 unless updated_on
        updated_date = Time.parse(updated_on)
        ((Time.now - updated_date) / 1.day).to_i
      end
    end
  end
end


