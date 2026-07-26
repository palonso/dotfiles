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

# Run a command as root when we aren't already (containers often lack sudo).
as_root() {
  if [ "$(id -u)" = 0 ]; then "$@"; elif have sudo; then sudo "$@";
  else log "need root to run: $*"; return 1; fi
}

# Ensure a working downloader exists; install curl via the OS package manager
# on minimal images (dev containers) that ship without it.
ensure_downloader() {
  if have curl || have wget; then return 0; fi
  log "no curl/wget found - installing curl"
  if   have apt-get; then as_root apt-get update -qq && as_root apt-get install -y -qq curl ca-certificates
  elif have apk;     then as_root apk add --no-cache curl ca-certificates
  elif have dnf;     then as_root dnf install -y -q curl ca-certificates
  elif have yum;     then as_root yum install -y -q curl ca-certificates
  elif have pacman;  then as_root pacman -Sy --noconfirm curl ca-certificates
  else log "cannot auto-install curl; please install curl or wget"; return 1; fi
}

# Fetch a URL to stdout using whichever downloader is available.
fetch() {
  if have curl; then curl -fsSL "$1"; else wget -qO- "$1"; fi
}

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

# Symlink each profile's files into $HOME, translating the `dot-` prefix to `.`
# (e.g. common/dot-config/nvim/init.lua -> ~/.config/nvim/init.lua). Only leaf
# files are linked, so ~/.config and ~/.local stay real dirs that other tools
# (mise) can share. Any pre-existing real file is backed up to *.bak.
link_profiles() {
  local profile src rel target
  for profile in $PROFILE; do
    log "linking $profile"
    while IFS= read -r src; do
      rel=$(sed -e 's#^dot-#.#' -e 's#/dot-#/.#g' <<<"${src#"$REPO_DIR/dotfiles/$profile/"}")
      target="$HOME/$rel"
      mkdir -p "$(dirname "$target")"
      [ -e "$target" ] && [ ! -L "$target" ] && mv "$target" "$target.bak"
      ln -sfn "$src" "$target"
    done < <(find "$REPO_DIR/dotfiles/$profile" -type f ! -name .DS_Store)
  done
}

# Install mise, then the tools from the now-stowed ~/.config/mise/config.toml.
install_tools() {
  if ! have mise; then
    log "installing mise"
    if [ "$OS" = "Darwin" ] && have brew; then
      brew install mise
    else
      ensure_downloader
      fetch https://mise.run | sh
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

# Clone TPM (tmux plugin manager) and install the plugins listed in tmux.conf
# (catppuccin, tmux-sensible, etc.). TPM itself is a git repo, and it clones the
# other plugins into ~/.config/tmux/plugins/, so this stays in git-clone land
# rather than mise (which manages binaries, not tmux plugins).
install_tmux_plugins() {
  have tmux || { log "tmux not found - skipping tmux plugins"; return 0; }
  local tpm="$HOME/.config/tmux/plugins/tpm"
  if [ -d "$tpm/.git" ]; then
    git -C "$tpm" pull --ff-only --quiet || true
  else
    log "cloning tpm"
    git clone --depth 1 --quiet https://github.com/tmux-plugins/tpm "$tpm"
  fi
  log "installing tmux plugins (tpm)"
  "$tpm/bin/install_plugins" >/dev/null || true
}

# Sync LazyVim plugins headlessly, using the mise-managed nvim.
bootstrap_nvim() {
  [ -n "${SKIP_NVIM:-}" ] && return 0
  log "syncing Neovim plugins"
  mise exec -- nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
}

preflight
link_profiles
install_tools
install_zsh_plugins
install_tmux_plugins
bootstrap_nvim
log "done — restart your shell (exec zsh)."
