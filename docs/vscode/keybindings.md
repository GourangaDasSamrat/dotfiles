# VS Code Custom Keybindings

This document outlines the custom keyboard shortcuts configured in VS Code. All bindings support both Linux/Windows (Ctrl-based) and macOS (Cmd-based) variants.

## Navigation

| Windows/Linux | macOS       | Command        | Description                             |
| ------------- | ----------- | -------------- | --------------------------------------- |
| `Ctrl+Alt+P`  | `Cmd+Opt+P` | Switch Profile | Switch between VS Code profiles         |
| `Alt+Left`    | `Opt+Left`  | Navigate Back  | Go back to the previous editor location |

## File & Folder Management

| Windows/Linux  | macOS         | Command    | Description                         |
| -------------- | ------------- | ---------- | ----------------------------------- |
| `Ctrl+N`       | `Cmd+N`       | New File   | Create a new file in the explorer   |
| `Ctrl+Shift+N` | `Cmd+Shift+N` | New Folder | Create a new folder in the explorer |

## Line Editing

| Windows/Linux | macOS   | Command                          | Description                                  |
| ------------- | ------- | -------------------------------- | -------------------------------------------- |
| `Ctrl+D`      | `Cmd+D` | Copy Line Down                   | Duplicate the current line downward          |
| `Ctrl+U`      | `Cmd+U` | Copy Line Up                     | Duplicate the current line upward            |
| `Alt+D`       | `Opt+D` | Add Selection to Next Find Match | Multi-select next occurrence of current word |

## Code Folding

| Windows/Linux | macOS   | Command    | Description                            |
| ------------- | ------- | ---------- | -------------------------------------- |
| `Alt+F`       | `Opt+F` | Fold All   | Collapse all code blocks in the editor |
| `Alt+O`       | `Opt+O` | Unfold All | Expand all code blocks in the editor   |

## Code Execution

| Windows/Linux  | macOS         | Command   | Description                                |
| -------------- | ------------- | --------- | ------------------------------------------ |
| `Ctrl+R`       | `Cmd+R`       | Run Code  | Execute the current file using Code Runner |
| `Ctrl+Shift+R` | `Cmd+Shift+R` | Stop Code | Stop the running code                      |

## Live Server

| Windows/Linux | macOS       | Command    | Description                           |
| ------------- | ----------- | ---------- | ------------------------------------- |
| `Ctrl+Alt+S`  | `Cmd+Opt+S` | Go Online  | Start Live Server for web development |
| `Ctrl+Alt+Q`  | `Cmd+Opt+Q` | Go Offline | Stop Live Server                      |

## Version Control

| Windows/Linux  | macOS         | Command        | Description                         |
| -------------- | ------------- | -------------- | ----------------------------------- |
| `Ctrl+Shift+G` | `Cmd+Shift+G` | Source Control | Open the Source Control (Git) panel |

## UI Toggle & Display

| Windows/Linux   | macOS         | Command                      | Description                                        |
| --------------- | ------------- | ---------------------------- | -------------------------------------------------- |
| `Ctrl+K`        | `Cmd+K`       | Toggle Status Bar Visibility | Show or hide the status bar                        |
| `Ctrl+K Ctrl+K` | `Cmd+K Cmd+K` | Toggle Multi-Cursor Modifier | Switch between Alt/Ctrl for multi-cursor selection |
| `Ctrl+Alt+B`    | `Cmd+Opt+B`   | Toggle Panel                 | Show or hide the bottom panel                      |
| `Alt+M`         | `Opt+M`       | Toggle Maximized Panel       | Maximize or restore the bottom panel               |
| `Alt+S`         | `Opt+S`       | Simple Browser               | Open the simple browser preview                    |

## File & Editor Operations

| Windows/Linux | macOS       | Command                     | Description                                |
| ------------- | ----------- | --------------------------- | ------------------------------------------ |
| `Ctrl+T`      | `Ctrl+T`    | New Untitled File           | Create a new untitled text file            |
| `Ctrl+Alt+T`  | `Cmd+Opt+T` | Open in Integrated Terminal | Open the current file's folder in terminal |
| `Ctrl+Alt+N`  | `Cmd+Opt+N` | Move Editor to New Window   | Move current editor to a new window        |

## Debugging & Diagnostics

| Windows/Linux | macOS | Command                  | Description                                     |
| ------------- | ----- | ------------------------ | ----------------------------------------------- |
| `F7`          | `F7`  | Previous Marker in Files | Jump to the previous error/warning across files |

## Development Tools

| Windows/Linux  | macOS         | Command             | Description                              |
| -------------- | ------------- | ------------------- | ---------------------------------------- |
| `F4`           | `F4`          | Open Native Console | Open the system's native terminal        |
| `Ctrl+Shift+I` | `Cmd+Shift+I` | Browser DevTools    | Toggle Developer Tools in browser editor |

## Font & Zoom

| Windows/Linux | macOS   | Command  | Description                   |
| ------------- | ------- | -------- | ----------------------------- |
| `Alt+=`       | `Opt+=` | Zoom In  | Increase the editor font size |
| `Alt+-`       | `Opt+-` | Zoom Out | Decrease the editor font size |

## Custom Views

| Windows/Linux  | macOS         | Command       | Description                    |
| -------------- | ------------- | ------------- | ------------------------------ |
| `Ctrl+Shift+A` | `Cmd+Shift+A` | Focus My View | Focus on custom view extension |

## Notes

- **Mac Modifier Keys**: `Cmd` = Command, `Opt` = Option
- **Linux/Windows**: Uses Ctrl and Alt combinations
- When a keybinding includes a space (e.g., `Ctrl+K Ctrl+K`), press the first combination, then the second
- Conditional bindings only work when certain conditions are met (e.g., `editorTextFocus`, `isMac`)
