[.data.viewer.contributionsCollection.commitContributionsByRepository[].repository.languages.edges[]
  | {name: .node.name, size: .size}]
| group_by(.name)
| map({name: .[0].name, total: (map(.size) | add)})
| sort_by(.total) | reverse | .[:5]
| .[]
| "\u001b[38;5;141m➜ \(.name)\u001b[0m: \u001b[38;5;84m\(.total) bytes of code\u001b[0m"
