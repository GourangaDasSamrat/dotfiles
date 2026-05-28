# VS Code Settings Configuration

This document describes the custom VS Code settings configuration. These settings cover font configuration, editor behavior, language-specific tools, and extension configurations.

## Font Configuration

### Primary Fonts

| Setting                           | Fonts                                                               | Purpose                                |
| --------------------------------- | ------------------------------------------------------------------- | -------------------------------------- |
| `editor.fontFamily`               | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | Main editor font with ligature support |
| `terminal.integrated.fontFamily`  | JetBrainsMono Nerd Font, FiraCode Nerd Font Mono                    | Terminal font with Nerd Font icons     |
| `editor.inlineSuggest.fontFamily` | Cartograph CF, MonoLisa, JetBrainsMono Nerd Font                    | Inline suggestions display font        |
| `editor.inlayHints.fontFamily`    | Cartograph CF, MonoLisa, JetBrainsMono Nerd Font                    | Type hints and inlay hints font        |
| `editor.codeLensFontFamily`       | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | Code lens references font              |
| `debug.console.fontFamily`        | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | Debug console output font              |
| `scm.inputFontFamily`             | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | Git commit input font                  |
| `errorLens.fontFamily`            | Cartograph CF, Operator Mono Lig, MonoLisa, JetBrainsMono Nerd Font | Error Lens inline error display        |
| `gitlens.currentLine.fontFamily`  | Cartograph CF, MonoLisa, JetBrainsMono Nerd Font                    | GitLens current line blame             |
| `gitlens.blame.fontFamily`        | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | GitLens blame annotation font          |
| `markdown.preview.fontFamily`     | Founders Grotesk, MonoLisa, system fonts                            | Markdown preview font                  |
| `chat.editor.fontFamily`          | Operator Mono Lig, Cartograph CF, MonoLisa, JetBrainsMono Nerd Font | Chat editor font                       |
| `chat.fontFamily`                 | Cartograph CF, MonoLisa, JetBrainsMono Nerd Font                    | Chat interface font                    |

### Font Styling

**TextMate Rules** - The following elements are rendered in italic:

- Comments (line, block)
- Keywords (operator, control, other)
- Storage (type, modifier)
- Attributes and meta tags
- Imports, exports, modules, decorators
- Language variables

**Semantic Token Customizations:**

- `variable.readonly` → Italic
- `parameter` → Italic
- `property` → Italic
- `function` → Bold
- `method` → Bold

### Font Ligatures

| Setting                                             | Value       | Description                   |
| --------------------------------------------------- | ----------- | ----------------------------- |
| `editor.fontLigatures`                              | `true`      | Enable ligatures in editor    |
| `terminal.integrated.fontLigatures.enabled`         | `true`      | Enable ligatures in terminal  |
| `terminal.integrated.fontLigatures.featureSettings` | `"calt" on` | Contextual alternates feature |

**Custom Fallback Ligatures:** Extensive list of programming ligatures including arrows (`<->`, `-->`, `=>`), equality operators (`==`, `!=`, `===`), and special symbols (`::`, `<*>`, `|>`), among others.

---

## Editor UI Configuration

### Editor Display

| Setting                                                             | Value  | Description                       |
| ------------------------------------------------------------------- | ------ | --------------------------------- |
| `editor.fontSize`                                                   | `22`   | Editor font size in pixels        |
| `editor.wordWrap`                                                   | `on`   | Enable word wrapping              |
| `editor.guides.bracketPairs`                                        | `true` | Show bracket pair guides          |
| `editor.bracketPairColorization.enabled`                            | `true` | Colorize bracket pairs            |
| `editor.bracketPairColorization.independentColorPoolPerBracketType` | `true` | Different colors per bracket type |
| `editor.mouseWheelZoom`                                             | `true` | Zoom with mouse wheel             |
| `editor.accessibilitySupport`                                       | `off`  | Disable accessibility mode        |
| `editor.hover.delay`                                                | `250`  | Delay before hover tooltip (ms)   |
| `editor.autoIndentOnPaste`                                          | `true` | Auto-indent pasted content        |
| `editor.stickyScroll.enabled`                                       | `true` | Sticky scroll for context         |
| `editor.smoothScrolling`                                            | `true` | Smooth scrolling animation        |

