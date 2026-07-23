.data.viewer.contributionsCollection as $c
| "\u001b[38;5;141mCommits: \u001b[38;5;84m\($c.totalCommitContributions)\u001b[0m",
  "\u001b[38;5;141mPRs: \u001b[38;5;84m\($c.totalPullRequestContributions)\u001b[0m",
  "\u001b[38;5;141mIssues: \u001b[38;5;84m\($c.totalIssueContributions)\u001b[0m",
  "\u001b[38;5;141mNew Repos: \u001b[38;5;84m\($c.totalRepositoryContributions)\u001b[0m",
  "\u001b[38;5;141mPrivate: \u001b[38;5;84m\($c.restrictedContributionsCount)\u001b[0m",
  "\n\u001b[38;5;117mTotal Contributions (\($label)): \u001b[38;5;84m\($c.totalCommitContributions + $c.totalPullRequestContributions + $c.totalIssueContributions + $c.totalRepositoryContributions + $c.restrictedContributionsCount)\u001b[0m"
