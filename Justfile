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
	find . \
		-type f \
		\( \
			-name '*.js' -o \
			-name '*.jsx' -o \
			-name '*.ts' -o \
			-name '*.tsx' -o \
			-name '*.mjs' -o \
			-name '*.cjs' -o \
			-name '*.mts' -o \
			-name '*.cts' -o \
			-name '*.json' -o \
			-name '*.jsonc' -o \
			-name '*.css' -o \
			-name '*.scss' -o \
			-name '*.less' \
		\) \
		! -path './.git/*' \
		-exec biome format --write {} +

# Format files that Biome does not handle well.
format-prettier:
	find . \
		-type f \
		\( \
			-name '*.md' -o \
			-name '*.mdx' -o \
			-name '*.yml' -o \
			-name '*.yaml' -o \
			-name '*.toml' -o \
			-name '*.html' -o \
			-name '*.htm' \
		\) \
		! -path './.git/*' \
		-exec npx prettier --write {} +

# Format shell scripts.
format-shell:
	find . \
		-type f \
		\( \
			-name '*.sh' -o \
			-name '*.bash' \
		\) \
		! -path './.git/*' \
		-exec shfmt -w {} +

# Format the whole repository.
format: format-biome format-prettier format-shell
