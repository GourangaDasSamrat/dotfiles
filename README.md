<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:bd93f9,50:ff79c6,100:8be9fd&height=220&section=header&text=.dotfiles&fontSize=90&fontAlignY=38&fontColor=ffffff&desc=a%20love%20letter%20to%20the%20terminal&descSize=16&descAlignY=60&descColor=ffffff&animation=fadeIn" width="100%"/>

<br/>

<a href="https://github.com/GourangaDasSamrat/dotfiles"><img src="https://img.shields.io/github/stars/GourangaDasSamrat/dotfiles?style=for-the-badge&logo=starship&color=bd93f9&logoColor=white&labelColor=1a1a2e" alt="stars"/></a>&nbsp;
<img src="https://img.shields.io/badge/shell-zsh-50fa7b?style=for-the-badge&logo=gnu-bash&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/managed%20with-stow-ff79c6?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/platform-linux%20%7C%20macos-8be9fd?style=for-the-badge&logo=linux&logoColor=white&labelColor=1a1a2e"/>&nbsp;
<img src="https://img.shields.io/badge/license-MIT-ffb86c?style=for-the-badge&logoColor=white&labelColor=1a1a2e"/>

<br/><br/>

> _"your terminal is where you live. make it beautiful."_

<br/>

</div>

---

<div align="center">

```
          zsh  ·  tmux  ·  vscode  ·  alacritty  ·  starship  ·  git  · gh · uSql
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

---

<br/>

<div align="center">

## `🐚 shell`

_built around fzf. everything has a live preview._
_every command feels intentional._

</div>

<br/>

<div align="center">

| &nbsp;&nbsp;&nbsp;command&nbsp;&nbsp;&nbsp; | what it does                                                                                                                  |
| :-----------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------- |
|                    `ls`                     | eza — icons, git status, long format. no flags needed                                                                         |
|                    `tab`                    | fzf-tab — fuzzy search with live previews while you type                                                                      |
|                   `mkdir`                   | asks to `git init`, creates README, makes the first commit                                                                    |
|                    `rm`                     | shows what dies. asks before it runs                                                                                          |
|                  `extract`                  | detects and unpacks any archive format. just point at it                                                                      |
|                 `compress`                  | fzf menu picks the format. then it compresses                                                                                 |
|                  `apireq`                   | full API client via fzf. saves requests as `.http` files                                                                      |
|                   `serve`                   | python http server with port conflict detection                                                                               |
|                   `timer`                   | `timer 1h30m` — color-coded countdown + desktop notification                                                                  |
|                  `backup`                   | timestamped `.tar.gz` of anything. one command                                                                                |
|                 `env-save`                  | encrypts `.env` into `pass` at any custom path. multi-line safe                                                               |
|                 `env-load`                  | pulls secrets from `pass` into `.env` or any custom filename                                                                  |
|                `lock-vault`                 | clears GPG agent cache immediately. locks your secret store                                                                   |
|                    `dzw`                    | Use dzw [key] domain.com to perform a filtered WHOIS lookup, either via a predefined server key or the default system server. |
|                   `isup`                    | checks if a site is live. follows redirects and handles connection errors gracefully                                          |
|                  `inspect`                  | deep-dives into headers. extracts server info, security headers, and content types                                            |
|                 ` weather`                  | fetches weather report for any city. clean, minimal, and non-breaking terminal output                                         |
|                   ` myip`                   | fetches public info and show IP address, city, region, and ISP                                                                |
|                     `t`                     | show timestamps before log                                                                                                    |

</div>

---

<br/>

<div align="center">

## `🪟 tmux`

_catppuccin macchiato · live weather in the status bar_
_sessions that survive reboots_

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

_six language profiles · italic keywords · ligatures · snippets_

</div>

<br/>

<div align="center">

| profile  |     formatter     |
| :------: | :---------------: |
| frontend | prettier + eslint |
| backend  | prettier + eslint |
| c / c++  |      clangd       |
|    go    | gopls + goimports |
| database |   prettier-sql    |
|   wiki   |     prettier      |

</div>

<br/>

font stack → **Operator Mono** · Cartograph CF · JetBrains Mono — with italic keywords and full ligatures.

snippets for **C++** (main, competitive programming, leetcode template) and **Go** (main, package, `iferr`, interface).

---

<br/>

<div align="center">

## `🔧 git`

_conventional commits enforced · clean aliases · nothing slips through_

</div>

<br/>

a `commit-msg` hook blocks any message that doesn't match `type(scope): subject`.
you get a clear error, valid types, and examples — every time.
a `pre-push` hook blocks push without password, you can expose the password on you shell script nameed with ,`GIT_PUSH_PASS`.

<br/>

```bash
git lg           # pretty graph log
git today        # commits since midnight
git yesterday    # yesterday's commits
git mine         # your commits only
git undo         # soft reset the last commit
git last         # full detail of the last commit
```

<div align="center">

## `🔧 github cli`

_clean aliases · nothing slips through_

</div>

<br/>

```bash
# --- Present (Current Activity) ---
gh today              # Every commit with timestamps since midnight (all repos)
gh today-summary      # Repo-wise summary + total commit count for today
gh today-stats        # Full profile-style contributions for today
gh this-month-summary # Accurate monthly report (handles 1000+ commits)
gh this-month-stats   # Full profile-style contributions for this month
gh this-year-summary  # Total commits this year (handles 1200+ accurately)
gh this-year-stats    # Full profile-style contributions for this year
gh this-year-languages # Top 5 languages used this year (by bytes)
gh streak             # Calculate your current and longest commit streak

# --- Past (Historical Activity) ---
gh yesterday          # Every commit with timestamps from yesterday (all repos)
gh yesterday-summary  # Repo-wise summary + total commit count for yesterday
gh yesterday-stats    # Full profile-style contributions for yesterday
gh last-month-summary # Accurate monthly report for previous month
gh last-month-stats   # Full profile-style contributions for last month
gh last-year-summary  # Full contribution summary for the previous year
gh last-year-stats    # Full profile-style contributions for last year
gh last-year-languages # Top 5 languages used in the previous year

# --- Utilities ---
gh prs                # Your PRs in the current repo with status
gh open               # Open the current repo in your default browser
gh co                 # Interactive PR checkout

```

---

<br/>

<div align="center">

## `🎨 terminal & prompt`

_alacritty · starship_

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

|                          |                                                                |
| :----------------------- | :------------------------------------------------------------- |
| **terminal**             | alacritty · tmux · starship · mpv · pass · git-lfs · moreutils |
| **shell utils**          | eza · bat · fzf · fd · jq · stow                               |
| **network**              | curl · wget · whois · gh                                       |
| **linux only**           | zsh · build-essential · rofi                                   |
| **mac only**             | uv                                                             |
| **zsh plugins**          | oh-my-zsh · autosuggestions · syntax-highlighting · fzf-tab    |
| **tmux plugins**         | tpm · catppuccin · resurrect · continuum                       |
| **go tools** _(opt)_     | gopls · goimports · golangci-lint · govulncheck · gotests · air · usql · shfmt         |
| **python tools** _(opt)_ | httpie · ytm-player                                            |

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
lib/python_tools.sh  optional python cli tools (but highly recommended)

install.sh           runs everything above in order
setup.sh             interactive — run only what you want
```

<div align="center">

_every script in `lib/` runs standalone. use only what you need._

</div>

---

<br/>

<div align="center">

## `🔩 prerequisites`

**git** &nbsp;·&nbsp; **homebrew** _(macOS only)_ — [brew.sh](https://brew.sh)

</div>

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
