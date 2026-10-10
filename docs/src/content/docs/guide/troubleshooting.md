---
title: Troubleshooting & FAQ
---

Fixes for the problems that actually come up with this setup. Find the symptom,
run the fix.

## Pinentry never appears

**Symptoms:** `git commit` hangs or fails with `gpg: signing failed`, `pass`
waits forever, and no passphrase prompt shows up, even after restarting the
machine.

**Cause:** a stuck `gpg-agent` or `pinentry` process, or a stale lock file left
behind in `~/.gnupg`. Rebooting does not always clear the lock files, which is
why the prompt can stay missing.

**Fix:** kill every GPG and `pass` process, delete the lock files, then run any
command that needs your key so the agent starts fresh and asks for the
passphrase again:

```bash
pkill -9 -f gpg
pkill -9 -f pass
find ~/.gnupg/ -name "*lock*" -delete 2>/dev/null
pass git/push_pass
```

The last line is only there to trigger the prompt. Use any command that needs
`pass` or GPG, for example another `pass` entry, `gpg --decrypt <file>`, or a
signed commit.

:::tip
`pass git/push_pass` prints the passphrase on screen. To trigger the prompt
without showing it, send the output away: `pass git/push_pass > /dev/null`.
:::

:::caution
`pkill -9 -f pass` matches **any** process whose command line contains the text
`pass`, not only the `pass` command. Save your work first, or use the gentler
built-in alternative, which stops every GnuPG daemon cleanly:

```bash
gpgconf --kill all
```

:::

If the prompt still does not show, check that a `pinentry` program is installed
and configured. See [Secrets, pass & GPG](/guide/secrets/#1-create-a-gpg-key).

## Git

| Symptom                                               | Fix                                                                                                  |
| ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `git push` stops with `Could not retrieve passphrase` | The hook needs the `git/push_pass` entry: `pass insert git/push_pass`                                |
| Commit rejected by the `commit-msg` hook              | Use `type(scope): subject`. Valid types are listed in [Git Workflow](/git/workflow/#commit-messages) |
| `gpg: signing failed: Inappropriate ioctl for device` | `export GPG_TTY=$(tty)`. `.zshrc` already does this, so check you are not in a shell that skipped it |
| `gpg: signing failed: No secret key`                  | `user.signingkey` still points at the author's key. Override it in `~/.gitconfig.local`              |
| Pushes fail with `Permission denied (publickey)`      | Pushes go over SSH and use `~/.ssh/id_ed25519`. Create or copy that key and add it to GitHub         |
| You need to push once without the passphrase guard    | `git push --no-verify`                                                                               |

Identity and signing setup: [Git Workflow](/git/workflow/#identity-and-signing).

## Shell

| Symptom                                                       | Fix                                                                                                            |
| ------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `command not found: serve`, `expose`, `isup`, `inspect`, `yt` | These are defined only when their tools exist. Install `cloudflared`, `httpie`, `openssl`, or `mpv` + `yt-dlp` |
| `~/.zsh_secrets is not chmod 600`                             | `chmod 600 ~/.zsh_secrets`                                                                                     |
| First terminal start is slow                                  | Normal once. antidote is cloned to `~/.antidote` and the plugins are fetched, so it needs `git` and internet   |
| Plugins missing after an interrupted first start              | `rm -rf ~/.antidote`, then open a new terminal so it re-clones                                                 |
| Odd or missing tab completions                                | `rm -f ~/.cache/zsh/zcompdump*`, then open a new terminal                                                      |
| `rm` refuses to delete a path                                 | It is a protected system or home folder. Use `command rm` if you really mean it                                |
| Changed a config and nothing happened                         | Run `reload`, or open a new terminal                                                                           |
| `debian` alias fails on Termux                                | It hard-codes the user `gouranga`. Edit the alias in `user/aliases.zsh`                                        |

Full command list: [Shell Reference](/shell/reference/).

## Installation and Stow

| Symptom                                                          | Fix                                                                                                                                             |
| ---------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `Unsupported OS or package manager`                              | Only `pkg`, `brew`, `dnf`, `apt` and `pacman` are detected                                                                                      |
| `install.sh` stops partway                                       | Run the steps one at a time with `./lib/*.sh`, or use `./setup.sh`. See [Getting Started](/guide/getting-started/#if-the-installer-stops-early) |
| Fonts step fails on Linux                                        | It needs `wget` and `7z` (`p7zip`). Install both and run `./lib/fonts.sh` again                                                                 |
| Stow reports `existing target is neither a link nor a directory` | A real file is in the way. Move it aside and re-run `stow`. See [GNU Stow](/guide/stow/#fixing-conflicts)                                       |
| Links point to the wrong place                                   | The repository is not at `~/dotfiles`. Move it there and run `stow -R <package>`                                                                |
| Git hooks do nothing                                             | They must be executable: `chmod +x ~/.git-hooks/*`                                                                                              |

## Docs site

| Symptom                              | Fix                                                                            |
| ------------------------------------ | ------------------------------------------------------------------------------ |
| Site shows a 404                     | GitHub **Settings → Pages → Source** must be set to **GitHub Actions**         |
| Page is unstyled or links are broken | `base` in `docs/astro.config.mjs` must match the repository name (`/dotfiles`) |
| Preview locally                      | `cd ~/dotfiles/docs && pnpm install && pnpm docs:dev`                          |

## FAQ

**Can I use these dotfiles without `pass` and GPG?**
Yes, but the `pre-push` hook then blocks every push. Either set up `pass` or use
`git push --no-verify`. Commits will also fail until `commit.gpgsign` or the
signing key is overridden in `~/.gitconfig.local`.

**Where do my machine-specific settings go?**
Secrets in `~/.zsh_secrets`, git identity in `~/.gitconfig.local`, and shell
changes in `user/overrides.zsh`. None of them are committed.

**How do I try one config without installing everything?**
Link a single package: `cd ~/dotfiles && stow helix`. Use `stow -nv <package>`
for a dry run first. See [GNU Stow](/guide/stow/).

**How do I update?**
`cd ~/dotfiles && git pull`. Configs are symlinks, so they update in place. See
[Getting Started](/guide/getting-started/#updating).

**Something is still broken.**
[Open an issue](https://github.com/GourangaDasSamrat/dotfiles/issues) with the
command you ran, the full error, and your OS.
