<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:bd93f9,50:ff79c6,100:8be9fd&height=220&section=header&text=.dotfiles&fontSize=90&fontAlignY=38&fontColor=ffffff&desc=a%20love%20letter%20to%20the%20terminal&descSize=16&descAlignY=60&descColor=ffffff&animation=fadeIn" width="100%"/>

<br/>

<a href="https://github.com/GourangaDasSamrat/dotfiles"><img src="https://img.shields.io/github/stars/GourangaDasSamrat/dotfiles?style=for-the-badge&logo=starship&color=bd93f9&logoColor=white&labelColor=1a1a2e" alt="stars"/></a>&nbsp;
<img src="https://img.shields.io/badge/shell-zsh-50fa7b?style=for-the-badge&logo=gnu-bash&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/managed%20with-stow-ff79c6?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/platform-linux%20%7C%20macos-8be9fd?style=for-the-badge&logo=linux&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/license-MIT-ffb86c?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>

<br/><br/>

> *"your terminal is where you live. make it beautiful."*

<br/>

</div>

---

<div align="center">

```
          zsh  ·  tmux  ·  vscode  ·  alacritty  ·  starship  ·  git
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

*detects your os · installs every tool · symlinks every config · done*

</div>

<br/>

> want control? `./setup.sh` lets you pick exactly what to run.

---

<br/>

<div align="center">

## `🐚 shell`

*built around fzf. everything has a live preview.*
*every command feels intentional.*

</div>

<br/>

<div align="center">

| &nbsp;&nbsp;&nbsp;command&nbsp;&nbsp;&nbsp; | what it does |
|:---:|:---|
| `ls` | eza — icons, git status, long format. no flags needed |
| `tab` | fzf-tab — fuzzy search with live previews while you type |
| `mkdir` | asks to `git init`, creates README, makes the first commit |
| `rm` | shows what dies. asks before it runs |
| `extract` | detects and unpacks any archive format. just point at it |
| `compress` | fzf menu picks the format. then it compresses |
| `weather` | temperature bar · humidity · 3-day forecast in your terminal |
| `apireq` | full API client via fzf. saves requests as `.http` files |
| `serve` | python http server with port conflict detection |
| `timer` | `timer 1h30m` — color-coded countdown + desktop notification |
| `backup` | timestamped `.tar.gz` of anything. one command |
| `cleanup` | deep-cleans npm, pip, cargo, go, docker, apt, brew and more |
| `ff` | fuzzy file finder from current directory |

</div>

---

<br/>

<div align="center">

## `🪟 tmux`

*catppuccin macchiato · live weather in the status bar*
*sessions that survive reboots*

</div>

<br/>

```
  prefix      ctrl+a            splits        |  and  -
  navigate    h · j · k · l     windows       alt + 1–5
  mouse       on                persist       auto-save every 5 min
```

<br/>

<div align="center">

tmux-resurrect + tmux-continuum restore your exact layout,
panes, and working directories after every reboot.

</div>

---

<br/>

<div align="center">

## `🖥️ vs code`

*six language profiles · italic keywords · ligatures · snippets*

</div>

<br/>

<div align="center">

| profile | formatter |
|:---:|:---:|
| frontend | prettier + eslint |
| backend | prettier + eslint |
| c / c++ | clangd |
| go | gopls + goimports |
| database | prettier-sql |
| default | prettier |

</div>

<br/>

font stack → **Operator Mono** · Cartograph CF · JetBrains Mono — with italic keywords and full ligatures.

snippets for **C++** (main, competitive programming, leetcode template) and **Go** (main, package, `iferr`, interface).

---

<br/>

<div align="center">

## `🔧 git`

*conventional commits enforced · clean aliases · nothing slips through*

</div>

<br/>

a `commit-msg` hook blocks any message that doesn't match `type(scope): subject`.
you get a clear error, valid types, and examples — every time.

<br/>

```bash
git lg           # pretty graph log
git today        # commits since midnight
git yesterday    # yesterday's commits
git mine         # your commits only
git undo         # soft reset the last commit
git last         # full detail of the last commit
```

---

<br/>

<div align="center">

## `🎨 terminal & prompt`

*alacritty · starship*

</div>

<br/>

**Alacritty** — dracula theme · JetBrainsMono Nerd Font · 95% opacity + blur · `option_as_alt` for macOS

**Starship** — two-line prompt. directory + git on line one. language modules inline — node, go, python, rust, java, and more. shows vs code version in any directory.

---

<br/>

<div align="center">

## `📦 what gets installed`

</div>

<br/>

<div align="center">

| | |
|:---|:---|
| **terminal** | alacritty · tmux · starship |
| **shell utils** | eza · bat · fzf · fd · jq · shfmt · stow |
| **network** | curl · wget · gh |
| **linux only** | zsh · build-essential · rofi |
| **zsh plugins** | oh-my-zsh · autosuggestions · syntax-highlighting · fzf-tab |
| **tmux plugins** | tpm · catppuccin · resurrect · continuum |
| **go tools** *(opt)* | gopls · goimports · golangci-lint |

</div>

---

<br/>

<div align="center">

## `🏗️ architecture`

</div>

<br/>

```
utils/detect.sh      os · package manager · sudo detection

lib/packages.sh      installs every tool
lib/plugins.sh       oh my zsh · tpm · zsh plugins
lib/wallpapers.sh    clones wallpapers repo
lib/dotfiles.sh      gnu stow · git hook permissions
lib/go_tools.sh      optional go dev tools

install.sh           runs everything above in order
setup.sh             interactive — run only what you want
```

<div align="center">

*every script in `lib/` runs standalone. use only what you need.*

</div>

---

<br/>

<div align="center">

## `🔩 prerequisites`

**git** &nbsp;·&nbsp; **homebrew** *(macOS only)* — [brew.sh](https://brew.sh)

</div>

---

<br/>
<br/>


<div align="center">

<img src="https://avatars.githubusercontent.com/GourangaDasSamrat" width="80" style="border-radius:50%"/>

<br/>

**Gouranga Das Samrat**
<br/>
*Software Engineer*

<br/>

[![GitHub](https://img.shields.io/badge/@GourangaDasSamrat-1a1a2e?style=for-the-badge&logo=github&logoColor=bd93f9)](https://github.com/GourangaDasSamrat)&nbsp;
[![Email](https://img.shields.io/badge/gouranga.samrat@gmail.com-1a1a2e?style=for-the-badge&logo=gmail&logoColor=ff79c6)](mailto:gouranga.samrat@gmail.com)&nbsp;
[![Issues](https://img.shields.io/badge/report%20a%20bug-1a1a2e?style=for-the-badge&logo=github&logoColor=50fa7b)](https://github.com/GourangaDasSamrat/dotfiles/issues)

<br/>

*if this made your terminal feel like home — drop a* ⭐

</div>