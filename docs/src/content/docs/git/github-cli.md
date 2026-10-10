---
title: GitHub CLI
---

The `gh` package adds aliases for contribution stats, streaks and language
insights, plus a few pull-request shortcuts. It is linked to `~/.config/gh/` by
the default install, and needs `gh auth login` first.

## Present

```bash
gh today                # Every commit with timestamps since midnight (all repos)
gh today-summary        # Repo-wise summary + total commit count for today
gh today-stats          # Full profile-style contributions for today
gh this-month-summary   # Accurate monthly report (handles 1000+ commits)
gh this-month-stats     # Full profile-style contributions for this month
gh this-year-summary    # Total commits this year (handles 1200+ accurately)
gh this-year-stats      # Full profile-style contributions for this year
gh this-year-languages  # Top 5 languages used this year (by bytes)
gh streak               # Calculate your current and longest commit streak
```

## Past

```bash
gh yesterday            # Every commit with timestamps from yesterday (all repos)
gh yesterday-summary    # Repo-wise summary + total commit count for yesterday
gh yesterday-stats      # Full profile-style contributions for yesterday
gh last-month-summary   # Accurate monthly report for previous month
gh last-month-stats     # Full profile-style contributions for last month
gh last-year-summary    # Full contribution summary for the previous year
gh last-year-stats      # Full profile-style contributions for last year
gh last-year-languages  # Top 5 languages used in the previous year
```

## Utilities

```bash
gh prs                  # Your PRs in the current repo with status
gh open                 # Open the current repo in your default browser
gh co                   # Interactive PR checkout
```

For plain git aliases (`git lg`, `git today`, ...) see [Git Workflow](/git/workflow/#aliases).
