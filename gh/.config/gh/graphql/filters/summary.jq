.data.viewer.contributionsCollection as $c
| ($c.commitContributionsByRepository
    | sort_by(.contributions.totalCount) | reverse
    | .[]
    | "\u001b[38;5;141m➜ \(.repository.nameWithOwner)\u001b[0m \u001b[38;5;117m➜\u001b[0m \u001b[38;5;84m\(.contributions.totalCount) commits\u001b[0m"),
  "\n\u001b[38;5;141mTotal Commits (\($label)):\u001b[0m \u001b[38;5;84m\($c.totalCommitContributions)\u001b[0m"
