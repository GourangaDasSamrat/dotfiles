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
| "\u001b[38;5;141mCurrent Streak: \u001b[38;5;84m\(.current) days\u001b[0m\n\u001b[38;5;141mLongest Streak: \u001b[38;5;117m\(.longest) days\u001b[0m"
