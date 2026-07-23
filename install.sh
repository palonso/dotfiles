#!/usr/bin/env bash
# Self-installing dotfiles bootstrap.
#
# Idempotent and cross-platform (macOS + any Linux, incl. dev containers).
# User-space where possible (mise for tools); only `stow` may need root.
#
# Usage:
#   ./install.sh                       # auto profile (adds `macos` on a Mac)
#   PROFILE="common nvim" ./install.sh # explicit profiles
#   SKIP_NVIM=1 ./install.sh           # skip the headless Neovim sync
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

if [ -z "${PROFILE:-}" ]; then
  PROFILE="common nvim"
  [ "$OS" = "Darwin" ] && PROFILE="$PROFILE macos"
fi

# Make mise's usual install locations visible for the rest of the script.
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# Heal dangling symlinks left by a previous stow (e.g. from an old repo path),
# and make sure XDG dirs are real directories so mise and --no-folding stow can
# share them.
preflight() {
  while IFS= read -r link; do
    case "$(readlink "$link")" in
      *dotfiles*) log "removing dangling $link"; rm "$link" ;;
    esac
  done < <(find "$HOME" -maxdepth 1 -type l ! -exec test -e {} \; -print)

  for d in .config .local .local/bin .local/share .local/state; do
    [ -L "$HOME/$d" ] && rm "$HOME/$d"
    mkdir -p "$HOME/$d"
  done
}

# Install stow (the one thing that may need a system package manager).
ensure_stow() {
  have stow && return 0
  log "installing stow"
  if   have brew;    then brew install stow
  elif have apt-get; then sudo apt-get update && sudo apt-get install -y stow
  elif have dnf;     then sudo dnf install -y stow
  elif have apk;     then sudo apk add stow
  else echo "ERROR: install stow manually." >&2; exit 1
  fi
}

# Symlink the selected profiles. --no-folding keeps ~/.config and ~/.local as
# real dirs (only leaf files are linked) so other tools can write there too.
stow_profiles() {
  log "stowing: $PROFILE"
  cd "$REPO_DIR"  # picks up .stowrc (--dir=dotfiles --target=~ --dotfiles)
  # shellcheck disable=SC2086
  stow --no-folding --restow $PROFILE
}

# Install mise, then the tools from the now-stowed ~/.config/mise/config.toml.
install_tools() {
  if ! have mise; then
    log "installing mise"
    if [ "$OS" = "Darwin" ] && have brew; then
      brew install mise
    else
      curl -fsSL https://mise.run | sh
    fi
  fi
  log "installing tools (mise)"
  mise install --yes
}

# Clone zsh plugins (brew provides them on macOS; needed on Linux/containers).
install_zsh_plugins() {
  local dest="$HOME/.local/share/zsh" repo
  for repo in zsh-users/zsh-autosuggestions zsh-users/zsh-syntax-highlighting; do
    local dir="$dest/${repo#*/}"
    if [ -d "$dir/.git" ]; then
      git -C "$dir" pull --ff-only --quiet || true
    else
      log "cloning ${repo#*/}"
      git clone --depth 1 --quiet "https://github.com/$repo" "$dir"
    fi
  done
}

# Sync LazyVim plugins headlessly, using the mise-managed nvim.
bootstrap_nvim() {
  [ -n "${SKIP_NVIM:-}" ] && return 0
  log "syncing Neovim plugins"
  mise exec -- nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
}

preflight
ensure_stow
stow_profiles
install_tools
install_zsh_plugins
bootstrap_nvim
log "done — restart your shell (exec zsh)."
