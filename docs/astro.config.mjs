import { unified } from "@astrojs/markdown-remark";
import starlight from "@astrojs/starlight";
import { defineConfig } from "astro/config";
import starlightLinksValidator from "starlight-links-validator";
import { rehypeBaseLinks } from "./src/plugins/rehype-base-links.mjs";

const repo = "https://github.com/GourangaDasSamrat/dotfiles";
const base = "/dotfiles";

// Runs before first paint. Keep the palette ids in sync with `src/lib/palettes.ts`.
// The site defaults to dark until the visitor picks a mode.
const paletteBootstrap = `
try {
  if (localStorage.getItem("starlight-theme") === null) {
    localStorage.setItem("starlight-theme", "dark");
    document.documentElement.dataset.theme = "dark";
  }
} catch (_) {}
try {
  var p = localStorage.getItem("dotfiles-palette");
  document.documentElement.dataset.palette =
    ["dracula", "catppuccin", "tokyo-night", "nord", "rose-pine"].includes(p) ? p : "dracula";
} catch (_) {
  document.documentElement.dataset.palette = "dracula";
}
`;

export default defineConfig({
  site: "https://gourangadassamrat.github.io",
  base,
  trailingSlash: "always",
  markdown: {
    processor: unified({ rehypePlugins: [[rehypeBaseLinks, { base }]] }),
  },
  integrations: [
    starlight({
      title: "Dotfiles",
      description: "Setup guides and notes for my dotfiles",
      lastUpdated: true,
      favicon: "/favicon.svg",
      plugins: [starlightLinksValidator()],
      social: [{ icon: "github", label: "GitHub", href: repo }],
      editLink: { baseUrl: `${repo}/edit/main/docs/` },
      tableOfContents: { minHeadingLevel: 2, maxHeadingLevel: 3 },
      customCss: [
        "@fontsource-variable/inter",
        "@fontsource-variable/jetbrains-mono",
        "./src/styles/palettes.css",
        "./src/styles/custom.css",
      ],
      components: {
        ThemeSelect: "./src/components/ThemeSelect.astro",
        PageTitle: "./src/components/PageTitle.astro",
      },
      expressiveCode: {
        themes: ["dracula", "github-light"],
        useStarlightUiThemeColors: true,
        styleOverrides: { borderRadius: "0.6rem" },
      },
      head: [
        { tag: "script", content: paletteBootstrap },
        { tag: "meta", attrs: { name: "theme-color", content: "#bd93f9" } },
      ],
      sidebar: [
        {
          label: "Guide",
          items: [
            "guide/getting-started",
            "guide/stow",
            "guide/secrets",
            "guide/installed-software",
            "guide/troubleshooting",
            "guide/development",
          ],
        },
        { label: "Shell", items: ["shell/reference"] },
        {
          label: "Git",
          items: ["git/workflow", "git/github-cli", "git/send-email"],
        },
        {
          label: "Termux",
          items: [
            "termux/native-desktop",
            { label: "Ubuntu (proot)", slug: "termux/proot-setup-ubuntu" },
            {
              label: "Arch Linux (proot)",
              slug: "termux/proot-setup-archlinux",
            },
            { label: "Alpine (proot)", slug: "termux/proot-setup-alpine" },
            { label: "Fedora (proot)", slug: "termux/proot-setup-fedora" },
          ],
        },
        {
          label: "VS Code",
          items: [
            "vscode/termux-setup",
            "vscode/keybindings",
            "vscode/extensions",
          ],
        },
        { label: "Helix", items: ["helix/language-servers"] },
        {
          label: "Changelog",
          link: `${repo}/blob/main/CHANGELOG.md`,
          attrs: { target: "_blank", rel: "noopener" },
        },
      ],
    }),
  ],
});
