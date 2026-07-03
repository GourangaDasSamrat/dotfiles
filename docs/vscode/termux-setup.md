# Visual Studio Code in Termux

This guide provides configuration and setup instructions for running VS Code on Termux with proper language server support.

## Branding Code-OSS as Visual Studio Code

To make Code-OSS appear as Visual Studio Code in Termux, edit the product configuration file at:

```
$PREFIX/lib/code-oss/resources/app/product.json
```

Add or update these configuration properties:

```json
{
  "nameShort": "Visual Studio Code",
  "nameLong": "Visual Studio Code",
  "applicationName": "code",
  "dataFolderName": ".vscode",

  "linuxIconName": "code",

  "urlProtocol": "vscode",

  "extensionsGallery": {
    "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
    "cacheUrl": "https://vscode.vo.msecnd.net/gallery",
    "itemUrl": "https://marketplace.visualstudio.com/items"
  },
  "linkProtectionTrustedDomains": [
    "https://open-vsx.org",
    "https://marketplace.visualstudio.com",
    "https://vscode.vo.msecnd.net"
  ]
}
```

## Language Server Setup for Termux

VS Code language servers in Termux may require symlink configuration to use system-installed binaries. Follow these steps for each language.

### Rust Language Server

1. Install the Rust analyzer package:

```bash
apt install rust-analyzer
```

2. Remove the broken bundled binary from the extension:

```bash
rm ~/.vscode/extensions/rust-lang.rust-analyzer-*/server/rust-analyzer
```

3. Create a symlink to the system binary:

```bash
ln -s $(which rust-analyzer) ~/.vscode/extensions/rust-lang.rust-analyzer-*/server/rust-analyzer
```

**Note**: Replace the wildcard `*` with the specific version number if the glob pattern doesn't work.

### Lua Language Server

1. Install the Lua language server package:

```bash
apt install lua-language-server
```

2. Remove the broken bundled binary from the extension:

```bash
rm ~/.vscode/extensions/sumneko.lua-*/server/bin/lua-language-server
```

3. Create a symlink to the system binary:

```bash
ln -s $(which lua-language-server) ~/.vscode/extensions/sumneko.lua-*/server/bin/lua-language-server
```

**Note**: Replace the wildcard `*` with the specific version number if the glob pattern doesn't work.

### CodeLLDB Debugger

1. Install the CodeLLDB package:

```bash
apt install codelldb
```

2. Remove the broken bundled binaries from the extension:

```bash
rm -rf ~/.vscode/extensions/vadimcn.vscode-lldb-*/adapter/codelldb ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb-server ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb-argdumper
```

3. Create symlinks to the system binaries:

```bash
ln -s $(which codelldb) ~/.vscode/extensions/vadimcn.vscode-lldb-*/adapter/codelldb
ln -s $(which lldb) ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb
ln -s $(which lldb-server) ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb-server
ln -s $(which lldb-argdumper) ~/.vscode/extensions/vadimcn.vscode-lldb-*/lldb/bin/lldb-argdumper
```

**Note**: Replace the wildcard `*` with the specific version number if the glob pattern doesn't work.

## Troubleshooting

If language servers or debuggers are not working after setup:

- Verify the symlinks exist: `ls -l ~/.vscode/extensions/[extension-name]*/server/` or `ls -l ~/.vscode/extensions/[extension-name]*/adapter/`
- Ensure symlink targets are executable: `file $(which codelldb)` or `file $(which lldb)`
- Reload VS Code or restart the language server/debugger from the command palette (`Ctrl+Shift+P`)
- Check VS Code's output panel for language server or debugger errors
