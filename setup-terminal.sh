#!/usr/bin/env bash
# --- Paths -------------------------------------------------------
DOTFILES_REPO="https://github.com/uphiago/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"

# --- Packages ----------------------------------------------------
echo "Updating system…"
sudo apt update && pkcon refresh && pkcon update -y

echo "Installing essentials…"
sudo apt install -y \
  curl git zsh yq tmux fastfetch fzf ripgrep \
  build-essential unzip fonts-powerline

# --- Alacritty ---------------------------------------------------
echo "Checking Alacritty…"
[ ! -d alacritty ] && git clone https://github.com/alacritty/alacritty
pushd alacritty >/dev/null
cargo build --release || true
sudo cp target/release/alacritty /usr/local/bin 2>/dev/null || true
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg 2>/dev/null || true
sudo desktop-file-install extra/linux/Alacritty.desktop 2>/dev/null || true
sudo update-desktop-database 2>/dev/null || true
popd >/dev/null

# --- Rust --------------------------------------------------------
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust…"
  RUSTUP_INIT_SKIP_PATH_CHECK=yes curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  sudo apt install -y cargo
fi

# --- Oh-My-Zsh ---------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh-My-Zsh…"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- VS Code -----------------------------------------------------
if ! command -v code &>/dev/null; then
  echo "Installing VS Code…"
  sudo apt install -y software-properties-common apt-transport-https wget
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/ms.gpg >/dev/null
  echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ms.gpg] https://packages.microsoft.com/repos/code stable main" |
    sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update && sudo apt install -y code
fi

# --- Dotfiles ----------------------------------------------------
echo "Syncing dotfiles…"
[ ! -d "$DOTFILES_DIR" ] && git clone "$DOTFILES_REPO" "$DOTFILES_DIR"

mkdir -p "$HOME/.config/alacritty" "$HOME/.config/fastfetch"
ln -sf "$DOTFILES_DIR/.zshrc"                       "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.tmux.conf"                   "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
ln -sf "$DOTFILES_DIR/.config/fastfetch/config.jsonc"   "$HOME/.config/fastfetch/config.jsonc"

# --- Nerd Font ---------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  echo "Installing JetBrains Mono Nerd Font…"
  mkdir -p "$FONT_DIR"
  curl -Lo /tmp/JBMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -qo /tmp/JBMono.zip '*NerdFont-*.ttf' -d "$FONT_DIR"
  fc-cache -f "$FONT_DIR"
fi

# --- tmux plugins ------------------------------------------------
echo "Syncing tmux plugins…"

grep -oP "@plugin '\\K[^']+" ~/.tmux.conf | while read -r repo; do
  dir="$HOME/.tmux/plugins/$(basename "$repo")"
  [ -d "$dir/.git" ] && git -C "$dir" pull --quiet --depth=1 || \
  git clone --depth=1 "https://github.com/$repo" "$dir"
done

grep -q TMUX_PLUGIN_MANAGER_PATH ~/.tmux.conf || \
  echo 'set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"' >> ~/.tmux.conf

tmux start-server                              # ← ensure server exists
session=_tpm_boot
tmux has-session -t $session 2>/dev/null && tmux kill-session -t $session
tmux new-session -d -s $session \
  "tmux source-file ~/.tmux.conf; \
   $HOME/.tmux/plugins/tpm/bin/install_plugins; \
   tmux wait-for -S tpm-done"
tmux wait-for tpm-done
tmux kill-session -t $session 2>/dev/null

# --- Oh-My-Zsh plugins ------------------------------------------
echo "Syncing Zsh plugins…"
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
for url in \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  https://github.com/zsh-users/zsh-autosuggestions.git; do
  name=$(basename "$url" .git)
  [ ! -d "$ZSH_CUSTOM/plugins/$name" ] && git clone --depth=1 "$url" "$ZSH_CUSTOM/plugins/$name"
done

# --- Run dotfiles helper ----------------------------------------
[ -x "$DOTFILES_DIR/.dotfiles.sh" ] && bash "$DOTFILES_DIR/.dotfiles.sh"

# --- Reload Zsh if running --------------------------------------
[ -n "$ZSH_VERSION" ] && source ~/.zshrc

echo "Setup finished ✓"
