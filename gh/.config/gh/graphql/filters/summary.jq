include "colors" {search: "./"};

.data.viewer.contributionsCollection as $c
| ($c.commitContributionsByRepository
    | sort_by(.contributions.totalCount) | reverse
    | .[]
    | repo_row(.repository.nameWithOwner; .contributions.totalCount)),
  total_line("Total Commits (\($label)):"; $c.totalCommitContributions)
