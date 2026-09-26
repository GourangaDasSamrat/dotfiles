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
     zsh  ·  vscode  ·  kitty  ·  starship  ·  helix  ·  git  ·  gh  ·  claude
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

> the repo must live at `~/dotfiles` — the scripts and the `dot` alias expect it there.

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

<br/>

<div align="center">

## `🐚 shell`

_built around fzf. everything has a live preview._
_every command feels intentional._

</div>

<br/>

<div align="center">

| &nbsp;&nbsp;&nbsp;command&nbsp;&nbsp;&nbsp; | what it does                                                                                                    |
| :-----------------------------------------: | :-------------------------------------------------------------------------------------------------------------- |
|                    `ls`                     | eza — icons, git status, long format. no flags needed. `lt` for a tree, `ll` and `la` for the rest              |
|                    `tab`                    | fzf-tab — fuzzy search with live previews while you type                                                        |
|                   `mkdir`                   | asks to `git init`, creates README, makes the first commit                                                      |
|                    `rm`                     | shows what dies, asks before it runs. sends to trash when available. system folders are protected               |
|                  `extract`                  | detects and unpacks any archive format. just point at it                                                        |
|                 `compress`                  | fzf menu picks the format. then it compresses                                                                   |
|                   `serve`                   | python http server with port prompt and conflict detection. `-b` binds to the whole network                     |
|                  `expose`                   | puts a localhost port on the internet through a cloudflared quick tunnel. prints the public url                 |
|                  `backup`                   | timestamped `.tar.gz` of anything. one command                                                                  |
|                 `env-save`                  | encrypts `.env` into `pass` at any custom path. multi-line safe                                                 |
|                 `env-load`                  | pulls secrets from `pass` into `.env` or any custom filename                                                    |
|                `lock-vault`                 | clears GPG agent cache immediately. locks your secret store. `afk` locks, clears the screen and exits           |
|                 `gentoken`                  | cryptographically secure random token — url-safe base64 by default, `-x` hex, `-b` base64                       |
|                  `gensalt`                  | cryptographically secure random salt — hex by default, `-b` for base64                                          |
|                    `dzw`                    | `dzw [key] domain.com` — filtered WHOIS lookup through a predefined server key or the system default            |
|                   `isup`                    | checks if a site is live. follows redirects and handles connection errors gracefully                            |
|                  `inspect`                  | deep-dives into a host. response headers, server info and TLS certificate dates                                 |
|                    `yt`                     | streams video and playlist urls via mpv & yt-dlp. `-q` height · `-n` start index · `-a` audio · `-f` fullscreen |
|     `apt` `brew` `dnf` &nbsp;`i` / `rm`     | short forms — `apt i git`, `brew rm bat`, `dnf i zsh`. everything else passes straight through                  |

</div>

<br/>

<div align="center">

### **it does things on its own**

</div>

<br/>