### Cursor Configuration

| Setting                              | Value    | Description                                |
| ------------------------------------ | -------- | ------------------------------------------ |
| `editor.cursorBlinking`              | `smooth` | Smooth cursor blinking animation           |
| `editor.cursorWidth`                 | `5`      | Cursor width in pixels                     |
| `editor.cursorSurroundingLines`      | `8`      | Lines visible around cursor when scrolling |
| `editor.cursorSurroundingLinesStyle` | `all`    | Always show surrounding lines              |

### Breadcrumbs & Minimap

| Setting                           | Value       | Description                          |
| --------------------------------- | ----------- | ------------------------------------ |
| `breadcrumbs.filePath`            | `last`      | Show last component of file path     |
| `editor.minimap.autohide`         | `mouseover` | Hide minimap until hover             |
| `editor.minimap.scale`            | `2`         | Minimap character scale              |
| `editor.minimap.size`             | `fill`      | Minimap fills available space        |
| `editor.minimap.renderCharacters` | `false`     | Minimap shows blocks instead of text |

---

## Window & Workbench UI

### Window Configuration

| Setting                         | Value                                                              | Description                     |
| ------------------------------- | ------------------------------------------------------------------ | ------------------------------- |
| `window.title`                  | `${dirty}${activeEditorShort}${separator}${appName} with Gouranga` | Custom window title template    |
| `window.titleBarStyle`          | `custom`                                                           | Use custom title bar            |
| `window.confirmBeforeClose`     | `always`                                                           | Always confirm before closing   |
| `window.commandCenter`          | `false`                                                            | Disable command center          |
| `window.newWindowProfile`       | `Default`                                                          | Default profile for new windows |
| `window.menuBarVisibility`      | `toggle`                                                           | Toggle menu bar visibility      |
| `window.enableMenuBarMnemonics` | `false`                                                            | Disable Alt key menu mnemonics  |

### Workbench Layout

| Setting                                                   | Value      | Description                      |
| --------------------------------------------------------- | ---------- | -------------------------------- |
| `workbench.sideBar.location`                              | `right`    | Sidebar on right side            |
| `workbench.activityBar.location`                          | `top`      | Activity bar at top              |
| `workbench.panel.defaultLocation`                         | `left`     | Panel on left side               |
| `workbench.tree.indent`                                   | `20`       | Tree indentation in pixels       |
| `workbench.editor.doubleClickTabToToggleEditorGroupSizes` | `maximize` | Double-click tab to maximize     |
| `workbench.startupEditor`                                 | `none`     | Don't open any editor on startup |
| `workbench.panel.showLabels`                              | `false`    | Hide panel labels                |
| `workbench.editor.empty.hint`                             | `hidden`   | Hide empty editor hints          |
| `workbench.externalBrowser`                               | `firefox`  | Use Firefox as external browser  |
| `workbench.browser.pageZoom`                              | `100%`     | Browser page zoom level          |

### Color Customizations

```json
"workbench.colorCustomizations": {
  "editorCursor.foreground": "#e0ffeb",      // Light green cursor
  "editorLineNumber.foreground": "#5c6370",  // Dark gray line numbers
  "editorLineNumber.activeForeground": "#ffffff"  // White active line number
}
```

---

## Terminal Configuration

| Setting                                   | Value            | Description                    |
| ----------------------------------------- | ---------------- | ------------------------------ |
| `terminal.external.linuxExec`             | `xfce4-terminal` | External terminal on Linux     |
| `terminal.integrated.fontSize`            | `15`             | Terminal font size             |
| `terminal.integrated.mouseWheelZoom`      | `true`           | Zoom terminal with mouse wheel |
| `terminal.integrated.cursorBlinking`      | `true`           | Enable cursor blinking         |
| `terminal.integrated.cursorStyle`         | `line`           | Use line cursor style          |
| `terminal.integrated.smoothScrolling`     | `true`           | Smooth terminal scrolling      |
| `terminal.integrated.cursorStyleInactive` | `block`          | Block cursor when inactive     |

