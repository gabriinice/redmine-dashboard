# frozen_string_literal: true

module Api
  module V1
    # Controller para funcionalidades de IA
    class AiController < ApplicationController
      # POST /api/v1/ai/review_story
      # Revisa uma user story usando IA
      #
      # Params:
      #   - subject: Título da story
      #   - description: Descrição da story
      def review_story
        subject = params[:subject]
        description = params[:description]

        if subject.blank? || description.blank?
          return render json: {
            success: false,
            message: 'Título e descrição são obrigatórios'
          }, status: :unprocessable_entity
        end

        # Aqui você pode integrar com OpenAI ou Claude
        # Por enquanto, vou fazer uma versão simplificada que melhora a formatação

        improved = improve_story(subject, description)

        render json: {
          success: true,
          improved_subject: improved[:subject],
          improved_description: improved[:description],
          suggestions: improved[:suggestions]
        }, status: :ok
      end

      private

      # Melhora uma user story (versão simplificada)
      # Em produção, você pode usar OpenAI ou Claude API
      #
      # @param subject [String] Título original
      # @param description [String] Descrição original
      # @return [Hash] Story melhorada
      def improve_story(subject, description)
        # Versão simplificada sem IA real
        # Para usar IA real, descomente e configure:
        #
        # require 'openai'
        # client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
        #
        # response = client.chat(
        #   parameters: {
        #     model: "gpt-4",
        #     messages: [
        #       {
        #         role: "system",
        #         content: "Você é um especialista em escrever user stories no formato INVEST..."
        #       },
        #       {
        #         role: "user",
        #         content: "Melhore esta user story:\n\nTítulo: #{subject}\n\nDescrição:\n#{description}"
        #       }
        #     ]
        #   }
        # )

        # Por enquanto, apenas adiciona estrutura se não tiver
        improved_description = description

        unless description.include?('## ') || description.include?('Critérios de Aceitação')
          improved_description = <<~DESC
            ## Descrição
            #{description}

            ## Critérios de Aceitação
            - [ ] Funcionalidade implementada conforme especificação
            - [ ] Testes unitários adicionados
            - [ ] Testes de integração passando
            - [ ] Code review realizado

            ## Definition of Done (DoD)
            - [ ] Código revisado e aprovado
            - [ ] Testes passando (unitários e integração)
            - [ ] Documentação atualizada
            - [ ] Deploy em staging realizado
            - [ ] QA aprovado
          DESC
        end

        {
          subject: subject.strip,
          description: improved_description.strip,
          suggestions: [
            'Adicione critérios de aceitação específicos',
            'Defina claramente o Definition of Done',
            'Considere adicionar story points'
          ]
        }
      end
    end
  end
end
