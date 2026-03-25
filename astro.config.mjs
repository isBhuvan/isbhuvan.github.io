// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  site: 'https://isbhuvan.github.io',
  output: "static",
  vite: {
    build: {
      rollupOptions: {
        external: [/\/pagefind\//],
      },
    },
  },
  image: {
    // Cap markdown/content images so they aren't served at source resolution
    breakpoints: [600, 800, 1200],
  },
  markdown: {
    shikiConfig: {
      themes: {
        light: 'github-light',
        dark: 'github-dark',
      },
      wrap: false,
    },
  },
});
