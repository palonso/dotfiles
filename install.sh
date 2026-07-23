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
# 0. Preflight: heal XDG dirs left as symlinks by a previous stow run.
# The old flat layout let stow tree-fold whole dirs (e.g. ~/.local) into a
# single directory symlink; after moving the repo those dangle and break mise.
# Replace any symlinked XDG dir with a real directory so tools can write there
# and `stow --no-folding` can manage individual files.
# ---------------------------------------------------------------------------
preflight() {
  # Remove dangling top-level symlinks in $HOME left by an old dotfiles stow
  # (e.g. ~/.zshrc, ~/.config, ~/.local pointing at a previous repo path).
  local link target
  while IFS= read -r link; do
    target="$(readlink "$link")"
    case "$target" in
      *dotfiles*) log "removing dangling $link"; rm "$link" ;;
    esac
  done < <(find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print)

  # Ensure XDG dirs exist as real directories so tools (mise) can write there
  # and `stow --no-folding` can manage individual files inside them.
  local d
  for d in "$HOME/.config" "$HOME/.local" "$HOME/.local/bin" \
           "$HOME/.local/share" "$HOME/.local/state"; do
    if [ -L "$d" ]; then
      log "replacing symlinked $d with a real directory"
      rm "$d"
    fi
    mkdir -p "$d"
  done
}

# ---------------------------------------------------------------------------
# 1. mise (user-space tool manager) + tools from dot-config/mise/config.toml
# ---------------------------------------------------------------------------
MISE_BIN=""

# Locate the mise binary wherever it landed (brew, the mise.run installer, or
# an already-configured PATH). We do NOT assume ~/.local/bin exists.
find_mise() {
  if have mise; then command -v mise; return 0; fi
  local c
  for c in \
    "$HOME/.local/bin/mise" \
    /opt/homebrew/bin/mise \
    /usr/local/bin/mise \
    "${XDG_DATA_HOME:-$HOME/.local/share}/mise/bin/mise"; do
    [ -x "$c" ] && { echo "$c"; return 0; }
  done
  return 1
}

install_mise() {
  if have mise || find_mise >/dev/null; then
    log "mise already installed"
  else
    log "installing mise"
    if [ "$OS" = "Darwin" ] && have brew; then
      brew install mise
    else
      # The mise.run installer defaults to ~/.local/bin and creates it.
      curl -fsSL https://mise.run | sh
    fi
  fi

  MISE_BIN="$(find_mise)" || {
    echo "ERROR: mise installed but its binary could not be located." >&2
    exit 1
  }
  export PATH="$(dirname "$MISE_BIN"):$PATH"
  eval "$("$MISE_BIN" activate bash)" 2>/dev/null || true

  log "installing tools from mise config"
  # Point mise at the tracked manifest even before it is stowed.
  MISE_CONFIG="$REPO_DIR/dotfiles/common/dot-config/mise/config.toml"
  if [ -f "$MISE_CONFIG" ]; then
    "$MISE_BIN" install --yes -C "$(dirname "$MISE_CONFIG")"
  else
    "$MISE_BIN" install --yes
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
  # --no-folding: keep ~/.config and ~/.local as real dirs and symlink only
  # leaf files, so other tools (mise, etc.) can share those directories.
  # shellcheck disable=SC2086
  stow --no-folding --restow $PROFILE
}

# ---------------------------------------------------------------------------
# 5. headless Neovim: sync LazyVim plugins + Mason tools
# ---------------------------------------------------------------------------
bootstrap_nvim() {
  [ -n "${SKIP_NVIM:-}" ] && { log "skipping nvim bootstrap"; return 0; }
  # Prefer running nvim through mise so its managed version is used even if the
  # shims dir isn't on PATH yet in this non-interactive shell.
  local nvim_cmd=""
  if [ -n "$MISE_BIN" ] && "$MISE_BIN" which nvim >/dev/null 2>&1; then
    nvim_cmd="$MISE_BIN exec -- nvim"
  elif have nvim; then
    nvim_cmd="nvim"
  else
    log "nvim not available, skipping headless sync"
    return 0
  fi
  log "syncing Neovim plugins (headless)"
  $nvim_cmd --headless "+Lazy! sync" +qa 2>/dev/null || true
}

main() {
  preflight
  install_mise
  install_zsh_plugins
  ensure_stow
  stow_profiles
  bootstrap_nvim
  log "done. Restart your shell (exec zsh) to pick up changes."
}

main "$@"