---

## IntelliSense & Suggestions

### Quick Suggestions

| Setting                             | Value     | Description                           |
| ----------------------------------- | --------- | ------------------------------------- |
| `editor.quickSuggestions`           | See below | Quick suggestion settings             |
| `editor.quickSuggestionsDelay`      | `5`       | Delay before showing suggestions (ms) |
| `editor.suggestOnTriggerCharacters` | `true`    | Suggest on trigger characters         |

**Quick Suggestions Details:**

```json
"editor.quickSuggestions": {
  "strings": "on",    // In strings
  "comments": "on",   // In comments
  "other": "on"       // Everywhere else
}
```

### Advanced Suggestions

| Setting                                    | Value  | Description                         |
| ------------------------------------------ | ------ | ----------------------------------- |
| `editor.inlineSuggest.edits.showCollapsed` | `true` | Show collapsed inline edits         |
| `editor.snippetSuggestions`                | `top`  | Show snippets at top of suggestions |
| `terminal.integrated.suggest.enabled`      | `true` | Enable terminal suggestions         |

**Terminal Quick Suggestions:**

```json
"terminal.integrated.suggest.quickSuggestions": {
  "commands": "on",
  "arguments": "on",
  "unknown": "on"
}
```

---

## Auto-Closing & Formatting

### Auto-Closing Features

| Setting                         | Value    | Description                        |
| ------------------------------- | -------- | ---------------------------------- |
| `editor.linkedEditing`          | `true`   | Rename paired tags automatically   |
| `editor.autoClosingBrackets`    | `always` | Always auto-close brackets         |
| `editor.autoClosingQuotes`      | `always` | Always auto-close quotes           |
| `editor.autoClosingOvertype`    | `always` | Always auto-close when typing over |
| `html.autoClosingTags`          | `true`   | Auto-close HTML tags               |
| `js/ts.autoClosingTags.enabled` | `true`   | Auto-close JS/TS JSX tags          |
| `editor.autoClosingComments`    | `always` | Always auto-close comments         |

### Formatting & Linting

| Setting                   | Value                    | Description                 |
| ------------------------- | ------------------------ | --------------------------- |
| `editor.formatOnSave`     | `true`                   | Format on save              |
| `editor.formatOnPaste`    | `true`                   | Format on paste             |
| `editor.defaultFormatter` | `esbenp.prettier-vscode` | Default formatter: Prettier |
| `eslint.run`              | `onSave`                 | Run ESLint on save          |
| `eslint.format.enable`    | `true`                   | Enable ESLint formatting    |

### Code Actions on Save

```json
"editor.codeActionsOnSave": {
  "source.fixAll.eslint": "explicit",      // Fix ESLint issues
  "source.organizeImports": "explicit"     // Organize imports
}
```

---

## Language-Specific Formatters

| Language   | Formatter        | Setting                                 |
| ---------- | ---------------- | --------------------------------------- |
| C++        | clangd           | `llvm-vs-code-extensions.vscode-clangd` |
| C          | clangd           | `llvm-vs-code-extensions.vscode-clangd` |
| Go         | goimports        | `golang.go`                             |
| Rust       | rust-analyzer    | `rust-lang.rust-analyzer`               |
| Python     | Ruff             | `charliermarsh.ruff`                    |
| Lua        | sumneko.lua      | `sumneko.lua`                           |
| Shell      | shfmt            | `mkhl.shfmt`                            |
| Toml       | Even Better TOML | `tamasfe.even-better-toml`              |
| Prisma     | Prisma           | `Prisma.prisma`                         |
| SQL/SQLite | Prettier SQL     | `inferrinizzard.prettier-sql-vscode`    |

---

## Prettier SQL Configuration

