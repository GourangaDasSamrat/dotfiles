include "colors" {search: "./"};

group_by(.repository.fullName)
| map({repo: .[0].repository.fullName, count: length}) as $rows
| ($rows[] | repo_row(.repo; .count)),
  total_line("Total Commits \($label):"; $rows | map(.count) | add // 0)
