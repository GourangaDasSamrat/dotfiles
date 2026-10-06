# GNU Stow

The dotfiles are installed as **symlinks** managed by
[GNU Stow](https://www.gnu.org/software/stow/). Editing a file in `~/dotfiles`
edits the live config, and `git pull` updates every machine.

## How it works

Each top-level folder in the repository is a **package**. Inside a package, the
folder structure mirrors your home directory, and Stow creates matching
symlinks.

```text
~/dotfiles/zsh/.config/zsh/.zshrc   →   ~/.config/zsh/.zshrc
~/dotfiles/git/.gitconfig           →   ~/.gitconfig
~/dotfiles/git/.git-hooks/          →   ~/.git-hooks/
```

Stow links into the **parent of the directory you run it from**. That is why the
repository has to live at `~/dotfiles`: run from there, the parent is `~`.

## Packages

| Package               | Links to                                                 | Default |
| --------------------- | -------------------------------------------------------- | :-----: |
| `zsh`                 | `~/.zshenv`, `~/.config/zsh/`, `~/.config/starship.toml` |   yes   |
| `bash`                | `~/.bashrc`                                              |   yes   |
| `git`                 | `~/.gitconfig`, `~/.git-hooks/`                          |   yes   |
| `gh`                  | `~/.config/gh/` (GitHub CLI aliases, queries, scripts)   |   yes   |
| `kitty`               | `~/.config/kitty/`                                       |   yes   |
| `cspell`              | `~/.config/cspell/` (shared dictionaries)                |   yes   |
| `vscode/vscode-linux` | `~/.config/Code/User/` (settings, keybindings, snippets) |   yes   |
| `vscode/vscode-mac`   | `~/Library/Application Support/Code/User/`               |   yes   |
| `helix`               | `~/.config/helix/`                                       |   no    |
| `claude`              | `~/.claude/` (settings, statusline, Dracula theme)       |   no    |
| `ghostty`             | `~/.config/ghostty/config.ghostty`                       |   no    |
| `rofi`                | `~/.config/rofi/config.rasi`                             |   no    |
| `usql`                | `~/.config/usql/config.yaml`                             |   no    |
| `mongosh`             | `~/.mongoshrc.js`                                        |   no    |
| `ytm-player`          | `~/.config/ytm-player/config.toml`                       |   no    |

"Default" means `install.sh` links it for you. Only the VS Code package matching
your OS is linked: `vscode-mac` on macOS, `vscode-linux` everywhere else.

## What the installer runs

`scripts/lib/dotfiles.sh` is equivalent to:

```bash
cd ~/dotfiles
stow zsh bash git gh kitty cspell

# VS Code lives one level deeper, so the stow directory is given explicitly
stow -d vscode -t ~ vscode-linux      # vscode-mac on macOS

chmod +x ~/.git-hooks/*
```

The last line matters: git ignores hooks that are not executable.

## Opt-in packages

Link whichever tools you use, from the repository root:

```bash
cd ~/dotfiles
stow helix claude ghostty rofi usql mongosh ytm-player
```

## Everyday commands

| Goal                        | Command          |
| --------------------------- | ---------------- |
| Link a package              | `stow helix`     |
| Preview without changing    | `stow -nv helix` |
| Re-link after adding files  | `stow -R helix`  |
| Remove a package's symlinks | `stow -D helix`  |

Run `stow -nv <package>` first when you are unsure; it prints what would be
linked and touches nothing.

## Fixing conflicts

If a real file already exists where Stow wants to put a link, it refuses:

```text
WARNING! stowing zsh would cause conflicts:
  * existing target is neither a link nor a directory: .zshenv
```

Stow never overwrites files. Move the old one out of the way and run it again:

```bash
mv ~/.zshenv ~/.zshenv.bak
stow zsh
```

If you want to keep what is already on the machine, copy it into the matching
package inside `~/dotfiles` first (or use `stow --adopt <package>` and review the
result with `git diff` before committing).

::: warning
`--adopt` pulls the existing file **into the repository**, replacing the repo's
version in your working tree. Always check `git diff` afterwards.
:::

## Adding a new package

1. Create the folder and mirror the home-directory path:

   ```bash
   mkdir -p ~/dotfiles/tmux/.config/tmux
   $EDITOR ~/dotfiles/tmux/.config/tmux/tmux.conf
   ```

2. Link it:

   ```bash
   cd ~/dotfiles && stow tmux
   ```

3. To make it part of the default install, add its name to the `packages` array
   in `scripts/lib/dotfiles.sh`.

4. Mention it in the README tool table and, if it needs setup steps, add a page
   under `docs/`.

::: tip
Dotfiles that must not be committed (tokens, personal paths) belong in
`~/.zsh_secrets` or `~/.gitconfig.local`, not in a package. See
[Secrets, pass & GPG](./secrets).
:::