- **cd hooks** — entering a folder auto-activates its python venv (`.venv`, `venv`, `.env`) and lists what you can run: Justfile recipes, Makefile targets, npm / bun scripts, docker compose services.
- **history that keeps secrets out** — commands with passwords, tokens, API keys, `export KEY=…`, credentialed urls and force-pushes never reach `~/.zsh_history`.
- **plugins via [antidote](https://github.com/mattmc3/antidote)** — bootstraps itself on first launch. oh-my-zsh libs + `git` plugin · fzf-tab · autosuggestions · syntax-highlighting.
- **fzf, themed** — dracula colors (catppuccin is one line away), `fd`-powered search, `eza` and `bat` previews everywhere.
- **secrets loader** — `~/.zsh_secrets` is sourced at startup and complains unless it is `chmod 600`. a template lives in [`docs/templates`](docs/templates).
- **bash fallback** — `.bashrc` mirrors the core aliases, history hygiene and paths.

<br/>

```bash
dot / dots           # cd into ~/dotfiles or ~/dotfiles/scripts
reload               # re-source the zsh config
cp / mv              # interactive + verbose by default

gr · gb · gmod       # go run . · go build · go mod
cr · cb · ct · cc    # cargo run · build · test · check
cn · ccl             # cargo new · clean
cdoc · cdc           # cargo doc --open · doc --no-deps --open

usql · mongosh       # start quiet, dracula-themed

# termux only
debian               # login to proot-debian
af / lf              # jump to android storage / the debian home
```

---

<br/>

<div align="center">

## `🖥️ vs code`

_eight profiles · italic keywords · ligatures · snippets_

</div>

<br/>

<div align="center">

| profile  |  alias   |             formatter             |
| :------: | :------: | :-------------------------------: |
| default  |  `code`  |               biome               |
| frontend | `code-f` |               biome               |
| backend  | `code-b` |               biome               |
| c / c++  | `code-c` |              clangd               |
|    go    | `code-g` |         gopls + goimports         |
|   rust   | `code-r` | rust-analyzer _(clippy pedantic)_ |
|   lua    | `code-l` |        lua-language-server        |
| database | `code-d` |           prettier-sql            |
|   wiki   | `code-w` |             prettier              |

</div>

<br/>

font stack → **Operator Mono** · Cartograph CF · MonoLisa · JetBrains Mono Nerd Font — with italic keywords and full ligatures. theme → **Dracula** with Material Icons.

snippets for **C++** (main, competitive programming, leetcode template), **Go** (main, package, `iferr`, interface), **Rust** (a full competitive-programming kit — fast i/o, bfs/dfs, sieve, union-find, bit tricks), **React** components and a `.clang-format` starter.

format on save · biome fix-all on save · [Commit Sage](docs/vscode/extensions.md) writes conventional commit messages · telemetry off.

---

<br/>

<div align="center">

## `🔧 git`

_conventional commits enforced · signed · clean aliases · nothing slips through_

</div>

<br/>

a `commit-msg` hook blocks any message that doesn't match `type(scope): subject`.
you get a clear error, valid types, and examples — every time. it also tidies indented bullet points and warns when the header runs past 72 characters.

a `pre-push` hook asks for a passphrase before every push. the expected value is read from `pass` (`git/push_pass`), so a stray `git push` can't go out by accident.

everything else is set up for a calm workflow: **GPG-signed commits** · **delta** pager with side-by-side dracula diffs · **push over SSH, pull over HTTPS** · `pull.rebase` with autostash · `rerere` · auto-prune on fetch · `push.autoSetupRemote` · **git-lfs** · `git send-email` through Gmail SMTP with the password kept in `pass`.

<br/>

```bash
git lg           # pretty graph log
git lga          # same graph, every branch
git today        # commits since midnight
git yesterday    # yesterday's commits
git lastmonth    # commits from the past month
git monthstat    # who committed how much this month
git mine         # your commits only
git last         # full detail of the last commit
git undo         # soft reset the last commit
git unstage      # unstage all staged files
git gone         # delete local branches whose remote is gone
git el           # export the full log to git_history.txt
```

---

<br/>

<div align="center">

## `🔧 github cli`

_contribution stats · streaks · language insights_

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

_kitty · starship_

</div>

<br/>

**Kitty** — JetBrains Mono Nerd Font, dracula theme, 90% opacity with background blur, no title bar. `F5` / `F6` open vertical / horizontal splits, `alt+1…9` jump between tabs, remote control is on. macOS and Linux each get their own small include.

**Starship** — two-line prompt. directory and language modules on the left, git branch / status and command duration on the right, prompt character below. language modules inline — node, go, python, rust, java, lua, zig, and more. shows the vs code version in any directory.

---

<br/>

<div align="center">

## `🧰 and the rest`

_every tool wears the same dracula_

</div>

<br/>

<div align="center">

|                 |                                                                                                                                                                                        |
| :-------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **helix**       | auto-save + auto-format · inlay hints · language servers for c/c++, rust, go, lua, bash, web, json, yaml, toml, markdown, sql — see [language servers](docs/helix/language-servers.md) |
| **claude code** | dracula theme and a truecolor statusline — model, folder, git state, context bar, cost, duration, rate limit                                                                           |
| **rofi**        | dracula `drun` launcher                                                                                                                                                                |
| **usql**        | dracula syntax highlighting, unicode tables, connection aliases from `~/.connections.usql`                                                                                             |
| **mongosh**     | dracula prompt that shows connection state, quiet greeting                                                                                                                             |
| **ytm-player**  | YouTube Music in the terminal — dracula theme, album art, playback cache                                                                                                               |
| **cspell**      | shared `personal-names` and `tech-tools` dictionaries                                                                                                                                  |

</div>

<br/>

> `install.sh` stows **zsh · bash · git · gh · kitty · cspell** and the vs code package. the rest is opt-in — from `~/dotfiles` run `stow helix claude rofi usql mongosh ytm-player` for whatever you want.

---

<br/>

<div align="center">

## `📦 what gets installed`

_lists live in [`scripts/utils/software_lists.sh`](scripts/utils/software_lists.sh)_

</div>

<br/>

<div align="center">

|                          |                                                                                                                                                                                                  |
| :----------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **everywhere**           | curl · wget · jq · httpie · openssl · fd · ripgrep · fzf · eza · bat · duf · bash-completion · shfmt · shellcheck · just · moreutils · stow · gh · git-lfs · git-delta · pass · starship · helix |
| **linux extras**         | zsh · pinentry-gnome3 · rofi                                                                                                                                                                     |
| **build tools**          | build-essential / base-devel _(apt, pacman)_ · development-tools + openssl-devel _(dnf)_                                                                                                         |
| **arch**                 | rustup · cargo-binstall · uv · bun · fnm · docker · biome · go · golangci-lint · gopls · cloudflared · pkgfile                                                                                            |
| **macOS**                | rustup · cargo-binstall · uv · bun · fnm · biome · go · goimports · golangci-lint · gopls · air · docker · colima · sccache · cloudflared · usql                                                 |
| **macOS apps**           | vs code · kitty · bruno · tableplus · zen · notion · discord · iina · raycast · alt-tab · hiddenbar · pinentry-mac · JetBrains Mono Nerd Font                                     |
| **termux**               | build-essential · nodejs · bun · uv · biome · usql · go + tools · rust + rust-analyzer · cloudflared · code-oss · zen-browser · mpv · yt-dlp · gtrash · mousepad · eog · galculator              |
| **go tools** _(opt)_     | goimports · gopls · golangci-lint · govulncheck · gotests · air · goreleaser · usql · eget · sheets · gtrash                                                                                     |
| **rust tools** _(opt)_   | cargo-watch · cargo-cache · cargo-dist · cargo-modules                                                                                                                                           |
| **python tools** _(opt)_ | ytm-player _(via uv)_                                                                                                                                                                            |

</div>

<br/>

_packages that ship under different names (`fd` / `fd-find`, `bat` / `batcat`) are matched automatically — whichever your distro has gets installed._

---

<br/>

<div align="center">

## `🏗️ scripts architecture`

</div>

<br/>

<div align="center">

### **Quick Start**

```bash
# automated — install everything
./install.sh

# interactive — choose what to run
./setup.sh
```

</div>

<br/>

### **Folder Structure**

```
scripts/
├── install.sh              full automated setup (runs lib/ scripts)
├── setup.sh                interactive menu — pick and choose
│
├── lib/                    modular setup scripts (standalone)
│   ├── softwares.sh        install packages for your os and package manager
│   ├── wallpapers.sh       download the wallpaper collection
│   ├── fonts.sh            apple's SF Pro & SF Mono on linux (needs wget + 7z)
│   └── dotfiles.sh         symlink configs with gnu stow
│
├── sdk-tools/              optional language-specific installers
│   ├── cargo-tools.sh      rust cli tools (cargo-watch, cargo-cache, etc.)
│   ├── go-tools.sh         go dev tools (gopls, golangci-lint, goreleaser, etc.)
│   └── uv-tools.sh         python cli tools via uv package manager
│
├── utils/
│   ├── detect.sh           os · package manager · sudo detection
│   └── software_lists.sh   package lists per os, distro and environment
│
└── config/
    └── wallpapers.url      wallpapers list, one url per line
```

<div align="center">

_Every script in `lib/` and `sdk-tools/` runs standalone. Source only what you need._

</div>

---

<br/>

### **Usage Modes**

<br/>

**`./install.sh`** — Full automated setup

- runs `lib/softwares.sh` → packages for your os
- runs `lib/wallpapers.sh` → wallpapers into `~/Pictures/wallpapers`
- runs `lib/fonts.sh` → apple fonts _(linux only)_
- runs `lib/dotfiles.sh` → symlink configs with stow
- ⏭️ skips optional sdk-tools

**`./setup.sh`** — Interactive menu

- lists every script (`install.sh`, `lib/`, `sdk-tools/`)
- pick numbers or type `all`, confirm, and watch a pass / fail summary
- includes optional language tools (Go, Rust, Python)

**Optional Language Tools** — Run individually

```bash
./sdk-tools/go-tools.sh       # install go dev tools (requires go)
./sdk-tools/cargo-tools.sh    # install rust cli tools (requires cargo)
./sdk-tools/uv-tools.sh       # install python tools (requires uv)
```

<div align="center">

Add `--update` flag to force reinstall: `./sdk-tools/go-tools.sh --update`

</div>

---

<br/>

<div align="center">

## `📚 documentation`

</div>

<br/>

<div align="center">

|   Category    | Documentation                                                                                                                     |
| :-----------: | :-------------------------------------------------------------------------------------------------------------------------------- |
|    **git**    | [send-email setup](docs/git/send-email.md)                                                                                        |
|  **vs code**  | [extensions](docs/vscode/extensions.md) · [keybindings](docs/vscode/keybindings.md) · [termux setup](docs/vscode/termux-setup.md) |
|   **helix**   | [language servers](docs/helix/language-servers.md)                                                                                |
|  **termux**   | [native desktop](docs/termux/native-desktop.md) · [proot debian](docs/termux/proot-debian.md)                                     |
| **templates** | [`.zsh_secrets`](docs/templates/.zsh_secrets.template) · [`.connections.usql`](docs/templates/.connections.usql.template)         |

</div>

---

<br/>

<div align="center">

## `🛠️ development`

</div>

<br/>

```bash
just format    # biome + prettier + shfmt across the repo
```

**ci** — shellcheck on every shell script · a scripts sanity check · tagging `vX.Y.Z` cuts a GitHub release with notes generated by [git-cliff](https://git-cliff.org) and refreshes `CHANGELOG.md` · the repo is mirrored to GitLab.

commits follow [conventional commits](https://www.conventionalcommits.org) — the `commit-msg` hook will remind you.

---

<br/>

<div align="center">

## `⚙️ prerequisites`

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
