# Shared ANSI palette + line formatters for the gh filters in this directory.
#
# Every filter pulls this in with (resolved relative to the filter file, so no
# `jq -L` flag is needed):
#
#   include "colors" {search: "./"};
#
# `purple` is the same shade as COLOR_HEADER in zsh/.config/zsh/core/colors.zsh.

def reset:  "\u001b[0m";
def purple: "\u001b[38;5;141m";  # headings, labels
def cyan:   "\u001b[38;5;117m";  # separators, secondary labels
def green:  "\u001b[38;5;84m";   # values

# "Label: value"
def kv($label; $value):
  "\(purple)\($label): \(green)\($value)\(reset)";

# "➜ owner/repo ➜ 12 commits"
def repo_row($repo; $count):
  "\(purple)➜ \($repo)\(reset) \(cyan)➜\(reset) \(green)\($count) commits\(reset)";

# Blank line, then "Some heading: value"
def total_line($text; $value):
  "\n\(purple)\($text)\(reset) \(green)\($value)\(reset)";
