set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
        @just --list

# Run the automated installer.
install:
        @bash "{{justfile_directory()}}/scripts/install.sh"

# Run the interactive setup selector.
setup:
        @bash "{{justfile_directory()}}/scripts/setup.sh"

# Format Biome-supported files.
format-biome:
        fd -e js -e jsx -e ts -e tsx -e mjs -e cjs -e mts -e cts -e json -e jsonc -e css -e scss -e less \
                -X biome format --write

# Format files that Biome does not handle well.
format-prettier:
        fd -e md -e mdx -e yml -e yaml -e toml -e html -e htm \
                -X npx prettier --write

# Format shell scripts.
format-shell:
        fd -e sh -e bash -e zsh \
                -X shfmt -w

# Format the whole repository.
format: format-biome format-prettier format-shell
