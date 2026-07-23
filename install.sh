#!/usr/bin/env bash
# Self-installing dotfiles bootstrap.
#
# Idempotent and cross-platform (macOS + any Linux, incl. dev containers).
# Prefers user-space installs (no root) via mise; only falls back to a system
# package manager for `stow` when it is missing.
#
# Usage:
#   ./install.sh                 # auto profile (adds `macos` on Darwin)
#   PROFILE="common nvim" ./install.sh
#   SKIP_NVIM=1 ./install.sh     # skip headless Neovim plugin/tool sync
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

# Default profile: common + nvim everywhere, plus macos on a Mac.
if [ -z "${PROFILE:-}" ]; then
  PROFILE="common nvim"
  [ "$OS" = "Darwin" ] && PROFILE="$PROFILE macos"
fi

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---------------------------------------------------------------------------
# 1. mise (user-space tool manager) + tools from dot-config/mise/config.toml
# ---------------------------------------------------------------------------
install_mise() {
  if have mise; then
    log "mise already installed"
  else
    log "installing mise (user-space)"
    curl -fsSL https://mise.run | sh
  fi
  export PATH="$HOME/.local/bin:$PATH"
  eval "$("$HOME/.local/bin/mise" activate bash)" 2>/dev/null || true

  log "installing tools from mise config"
  # Point mise at the tracked manifest even before it is stowed.
  MISE_CONFIG="$REPO_DIR/dotfiles/common/dot-config/mise/config.toml"
  if [ -f "$MISE_CONFIG" ]; then
    "$HOME/.local/bin/mise" install --yes -C "$(dirname "$MISE_CONFIG")"
  else
    "$HOME/.local/bin/mise" install --yes
  fi
}

# ---------------------------------------------------------------------------
# 2. zsh plugins (brew has them on macOS; clone on Linux/containers)
# ---------------------------------------------------------------------------
install_zsh_plugins() {
  local dest="$HOME/.local/share/zsh"
  mkdir -p "$dest"
  clone_or_pull() {
    local url="$1" dir="$2"
    if [ -d "$dir/.git" ]; then
      git -C "$dir" pull --ff-only --quiet || true
    else
      git clone --depth 1 --quiet "$url" "$dir"
    fi
  }
  log "ensuring zsh plugins"
  clone_or_pull https://github.com/zsh-users/zsh-autosuggestions \
    "$dest/zsh-autosuggestions"
  clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting \
    "$dest/zsh-syntax-highlighting"
}

# ---------------------------------------------------------------------------
# 3. stow (only tool we may need root for)
# ---------------------------------------------------------------------------
ensure_stow() {
  have stow && return 0
  log "installing stow"
  if have brew; then brew install stow
  elif have apt-get; then sudo apt-get update && sudo apt-get install -y stow
  elif have dnf; then sudo dnf install -y stow
  elif have apk; then sudo apk add stow
  else
    echo "ERROR: could not install stow automatically; install it manually." >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# 4. stow the selected profiles
# ---------------------------------------------------------------------------
stow_profiles() {
  log "stowing profiles: $PROFILE"
  cd "$REPO_DIR"
  # shellcheck disable=SC2086
  stow --restow $PROFILE
}

# ---------------------------------------------------------------------------
# 5. headless Neovim: sync LazyVim plugins + Mason tools
# ---------------------------------------------------------------------------
bootstrap_nvim() {
  [ -n "${SKIP_NVIM:-}" ] && { log "skipping nvim bootstrap"; return 0; }
  have nvim || { log "nvim not on PATH, skipping headless sync"; return 0; }
  log "syncing Neovim plugins (headless)"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
}

main() {
  install_mise
  install_zsh_plugins
  ensure_stow
  stow_profiles
  bootstrap_nvim
  log "done. Restart your shell (exec zsh) to pick up changes."
}

main "$@"
