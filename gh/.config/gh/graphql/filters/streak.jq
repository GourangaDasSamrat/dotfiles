include "colors" {search: "./"};

[.data.viewer.contributionsCollection.contributionCalendar.weeks[].contributionDays[]]
| reverse
| {current: 0, longest: 0, temp: 0, found_current: false} as $init
| reduce .[] as $day ($init;
    if $day.contributionCount > 0 then
      .temp += 1
      | (if .found_current == false then .current = .temp else . end)
      | (if .temp > .longest then .longest = .temp else . end)
    else
      (if .temp > 0 then .found_current = true end)
      | .temp = 0
    end)
| "\(purple)Current Streak: \(green)\(.current) days\(reset)\n\(purple)Longest Streak: \(cyan)\(.longest) days\(reset)"
