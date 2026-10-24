<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:bd93f9,50:ff79c6,100:8be9fd&height=220&section=header&text=.dotfiles&fontSize=90&fontAlignY=38&fontColor=ffffff&desc=a%20love%20letter%20to%20the%20terminal&descSize=16&descAlignY=60&descColor=ffffff&animation=fadeIn" width="100%"/>

<br/>

<a href="https://github.com/GourangaDasSamrat/dotfiles"><img src="https://img.shields.io/github/stars/GourangaDasSamrat/dotfiles?style=for-the-badge&logo=starship&color=bd93f9&logoColor=white&labelColor=1a1a2e" alt="stars"/></a>&nbsp;
<img src="https://img.shields.io/badge/shell-zsh-50fa7b?style=for-the-badge&logo=gnu-bash&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/managed%20with-stow-ff79c6?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/platform-linux%20%7C%20macos%20%7C%20termux-8be9fd?style=for-the-badge&logo=linux&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/license-MIT-ffb86c?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>

<br/><br/>

> _"your terminal is where you live. make it beautiful."_

<br/>

</div>

---

<div align="center">

```
     zsh  ·  vscode · ghostty ·  starship  ·  helix  ·  git  ·  gh
```

</div>

---

<br/>

<div align="center">

## `⚡ one command. everything.`

</div>

<br/>

```bash
git clone https://github.com/GourangaDasSamrat/dotfiles.git ~/dotfiles
cd ~/dotfiles/scripts && ./install.sh
```

<div align="center">

_detects your os · installs every tool · symlinks every config · done_

</div>

<br/>

> want control? `./setup.sh` lets you pick exactly what to run.

> github unreachable? use the [gitlab mirror](https://gitlab.com/GourangaDasSamrat/dotfiles).

> the repo must live at `~/dotfiles` — the scripts and the `dot` alias expect it there.

> something not working? see [troubleshooting](https://dotfiles.gouranga.eu.org/guide/troubleshooting).

<div align="center">

|     platform     | package manager |
| :--------------: | :-------------: |
|      macOS       |     `brew`      |
| Debian / Ubuntu  |      `apt`      |
|    Arch Linux    |    `pacman`     |
|  Fedora / RHEL   |      `dnf`      |
| Termux (Android) |      `pkg`      |

</div>

---

<div align="center">

## `📖 documentation`

### **[dotfiles.gouranga.eu.org](https://dotfiles.gouranga.eu.org/)**

</div>

<br/>

<div align="center">

|                |                                                                                                                                                                                                                                                                                                                                                                       |
| :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **start here** | [getting started](https://dotfiles.gouranga.eu.org/guide/getting-started) · [gnu stow](https://dotfiles.gouranga.eu.org/guide/stow) · [secrets, pass & gpg](https://dotfiles.gouranga.eu.org/guide/secrets) · [installed software](https://dotfiles.gouranga.eu.org/guide/installed-software)                                                                         |
| **shell**      | [command reference](https://dotfiles.gouranga.eu.org/shell/reference)                                                                                                                                                                                                                                                                                                 |
| **git**        | [workflow](https://dotfiles.gouranga.eu.org/git/workflow) · [github cli](https://dotfiles.gouranga.eu.org/git/github-cli) · [send email](https://dotfiles.gouranga.eu.org/git/send-email)                                                                                                                                                                             |
| **editors**    | [keybindings](https://dotfiles.gouranga.eu.org/vscode/keybindings) · [extensions](https://dotfiles.gouranga.eu.org/vscode/extensions) · [helix](https://dotfiles.gouranga.eu.org/helix/language-servers)                                                                                                                                                              |
| **termux**     | [native desktop](https://dotfiles.gouranga.eu.org/termux/native-desktop) · [ubuntu](https://dotfiles.gouranga.eu.org/termux/proot-setup-ubuntu) · [arch](https://dotfiles.gouranga.eu.org/termux/proot-setup-archlinux) · [alpine](https://dotfiles.gouranga.eu.org/termux/proot-setup-alpine) · [fedora](https://dotfiles.gouranga.eu.org/termux/proot-setup-fedora) |
| **help**       | [troubleshooting & faq](https://dotfiles.gouranga.eu.org/guide/troubleshooting) · [development](https://dotfiles.gouranga.eu.org/guide/development)                                                                                                                                                                                                                   |
| **templates**  | [`.zsh_secrets`](docs/templates/.zsh_secrets.template) · [`.connections.usql`](docs/templates/.connections.usql.template)                                                                                                                                                                                                                                             |

</div>

---

<br/>

<div align="center">

## `✨ what's inside`

_every tool wears the same dracula_

</div>

<br/>

- **shell** — zsh · starship · fzf-tab · safe `rm` · `serve` / `expose` · `env-save` / `env-load` · history that keeps secrets out
- **git** — conventional commits enforced · signed · push guard via `pass` · delta · tidy aliases
- **vs code** — nine profiles · biome / clangd / gopls / rust-analyzer · snippets · italic ligatures
- **terminal** — ghostty · two-line starship prompt
- **and more** — helix · claude code statusline · rofi · usql · mongosh · cspell

> `install.sh` stows **zsh · bash · git · gh · cspell** and the vs code package. everything else is opt-in. see [gnu stow](https://dotfiles.gouranga.eu.org/guide/stow#opt-in-packages).

---

<br/>

<div align="center">

## `🛠️ development`

</div>

<br/>

```bash
just format    # biome + prettier + shfmt across the repo
```

commits follow [conventional commits](https://www.conventionalcommits.org), and the docs site rebuilds from `docs/` on every push to `main`. details in [development](https://dotfiles.gouranga.eu.org/guide/development).

---

<br/>

<div align="center">

**git** &nbsp;·&nbsp; **homebrew** _(macOS only)_ — [brew.sh](https://brew.sh)

</div>

---

<br/>
<br/>

---

<br/>
<br/>

<div align="center">

<img src="https://avatars.githubusercontent.com/GourangaDasSamrat" width="80" style="border-radius:50%"/>

<br/>

**Gouranga Das Samrat**
<br/>
_Software Developer_

<br/>

[![GitHub](https://img.shields.io/badge/@GourangaDasSamrat-1a1a2e?style=for-the-badge&logo=github&logoColor=bd93f9)](https://github.com/GourangaDasSamrat)&nbsp;
[![Email](https://img.shields.io/badge/gouranga.samrat@gmail.com-1a1a2e?style=for-the-badge&logo=gmail&logoColor=ff79c6)](mailto:gouranga.samrat@gmail.com)&nbsp;
[![Issues](https://img.shields.io/badge/report%20a%20bug-1a1a2e?style=for-the-badge&logo=github&logoColor=50fa7b)](https://github.com/GourangaDasSamrat/dotfiles/issues)

<br/>

_if this made your terminal feel like home — drop a_ ⭐

</div>