| Setting                               | Value        | Description                     |
| ------------------------------------- | ------------ | ------------------------------- |
| `Prettier-SQL.SQLFlavourOverride`     | `postgresql` | SQL dialect: PostgreSQL         |
| `Prettier-SQL.ignoreTabSettings`      | `false`      | Respect tab settings            |
| `Prettier-SQL.tabSizeOverride`        | `2`          | Tab size: 2 spaces              |
| `Prettier-SQL.insertSpacesOverride`   | `true`       | Use spaces, not tabs            |
| `Prettier-SQL.keywordCase`            | `upper`      | Keywords in UPPERCASE           |
| `Prettier-SQL.indentStyle`            | `standard`   | Standard indentation            |
| `Prettier-SQL.logicalOperatorNewline` | `before`     | Logical operators at line start |
| `Prettier-SQL.tabulateAlias`          | `false`      | Don't tabulate aliases          |
| `Prettier-SQL.commaPosition`          | `after`      | Comma after items               |
| `Prettier-SQL.expressionWidth`        | `50`         | Expression width limit          |
| `Prettier-SQL.linesBetweenQueries`    | `1`          | One line between queries        |
| `Prettier-SQL.denseOperators`         | `false`      | Spaces around operators         |
| `Prettier-SQL.newlineBeforeSemicolon` | `false`      | No newline before semicolon     |

---

## TypeScript & JavaScript

| Setting                                   | Value    | Description                      |
| ----------------------------------------- | -------- | -------------------------------- |
| `js/ts.updateImportsOnFileMove.enabled`   | `always` | Auto-update imports on file move |
| `js/ts.inlayHints.parameterNames.enabled` | `all`    | Show all parameter name hints    |
| `js/ts.preferences.quoteStyle`            | `double` | Prefer double quotes             |

---

## Go Configuration

### Basic Settings

| Setting                         | Value              | Description               |
| ------------------------------- | ------------------ | ------------------------- |
| `go.useLanguageServer`          | `true`             | Use gopls language server |
| `go.formatTool`                 | `goimports`        | Format tool: goimports    |
| `go.lintTool`                   | `golangci-lint-v2` | Linter: golangci-lint-v2  |
| `go.toolsManagement.autoUpdate` | `true`             | Auto-update Go tools      |
| `go.testFlags`                  | `["-v"]`           | Verbose test output       |
| `go.generateTestsFlags`         | `["-w", "-all"]`   | Generate all test methods |

### Inlay Hints

| Setting                               | Value  | Description                  |
| ------------------------------------- | ------ | ---------------------------- |
| `go.inlayHints.assignVariableTypes`   | `true` | Show variable types          |
| `go.inlayHints.parameterNames`        | `true` | Show parameter names         |
| `go.inlayHints.compositeLiteralTypes` | `true` | Show composite literal types |

### Gopls Configuration

```json
"gopls": {
  "ui.semanticTokens": true,              // Enable semantic tokens
  "ui.completion.usePlaceholders": true   // Use placeholders in completion
}
```

---

## Rust Configuration (rust-analyzer)

### Formatting

| Setting                                        | Value  | Description             |
| ---------------------------------------------- | ------ | ----------------------- |
| `rust-analyzer.rustfmt.rangeFormatting.enable` | `true` | Enable range formatting |

### Inlay Hints

| Setting                                                     | Value          | Description                      |
| ----------------------------------------------------------- | -------------- | -------------------------------- |
| `rust-analyzer.inlayHints.bindingModeHints.enable`          | `true`         | Binding mode hints               |
| `rust-analyzer.inlayHints.closureCaptureHints.enable`       | `true`         | Closure capture hints            |
| `rust-analyzer.inlayHints.closureReturnTypeHints.enable`    | `always`       | Always show closure return types |
| `rust-analyzer.inlayHints.discriminantHints.enable`         | `fieldless`    | Fieldless discriminant hints     |
| `rust-analyzer.inlayHints.expressionAdjustmentHints.enable` | `reborrow`     | Reborrow adjustment hints        |
| `rust-analyzer.inlayHints.implicitDrops.enable`             | `true`         | Show implicit drops              |
| `rust-analyzer.inlayHints.lifetimeElisionHints.enable`      | `skip_trivial` | Show non-trivial lifetime hints  |
| `rust-analyzer.inlayHints.rangeExclusiveHints.enable`       | `true`         | Range exclusive hints            |

