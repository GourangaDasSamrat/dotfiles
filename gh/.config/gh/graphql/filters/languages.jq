include "colors" {search: "./"};

[.data.viewer.contributionsCollection.commitContributionsByRepository[].repository.languages.edges[]
  | {name: .node.name, size: .size}]
| group_by(.name)
| map({name: .[0].name, total: (map(.size) | add)})
| sort_by(.total) | reverse | .[:5]
| .[]
| "\(purple)➜ \(.name)\(reset): \(green)\(.total) bytes of code\(reset)"
