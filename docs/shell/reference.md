# Shell Reference

The shell is zsh, configured under `~/.config/zsh` (linked from the `zsh`
[package](../guide/stow)), with [starship](https://starship.rs) as the prompt and
[fzf](https://github.com/junegunn/fzf) wired into everything. This page lists every
command and behaviour the config adds.

## How it loads

`~/.zshenv` points `ZDOTDIR` at `~/.config/zsh`. `.zshrc` then:

1. exports `GPG_TTY` and sets up the completion cache,
2. bootstraps [antidote](https://github.com/mattmc3/antidote) (cloned to
   `~/.antidote` on first run) and loads the plugins,
3. starts starship,
4. sources the modules below **in this order**,
5. prints the session start time, then loads `~/.zsh_secrets` if it exists.

| Module               | Provides                                                  |
| -------------------- | --------------------------------------------------------- |
| `core/env`           | Environment variables, `PATH`, `fnm`, `sccache`, browser  |
| `core/colors`        | Colour variables and the `_ok` / `_err` / `_warn` helpers |
| `core/history`       | History settings and the credential filter                |
| `functions/utils`    | `backup`                                                  |
| `functions/archive`  | `extract`, `compress`                                     |
| `functions/chpwd`    | The `cd` hooks                                            |
| `functions/pkg`      | `apt` / `brew` / `dnf` short forms                        |
| `plugins/fzf`        | fzf themes, key bindings, previews                        |
| `plugins/pass`       | `env-save`, `env-load`                                    |
| `user/aliases`       | All aliases                                               |
| `functions/security` | `gentoken`, `gensalt`, the vault auto-lock                |
| `user/overrides`     | The safer `mkdir` and `rm`                                |
| `functions/whois`    | `dzw`                                                     |
| `functions/network`  | `serve`, `expose`, `isup`, `inspect`                      |
| `functions/media`    | `yt`                                                      |

Plugins loaded by antidote: the oh-my-zsh `functions`, `key-bindings`,
`directories`, `history`, `termsupport` and `completion` libs, the oh-my-zsh `git`
plugin, `fzf-tab`, `zsh-autosuggestions` and `zsh-syntax-highlighting` (kept last).

## Files and folders

| Command             | What it does                                                                                                                    |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `ls`                | `eza` in long format with icons and git status, without sizes, times, users or permissions                                      |
| `ll`                | `eza -lh` with icons — the full long listing                                                                                    |
| `la`                | `ls -A` — include hidden files                                                                                                  |
| `lt`                | Tree view (`eza --tree -a`), ignoring `.git`, `node_modules`, `target` and `.venv`                                              |
| `cp`, `mv`          | Interactive and verbose (`-iv`)                                                                                                 |
| `mkdir <dir>`       | Creates the folder (with parents). With one argument it asks whether to `git init`, add a `README.md` and make the first commit |
| `rm <paths>`        | Lists what will be deleted and asks for confirmation (default is **No**)                                                        |
| `extract <archive>` | Detects the format and unpacks it in place                                                                                      |
| `compress <path>`   | Opens an fzf menu to pick the format, then archives the file or folder                                                          |
| `backup <path>`     | Creates `<path>_backup_<timestamp>.tar.gz` next to the original                                                                 |

### `rm` in detail

- Paths that do not exist are reported and nothing is deleted.
- System and home folders are **protected** and refused: `/`, `/usr`, `/etc`,
  `/var`, `/boot`, `$HOME`, `~/Documents`, `~/Downloads`, `~/Pictures` and similar.
- When a trash tool is available (`trash` on macOS, `gtrash` on Linux and Termux)
  files are moved to the trash. Otherwise the prompt warns that deletion is
  permanent.
- Flags such as `-rf` are passed through only on the permanent-delete path.

### `extract` and `compress` formats

`extract` handles `tar` (`.gz`, `.bz2`, `.xz`, `.zst`, `.lz4`, `.lzma`), `zip`,
`rar`, `7z`, `iso`, single-file `gz`, `bz2`, `xz`, `zst`, `lz4`, `lzma`, `Z`, and
also `deb`, `rpm` and `cab`. `compress` offers `tar.gz`, `tar.bz2`, `tar.xz`,
`tar.zst`, `tar.lz4`, `zip`, `7z`, `rar` and the single-file formats; the
external tool for the chosen format must be installed.

## Network and web

| Command              | What it does                                                                                                                                                                        |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `serve [port] [-b]`  | Python HTTP server for the current folder. Prompts for a port (default 8000) and rejects ports already listening. `-b` / `--bind-all` binds `0.0.0.0` so other devices can reach it |
| `expose [port]`      | Opens a `cloudflared` quick tunnel to `localhost:<port>` (default prompt 4000) and prints the public `trycloudflare.com` URL. Ctrl+C stops it                                       |
| `isup [host]`        | Follows redirects and reports ONLINE with the status code, an ISSUE for non-200 codes, or OFFLINE                                                                                   |
| `inspect [host]`     | Shows selected response headers (server, content type, cache, security) and the TLS certificate start and expiry dates                                                              |
| `dzw [key] <domain>` | Filtered WHOIS lookup. With a key it uses a predefined server, without one the system default                                                                                       |

`expose` needs `cloudflared`; `isup` and `inspect` need `httpie` (`http`), and
`inspect` also needs `openssl`. A function is only defined when its dependency is
installed.

`dzw` keys are defined in `functions/whois.zsh`:

| Key    | Server                   |
| ------ | ------------------------ |
| `dp`   | `whois.digitalplat.org`  |
| `iana` | `whois.iana.org`         |
| `com`  | `whois.verisign-grs.com` |

```bash
dzw example.com          # default WHOIS server
dzw com example.com      # via Verisign
```

## Security helpers

| Command                         | What it does                                                                                              |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `gentoken [bytes] [-x\|-b\|-u]` | Random token from `/dev/urandom`. Default 32 bytes, URL-safe base64. `-x` hex, `-b` base64, `-u` URL-safe |
| `gensalt [bytes] [-b]`          | Random salt. Default 16 bytes in hex, `-b` for base64                                                     |
| `env-save`, `env-load`          | Move `.env` files in and out of `pass`                                                                    |
| `lock-vault`, `afk`             | Drop the GPG cache; `afk` also clears the screen and exits                                                |

`env-save`, `env-load`, `lock-vault` and `afk` are explained in
[Secrets, pass & GPG](../guide/secrets).

```bash
gentoken            # 32 random bytes, URL-safe base64
gentoken 64 -x      # 64 random bytes as hex
gensalt -b          # 16 random bytes as base64
```

## Media

```bash
yt <url>                 # stream at 480p
yt <url> 1080            # a bare 144/240/360/480/720/1080/1440/2160 sets the height
yt <playlist-url> 5      # any other bare number is the playlist start index
yt -a <url>              # audio only
yt -f -q 720 -n 3 <url>  # fullscreen, 720p, start at item 3
```

`yt` streams through `mpv` and `yt-dlp`, and is defined only when both exist.
Flags: `-q` height, `-n` start index, `-a` audio only, `-f` fullscreen.

## Package managers

`apt`, `brew` and `dnf` get two short forms, and everything else passes straight
through to the real command:

```bash
apt i git        # apt install git
brew rm bat      # brew uninstall bat
dnf i zsh        # dnf install zsh
apt update       # unchanged
```

## Aliases

| Group      | Aliases                                                                                                           |
| ---------- | ----------------------------------------------------------------------------------------------------------------- |
| Navigation | `dot` → `~/dotfiles`, `dots` → `~/dotfiles/scripts`, `reload` re-sources the zsh config                           |
| Go         | `gr` = `go run .`, `gb` = `go build`, `gmod` = `go mod`                                                           |
| Cargo      | `cr` run, `cb` build, `ct` test, `cc` check, `cn` new, `ccl` clean, `cdoc` doc --open, `cdc` doc --no-deps --open |
| Databases  | `usql` and `mongosh` start in quiet mode                                                                          |
| Distro fix | `fd` → `fdfind`, `bat` → `batcat`, `wget` → `wget2` when only those names exist                                   |
| `bun`      | A bare `bun` runs `bun install` inside a project (when `package.json` exists), otherwise `bun repl`               |

Aliases are created only when the tool exists, so a missing tool never produces a
broken alias.

### VS Code profiles

| Alias    | Profile      |
| -------- | ------------ |
| `code`   | Default      |
| `code-f` | Frontend Dev |
| `code-b` | Backend Dev  |
| `code-c` | C/C++ Dev    |
| `code-g` | Go Dev       |
| `code-r` | Rust Dev     |
| `code-l` | Lua Dev      |
| `code-d` | Database Dev |
| `code-w` | Wiki Dev     |

`code` resolves to `code-oss`, `code-insiders` or `code`, whichever is installed
first in that order.

### Termux only

| Alias    | Action                                                |
| -------- | ----------------------------------------------------- |
| `af`     | `cd` to Android storage (`/storage/emulated/0`)       |
| `debian` | Log into the `debian` proot-distro as user `gouranga` |
| `lf`     | `cd` to that Debian user's home from the Termux side  |
| `open`   | Mapped to `xdg-utils-xdg-open`                        |

::: warning
The `debian` and `lf` aliases hard-code the user name `gouranga`. Edit them in
`user/aliases.zsh` if your proot user is called something else.
:::

## Automatic behaviour

### `cd` hooks

Every directory change triggers two hooks:

- **Python virtualenv** — entering a folder with `.venv`, `venv` or `.env`
  activates it; leaving deactivates it.
- **Project tasks** — lists what you can run: Justfile recipes, otherwise Makefile
  targets, otherwise `package.json` scripts (labelled Bun or NPM by lockfile), plus
  the services of a Docker Compose file.

`fnm` also switches Node versions automatically when a folder has a version file.

### History

History is shared between sessions (10,000 entries) and ignores duplicates and
commands starting with a space. A filter keeps credentials out of
`~/.zsh_history`; the full rules are in
[Secrets, pass & GPG](../guide/secrets#what-the-shell-keeps-out-of-history).

### fzf

- Search runs through `fd` (hidden files included, `.git` excluded).
- <kbd>Ctrl</kbd>+<kbd>T</kbd> picks files and <kbd>Alt</kbd>+<kbd>C</kbd> picks
  directories, both with live previews (`bat` for files, `eza --tree` for folders).
- `fzf-tab` replaces the tab-completion menu with a fuzzy one that previews as you
  type.
- The theme is Dracula. Catppuccin is already defined: in `plugins/fzf.zsh`, change
  the active line from `_fzf_theme_dracula` to `_fzf_theme_catppuccin`.

## Environment

| Variable / setting | Value                                                                                                                      |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| `EDITOR`, `VISUAL` | `hx` (Helix)                                                                                                               |
| `PAGER`            | `less` with mouse support                                                                                                  |
| `DOTFILES`         | `~/dotfiles`                                                                                                               |
| `BAT_THEME`        | `Dracula`                                                                                                                  |
| `PATH` additions   | LLVM (Homebrew), pnpm, bun, `~/.cargo/bin`, `~/go/bin`, `~/.local/bin`; missing folders are dropped and duplicates removed |
| `sccache`          | When installed, used as the Rust and C/C++ compiler wrapper with a 20 GB cache in `~/.cache/sccache`                       |
| `BROWSER`          | `zen-browser` or `zen`, whichever exists                                                                                   |
| Termux             | `TZ=Asia/Dhaka`, `SSL_CERT_FILE` and `XDG_DATA_HOME` are set                                                               |

## Customising

| To change...                | Edit                                                                                           |
| --------------------------- | ---------------------------------------------------------------------------------------------- |
| An alias                    | `user/aliases.zsh`                                                                             |
| Override a built-in command | `user/overrides.zsh` (it loads after the aliases)                                              |
| Add a function              | A new file in `functions/`, then add `functions/<name>` to the `zsh_modules` array in `.zshrc` |
| Add a plugin                | A line in `.zsh_plugins.txt` (antidote format)                                                 |
| Machine-specific secrets    | `~/.zsh_secrets` (never committed)                                                             |

Use `reload` to apply changes without opening a new terminal.

::: tip
Messages from your own functions use the shared helpers `_ok`, `_err` and `_warn`
from `core/colors`, so new commands match the existing look.
:::

## Bash fallback

`.bashrc` mirrors the core aliases, history hygiene and paths, for shells where zsh
is not available.
