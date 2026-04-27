# Visual Studio Code in Termux

This guide provides configuration and setup instructions for running VS Code on Termux with proper language server support.

## Branding Code-OSS as Visual Studio Code

To make Code-OSS appear as Visual Studio Code in Termux, edit the product configuration file at:

```
/data/data/com.termux/files/usr/lib/code-oss/resources/app/product.json
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
ln -s /data/data/com.termux/files/usr/bin/rust-analyzer ~/.vscode/extensions/rust-lang.rust-analyzer-*/server/rust-analyzer
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
ln -s /data/data/com.termux/files/usr/bin/lua-language-server ~/.vscode/extensions/sumneko.lua-*/server/bin/lua-language-server
```

**Note**: Replace the wildcard `*` with the specific version number if the glob pattern doesn't work.

## Troubleshooting

If language servers are not working after setup:

- Verify the symlinks exist: `ls -l ~/.vscode/extensions/[extension-name]*/server/`
- Confirm the system binary is installed: `which rust-analyzer` or `which lua-language-server`
- Reload VS Code or restart the language server from the command palette (`Ctrl+Shift+P`)
- Check VS Code's output panel for language server errors