### Code Lens

| Setting                                            | Value  | Description                  |
| -------------------------------------------------- | ------ | ---------------------------- |
| `rust-analyzer.lens.references.adt.enable`         | `true` | References for ADTs          |
| `rust-analyzer.lens.references.enumVariant.enable` | `true` | References for enum variants |
| `rust-analyzer.lens.references.method.enable`      | `true` | References for methods       |
| `rust-analyzer.lens.references.trait.enable`       | `true` | References for traits        |

### Diagnostics

| Setting                                         | Value  | Description                     |
| ----------------------------------------------- | ------ | ------------------------------- |
| `rust-analyzer.diagnostics.experimental.enable` | `true` | Enable experimental diagnostics |
| `rust-analyzer.diagnostics.styleLints.enable`   | `true` | Enable style lints              |

### Cargo & Checks

| Setting                                            | Value    | Description           |
| -------------------------------------------------- | -------- | --------------------- |
| `rust-analyzer.check.command`                      | `clippy` | Use Clippy for checks |
| `rust-analyzer.cargo.features`                     | `all`    | Check all features    |
| `rust-analyzer.cargo.buildScripts.enable`          | `true`   | Enable build scripts  |
| `rust-analyzer.cargo.buildScripts.useRustcWrapper` | `true`   | Use rustc wrapper     |

**Clippy Extra Args:**

```json
"--",
"-W", "clippy::pedantic",
"-W", "clippy::nursery",
"-A", "clippy::missing_docs_in_private_items"
```

### Proc Macros & Completion

| Setting                                                  | Value  | Description                   |
| -------------------------------------------------------- | ------ | ----------------------------- |
| `rust-analyzer.procMacro.enable`                         | `true` | Enable procedural macros      |
| `rust-analyzer.procMacro.attributes.enable`              | `true` | Enable macro attributes       |
| `rust-analyzer.completion.autoimport.enable`             | `true` | Auto-import on completion     |
| `rust-analyzer.completion.autoself.enable`               | `true` | Auto-add self on completion   |
| `rust-analyzer.completion.fullFunctionSignatures.enable` | `true` | Show full function signatures |

### Semantic Highlighting

| Setting                                                                | Value  | Description                          |
| ---------------------------------------------------------------------- | ------ | ------------------------------------ |
| `rust-analyzer.semanticHighlighting.operator.enable`                   | `true` | Highlight operators                  |
| `rust-analyzer.semanticHighlighting.operator.specialization.enable`    | `true` | Specialized operator highlighting    |
| `rust-analyzer.semanticHighlighting.punctuation.enable`                | `true` | Highlight punctuation                |
| `rust-analyzer.semanticHighlighting.punctuation.specialization.enable` | `true` | Specialized punctuation highlighting |

---

## C/C++ Configuration (clangd)

| Setting                  | Value     | Description              |
| ------------------------ | --------- | ------------------------ |
| `clangd.onConfigChanged` | `restart` | Restart on config change |

**Clangd Arguments:**

```json
"--background-index",              // Index in background
"--clang-tidy",                    // Enable clang-tidy
"--completion-style=detailed",     // Detailed completions
"--header-insertion=iwyu",         // IWYU header insertion
"--header-insertion-decorators",   // Add decorators
"--all-scopes-completion",         // Complete from all scopes
"--function-arg-placeholders",     // Function argument placeholders
"--log=error",                     // Log errors only
"--pretty",                        // Pretty output
"--fallback-style=Google",         // Google C++ style fallback
"--pch-storage=memory",            // Store PCH in memory
"--limit-results=0"                // Unlimited results
```

---

## Markdown Configuration

| Setting                                 | Value  | Description           |
| --------------------------------------- | ------ | --------------------- |
| `markdown.validate.enabled`             | `true` | Validate markdown     |
| `markdown.occurrencesHighlight.enabled` | `true` | Highlight occurrences |

