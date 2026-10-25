include "colors" {search: "./"};

sort_by(.commit.author.date)
| .[]
| "\(cyan)[\(.commit.author.date[11:16])]\(reset) \(purple)\(.repository.fullName)\(reset) ➜ \(green)\(.commit.message)\(reset)"
