include "colors" {search: "./"};

.data.viewer.contributionsCollection as $c
| kv("Commits"; $c.totalCommitContributions),
  kv("PRs"; $c.totalPullRequestContributions),
  kv("Issues"; $c.totalIssueContributions),
  kv("New Repos"; $c.totalRepositoryContributions),
  kv("Private"; $c.restrictedContributionsCount),
  "\n\(cyan)Total Contributions (\($label)): \(green)\($c.totalCommitContributions + $c.totalPullRequestContributions + $c.totalIssueContributions + $c.totalRepositoryContributions + $c.restrictedContributionsCount)\(reset)"