---

## File Management

### Auto-Save

| Setting                        | Value        | Description                        |
| ------------------------------ | ------------ | ---------------------------------- |
| `files.autoSave`               | `afterDelay` | Auto-save after delay              |
| `files.autoSaveDelay`          | `1000`       | Auto-save delay (ms)               |
| `files.trimTrailingWhitespace` | `true`       | Remove trailing whitespace on save |
| `files.trimFinalNewlines`      | `true`       | Remove final newlines on save      |

### File Exclusions

**Excluded from view:**

```json
"files.exclude": {
  "**/node_modules": true,
  "**/.next": true,
  "**/.git": true,
  "**/target": true
}
```

**Excluded from file watching:**

- `**/node_modules/**`
- `**/.git/objects/**`, `**/.git/subtree-cache/**`
- `**/dist/**`, `**/.next/**`, `**/build/**`
- `**/.cache/**`, `**/coverage/**`, `**/.turbo/**`
- `**/out/**`, `**/*.o`, `**/*.a`, `**/*.so`
- `**/target`, `**/Cargo.lock` (Rust)
- `**/go.sum`

### File Associations

| Pattern     | Language | Description                  |
| ----------- | -------- | ---------------------------- |
| `*.h`       | c        | C header files               |
| `*.hpp`     | cpp      | C++ header files             |
| `*.tcc`     | cpp      | C++ template implementations |
| `*.ipp`     | cpp      | C++ inline implementations   |
| `*.myquery` | sql      | Custom SQL files             |
| `*.psql`    | sql      | PostgreSQL files             |
| `*.db`      | sqlite   | SQLite database files        |

---

## Search Configuration

| Setting            | Value  | Description                      |
| ------------------ | ------ | -------------------------------- |
| `search.smartCase` | `true` | Smart case-sensitivity in search |

**Excluded from search:**

```json
"search.exclude": {
  "**/node_modules": true,
  "**/dist": true,
  "**/build": true,
  "**/.next": true,
  "**/.git": true,
  "**/coverage": true,
  "**/.turbo": true,
  "**/yarn.lock": true,
  "**/package-lock.json": true,
  "**/pnpm-lock.yaml": true,
  "**/target": true
}
```

---

## Explorer Configuration

| Setting                   | Value   | Description            |
| ------------------------- | ------- | ---------------------- |
| `explorer.compactFolders` | `false` | Show all folder levels |

---

## Source Control (Git & GitLens)

### Git Configuration

| Setting                             | Value                                 | Description                  |
| ----------------------------------- | ------------------------------------- | ---------------------------- |
| `git.defaultCloneDirectory`         | `~/Developer/`                        | Default clone directory      |
| `git.openRepositoryInParentFolders` | `always`                              | Always check parent folders  |
| `git.enableSmartCommit`             | `true`                                | Smart commit enabled         |
| `git.autofetch`                     | `true`                                | Auto-fetch from remote       |
| `git.branchRandomName.enable`       | `true`                                | Generate random branch names |
| `git.branchRandomName.dictionary`   | `["adjectives", "animals", "colors"]` | Random name sources          |

### SCM (Source Control Management)

| Setting                          | Value    | Description                   |
| -------------------------------- | -------- | ----------------------------- |
| `scm.repositories.explorer`      | `true`   | Show repositories in explorer |
| `scm.repositories.selectionMode` | `single` | Single repository selection   |

### GitLens Configuration

| Setting                                 | Value     | Description                    |
| --------------------------------------- | --------- | ------------------------------ |
| `gitlens.defaultGravatarsStyle`         | `mp`      | Gravatar style: mystery person |
| `gitlens.hovers.currentLine.over`       | `line`    | Show blame on hover over line  |
| `gitlens.graph.layout`                  | `editor`  | Show graph in editor           |
| `gitlens.graph.minimap.additionalTypes` | See below | Additional graph types to show |

**Graph Minimap Types:**

