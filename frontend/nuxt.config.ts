// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },

  modules: [
    '@nuxtjs/tailwindcss',
    '@pinia/nuxt',
  ],

  runtimeConfig: {
    public: {
      apiUrl: process.env.NUXT_PUBLIC_API_URL || 'http://localhost:3000',
    },
  },

  app: {
    head: {
      title: 'Redmine Dashboard - Brobot',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        {
          name: 'description',
          content: 'Sistema de monitoramento e gestão de tarefas do Redmine'
        },
      ],
    },
  },

  css: ['~/assets/css/main.css'],

  // FIX: Habilitar hot-reload no Docker com polling
  vite: {
    server: {
      watch: {
        usePolling: true,
        interval: 1000,
      },
      hmr: {
        overlay: true,
      },
    },
  },

  compatibilityDate: '2024-04-03',
})
