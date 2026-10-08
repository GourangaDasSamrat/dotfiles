import { defineConfig } from "vitepress";

const repo = "https://github.com/GourangaDasSamrat/dotfiles";

export default defineConfig({
  title: "Dotfiles",
  description: "Setup guides and notes for my dotfiles",
  base: "/dotfiles/",
  lang: "en-US",
  cleanUrls: true,
  lastUpdated: true,
  appearance: "dark",

  head: [["meta", { name: "theme-color", content: "#bd93f9" }]],

  themeConfig: {
    nav: [
      { text: "Guide", link: "/guide/getting-started" },
      { text: "Changelog", link: `${repo}/blob/main/CHANGELOG.md` },
    ],

    sidebar: [
      {
        text: "Guide",
        items: [
          { text: "Getting Started", link: "/guide/getting-started" },
          { text: "GNU Stow", link: "/guide/stow" },
          { text: "Secrets, pass & GPG", link: "/guide/secrets" },
          { text: "Installed Software", link: "/guide/installed-software" },
          { text: "Troubleshooting", link: "/guide/troubleshooting" },
          { text: "Development", link: "/guide/development" },
        ],
      },
      {
        text: "Shell",
        items: [{ text: "Reference", link: "/shell/reference" }],
      },
      {
        text: "Git",
        items: [
          { text: "Workflow", link: "/git/workflow" },
          { text: "GitHub CLI", link: "/git/github-cli" },
          { text: "Send Email", link: "/git/send-email" },
        ],
      },
      {
        text: "Termux",
        items: [
          { text: "Native Desktop", link: "/termux/native-desktop" },
          { text: "Ubuntu (proot)", link: "/termux/proot-setup-ubuntu" },
          { text: "Arch Linux (proot)", link: "/termux/proot-setup-archlinux" },
          { text: "Alpine (proot)", link: "/termux/proot-setup-alpine" },
          { text: "Fedora (proot)", link: "/termux/proot-setup-fedora" },
        ],
      },
      {
        text: "VS Code",
        items: [
          { text: "Termux Setup", link: "/vscode/termux-setup" },
          { text: "Keybindings", link: "/vscode/keybindings" },
          { text: "Extensions", link: "/vscode/extensions" },
        ],
      },
      {
        text: "Helix",
        items: [{ text: "Language Servers", link: "/helix/language-servers" }],
      },
    ],

    socialLinks: [{ icon: "github", link: repo }],
    search: { provider: "local" },
    outline: { level: [2, 3] },
    editLink: {
      pattern: `${repo}/edit/main/docs/:path`,
      text: "Edit this page on GitHub",
    },
    lastUpdated: { text: "Last updated" },
    footer: {
      message: "Released under the MIT License.",
      copyright: "Copyright © Gouranga Das Samrat",
    },
  },
});