- `localBranches` - Local branches
- `stashes` - Stashes
- `remoteBranches` - Remote branches
- `pullRequests` - Pull requests
- `tags` - Tags

### CommitSage Configuration

| Setting                           | Value                   | Description                         |
| --------------------------------- | ----------------------- | ----------------------------------- |
| `commitSage.provider.type`        | `gemini`                | AI provider: Google Gemini          |
| `commitSage.gemini.model`         | `gemini-2.5-flash-lite` | Model: Gemini 2.5 Flash Lite        |
| `commitSage.commit.commitFormat`  | `conventional`          | Commit format: Conventional Commits |
| `commitSage.commit.promptForRefs` | `true`                  | Prompt for commit references        |

---

## Extension Configuration

### General Extensions

| Setting                            | Value     | Description                         |
| ---------------------------------- | --------- | ----------------------------------- |
| `extensions.experimental.affinity` | See below | Run extensions in specific contexts |

**Extension Affinity (1 = separate context):**

- `eamodio.gitlens` - GitLens
- `dbaeumer.vscode-eslint` - ESLint
- `esbenp.prettier-vscode` - Prettier

### Tailwind CSS

| Setting                        | Value     | Description              |
| ------------------------------ | --------- | ------------------------ |
| `tailwindCSS.emmetCompletions` | `true`    | Enable Emmet completions |
| `tailwindCSS.files.exclude`    | See below | Exclude certain paths    |

**Tailwind Exclude Patterns:**

```json
"**/.git/**",
"**/node_modules/**",
"**/.hg/**",
"**/.svn/**",
"**/.next/**"
```

**Tailwind Language Includes:**

- `javascriptreact: "javascript"` - JSX files
- `typescriptreact: "typescript"` - TSX files

### CSpell (Spell Checker)

| Setting                                                  | Value    | Description                           |
| -------------------------------------------------------- | -------- | ------------------------------------- |
| `cSpell.caseSensitive`                                   | `true`   | Case-sensitive spelling               |
| `cSpell.blockCheckingWhenLineLengthGreaterThan`          | `100000` | Skip very long lines                  |
| `cSpell.hideAddToDictionaryCodeActions`                  | `true`   | Hide dictionary actions               |
| `cSpell.hideIssuesWhileTyping`                           | `Line`   | Hide issues while typing current line |
| `cSpell.advanced.feature.useReferenceProviderWithRename` | `true`   | Use reference provider on rename      |

**Custom Dictionaries:**

- `personal-names.txt` - Personal name dictionary
- `tech-tools.txt` - Technology and tools dictionary

Both located at `~/.config/cspell/` with auto-add enabled.

### Emmet

| Setting                  | Value     | Description                          |
| ------------------------ | --------- | ------------------------------------ |
| `emmet.includeLanguages` | See below | Enable Emmet in additional languages |

**Emmet Language Mappings:**

- `javascript` → `javascriptreact` (JSX)
- `typescript` → `typescriptreact` (TSX)
- `vue-html` → `html` (Vue templates)

### Live Server

| Setting                                | Value                 | Description                   |
| -------------------------------------- | --------------------- | ----------------------------- |
| `liveServer.settings.CustomBrowser`    | `firefox:PrivateMode` | Browser: Firefox Private Mode |
| `liveServer.settings.root`             | `/`                   | Root directory                |
| `liveServer.settings.donotShowInfoMsg` | `true`                | Hide info messages            |
| `liveServer.settings.donotVerifyTags`  | `true`                | Skip tag verification         |
| `liveServer.settings.wait`             | `10`                  | Wait 10ms before reload       |

### Error Lens

| Setting                             | Value  | Description                        |
| ----------------------------------- | ------ | ---------------------------------- |
| `errorLens.delay`                   | `0`    | No delay before showing errors     |
| `errorLens.enabledDiagnosticLevels` | All    | Show hints, errors, info, warnings |
| `errorLens.enableOnDiffView`        | `true` | Show in diff view                  |
| `errorLens.fontStyleItalic`         | `true` | Use italic font                    |

