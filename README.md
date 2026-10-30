# dotfiles

WSL (Ubuntu 26.04) + Windows. Repo público: nada de chave, token ou IP aqui.

## Estrutura

| Caminho | Destino | Como aplicar |
| --- | --- | --- |
| `.zshrc`, `.tmux.conf`, `.config/`, `.claude/`, `.local/bin/` | `~` no WSL | `bash .dotfiles.sh` (symlinks) |
| `wsl/wsl.conf` | `/etc/wsl.conf` | `sudo cp wsl/wsl.conf /etc/wsl.conf` |
| `windows/.wslconfig` | `C:\Users\<user>\.wslconfig` | copiar |
| `.config/alacritty/alacritty.toml` | `%APPDATA%\alacritty\alacritty.toml` | copiar (Alacritty roda no Windows) |
| `windows/windows-terminal/settings.json` | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\` | copiar |
| `windows/vscode/settings.json` | `%APPDATA%\Code\User\` | copiar ou Settings Sync |
| `ssh/config.example` | `~/.ssh/config` | copiar e trocar `<OVH_SERVER_IP>` |
| `inventory/` | — | lista do que estava instalado |

`.dotfiles.sh` ignora `windows/`, `wsl/`, `ssh/`, `inventory/` e este README.

## Reinstalação

1. Windows: `winget import -i inventory\winget-apps.json --accept-package-agreements`
2. `wsl --install -d Ubuntu-26.04`, depois `sudo cp wsl/wsl.conf /etc/wsl.conf`
3. Restaurar `~/.ssh` e credenciais do backup offline
4. `bash setup-terminal.sh` (apt, oh-my-zsh, tmux, rust...) e `bash .dotfiles.sh`
5. Pacotes apt: `xargs -a inventory/apt-manual.txt sudo apt install -y`
6. Node via fnm (`inventory/node-versions.txt`) e globais de `inventory/npm-global.txt`
7. Extensões VS Code: `cat inventory/vscode-extensions-windows.txt | xargs -n1 code --install-extension`
