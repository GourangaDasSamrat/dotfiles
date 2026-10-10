---
title: Git Workflow
---

The git setup enforces conventional commits, signs every commit, and puts a
passphrase guard in front of `git push`. The config is `git/.gitconfig` and the
hooks are in `git/.git-hooks/`, both linked by [GNU Stow](/guide/stow/).

Hooks are installed globally through `core.hooksPath = ~/.git-hooks`, so they run
in **every** repository on the machine, not just this one.

## Commit messages

The `commit-msg` hook checks the first line of every commit message against the
[Conventional Commits](https://www.conventionalcommits.org) format:

```text
<type>(<scope>): <subject>
```

The scope is optional, and the subject must not be empty.

| Type       | Use it for                                 |
| ---------- | ------------------------------------------ |
| `feat`     | A new feature                              |
| `fix`      | A bug fix                                  |
| `docs`     | Documentation changes                      |
| `style`    | Formatting, whitespace, missing semicolons |
| `refactor` | Restructuring without changing behaviour   |
| `test`     | Adding or updating tests                   |
| `chore`    | Maintenance tasks                          |
| `perf`     | Performance improvements                   |
| `ci`       | CI/CD changes                              |
| `build`    | Build system changes                       |
| `revert`   | Reverting a previous commit                |

```text
feat(auth): add login functionality
fix: resolve memory leak in parser
docs(readme): update installation instructions
```

A message that does not match is rejected with the list above and the commit is
aborted. Only the first line is checked; the body can say anything.

What else the hook does:

- **Tidies bullet points** — leading spaces before `-`, `*` or `+` at the start of
  a line are removed, so the log stays aligned.
- **Warns on long headers** — over 72 characters prints a warning but does not
  block the commit.
- **Skips merge and revert commits** — messages starting with `Merge ` or
  `Revert ` are accepted as they are.

This is also what feeds the changelog: releases are generated from these commit
types by [git-cliff](https://git-cliff.org).

## Pre-push guard

The `pre-push` hook asks for a passphrase before anything leaves your machine,
so an accidental `git push` cannot go through unnoticed.

```text
$ git push
Enter Passphrase:
Verification Successful. Proceeding with push.
```

It works by reading the expected value from `pass git/push_pass` and comparing it
with what you type (input is hidden). It aborts when:

- `pass` is not installed,
- the `git/push_pass` entry is missing or empty, or
- the typed passphrase does not match.

Create the entry once per machine — see [Secrets, pass & GPG](/guide/secrets/#3-store-the-push-passphrase).

:::tip
This is a safety latch against mistakes, not an access control. Skip it for a
single push with `git push --no-verify`.
:::

## Identity and signing

Commits are GPG-signed by default (`commit.gpgsign = true`). The shipped config
contains the author's name, email and key ID, so on your own machine override them
in `~/.gitconfig.local`. That file is included at the end of `.gitconfig`, which
makes its values win:

```ini
[user]
  name = Your Name
  email = you@example.com
  signingkey = YOUR_KEY_ID
```

Setting up the key is covered in [Secrets, pass & GPG](/guide/secrets/#1-create-a-gpg-key).

## Remotes

```ini
[url "git@github.com:"]
  pushInsteadOf = "https://github.com/"
```

Clone and fetch over HTTPS, push over SSH. Paste any `https://github.com/...` URL
and pushes still go through your SSH key. The SSH command pins
`~/.ssh/id_ed25519` with `IdentitiesOnly=yes`, so create or copy that key first.

## Aliases

| Alias           | What it does                                                   |
| --------------- | -------------------------------------------------------------- |
| `git lg`        | Pretty graph log with hashes, refs, relative dates and authors |
| `git lga`       | The same graph across all branches                             |
| `git today`     | Commits since midnight, with times                             |
| `git yesterday` | Yesterday's commits                                            |
| `git lastmonth` | Commits from the past month                                    |
| `git monthstat` | Commit counts per author for the past month                    |
| `git mine`      | Graph log of your own commits only                             |
| `git last`      | Full details of the most recent commit                         |
| `git undo`      | Soft-reset the last commit, keeping your changes staged        |
| `git unstage`   | Unstage everything (`git reset HEAD --`)                       |
| `git gone`      | Delete local branches whose remote branch is gone              |
| `git el`        | Export the full log to `git_history.txt`                       |

:::caution
`git gone` runs `git fetch --prune` and then `git branch -D` on every branch
marked `gone`. That is a force delete — unmerged local work on those branches is
lost.
:::

The GitHub CLI config adds contribution stats on top of these (`gh today`,
`gh streak`, ...); see the GitHub CLI section of the README.

## Behaviour worth knowing

| Setting                                   | Effect                                                                               |
| ----------------------------------------- | ------------------------------------------------------------------------------------ |
| `pull.rebase = true`                      | `git pull` rebases instead of creating merge commits                                 |
| `rebase.autosquash`, `rebase.autostash`   | `fixup!` commits are squashed automatically; dirty trees are stashed around a rebase |
| `rerere.enabled`                          | Git remembers how you resolved a conflict and reuses it                              |
| `fetch.prune`, `fetch.pruneTags`          | Deleted remote branches and tags are cleaned up locally                              |
| `push.autoSetupRemote`, `push.followTags` | First push sets the upstream; annotated tags go with it                              |
| `branch.sort = -committerdate`            | `git branch` lists the most recently used branch first                               |
| `init.defaultBranch = main`               | New repositories start on `main`                                                     |
| `core.fsmonitor`, `core.untrackedCache`   | Faster `git status` in large repositories                                            |
| `maintenance.auto`                        | Background housekeeping runs automatically                                           |

## Diffs and paging

`delta` is the pager and the interactive diff filter, with the Dracula feature
set: side-by-side view, line numbers, `n`/`N` to jump between files, and
clickable hyperlinks. The editor is Helix (`hx`).

## Large files

Git LFS is wired in through the `filter "lfs"` section, so `git lfs track`
works once `git-lfs` is installed (it is in the default package list).

## Sending patches by email

See [Send Email](/git/send-email/) for the Gmail SMTP setup, which reads its password
from `pass app/gmail-smtp`.

## Bypassing the hooks

| Hook         | Skip with                | Prefer instead                                 |
| ------------ | ------------------------ | ---------------------------------------------- |
| `commit-msg` | `git commit --no-verify` | Fix the message; merges and reverts are exempt |
| `pre-push`   | `git push --no-verify`   | Enter the passphrase                           |