### Code Runner

| Setting                           | Value  | Description             |
| --------------------------------- | ------ | ----------------------- |
| `code-runner.saveFileBeforeRun`   | `true` | Save before running     |
| `code-runner.clearPreviousOutput` | `true` | Clear output on new run |

### Todo Tree

**Todo Tags:**

- `TODO` - General todo item
- `FIXME` - Needs fixing
- `BUG` - Bug report
- `HACK` - Hack or workaround
- `NOTE` - Important note
- `REVIEW` - Needs review
- `OPTIMIZE` - Performance optimization needed

**Todo Highlighting (all have custom colors, icons, and gutter icons):**

| Tag      | Foreground       | Background  | Icon   |
| -------- | ---------------- | ----------- | ------ |
| TODO     | Yellow (#f1fa8c) | Dark gray   | check  |
| FIXME    | Red (#ff5555)    | Dark gray   | flame  |
| BUG      | Red (#ff5555)    | Darker gray | bug    |
| HACK     | Orange (#ffb86c) | Dark gray   | tools  |
| NOTE     | Cyan (#8be9fd)   | Dark gray   | note   |
| REVIEW   | Purple (#bd93f9) | Dark gray   | eye    |
| OPTIMIZE | Green (#50fa7b)  | Dark gray   | rocket |

**Additional Settings:**

- `todo-tree.tree.scanMode` | `open files` - Scan only open files
- `todo-tree.general.showActivityBarBadge` | `false` - Hide activity bar badge
- `todo-tree.general.statusBar` | `none` - Don't show in status bar

### Diff Editor

| Setting                           | Value   | Description                 |
| --------------------------------- | ------- | --------------------------- |
| `diffEditor.codeLens`             | `true`  | Show code lens in diff view |
| `diffEditor.ignoreTrimWhitespace` | `false` | Include whitespace changes  |

---

## GitHub Copilot Configuration

| Setting                         | Value             | Description                    |
| ------------------------------- | ----------------- | ------------------------------ |
| `chat.viewSessions.orientation` | `stacked`         | Stack chat sessions vertically |
| `github.copilot.enable`         | Disabled for most | Copilot enabled selectively    |

**Copilot Disabled For:**

- `*` (all files)
- `plaintext`
- `markdown`
- `scminput` (Git messages)

---

## Telemetry & Updates

| Setting                        | Value    | Description                  |
| ------------------------------ | -------- | ---------------------------- |
| `telemetry.telemetryLevel`     | `off`    | Disable all telemetry        |
| `gitlens.telemetry.enabled`    | `false`  | Disable GitLens telemetry    |
| `commitSage.telemetry.enabled` | `false`  | Disable CommitSage telemetry |
| `update.mode`                  | `manual` | Manual update checking       |
| `update.showReleaseNotes`      | `false`  | Don't show release notes     |

---

## Theme & Icons

| Setting                                   | Value                 | Description                 |
| ----------------------------------------- | --------------------- | --------------------------- |
| `workbench.colorTheme`                    | `Dracula Theme`       | Color theme: Dracula        |
| `workbench.iconTheme`                     | `material-icon-theme` | Icon theme: Material Icons  |
| `material-icon-theme.activeIconPack`      | `react_redux`         | Icon pack: React Redux      |
| `material-icon-theme.hidesExplorerArrows` | `true`                | Hide explorer folder arrows |

---

## Security

| Setting                                   | Value  | Description                     |
| ----------------------------------------- | ------ | ------------------------------- |
| `security.workspace.trust.untrustedFiles` | `open` | Open untrusted files by default |

---

## Summary

This configuration emphasizes:

- **Professional Development**: Extensive language server and formatter support for multiple languages
- **Code Quality**: ESLint, Prettier, and language-specific linters
- **Developer Experience**: Smooth UI with custom fonts, ligatures, and extensive IntelliSense
- **Privacy**: Telemetry disabled across all extensions
- **Customization**: Language-specific settings and extensive extension configuration
- **Performance**: Optimized file watching and search exclusions for large projects
