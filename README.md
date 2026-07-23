# My dotfiles

## Requirements

Install [stow](https://www.gnu.org/software/stow/).

Mac:

```bash
brew install stow
```

Linux:

```bash
sudo apt install stow
```

## Layout

Configs are split into stow packages (profiles) so a machine can take only
what it needs:

- `common` — shell (zsh), tmux, starship, mise, `~/.local/bin` scripts
- `nvim` — Neovim / LazyVim config
- `macos` — macOS GUI apps (aerospace, karabiner, kitty, skhd, yabai, ghostty)

## Installation

One command bootstraps everything (installs [mise](https://mise.jdx.dev) and
user-space tools, zsh plugins, `stow`, symlinks the configs, and syncs Neovim
plugins). Works on macOS and any Linux, including inside dev containers:

```bash
git clone git@github.com:palonso/dotfiles.git
cd dotfiles
./install.sh                    # auto: common + nvim (+ macos on a Mac)
PROFILE="common nvim" ./install.sh   # explicit profile selection
SKIP_NVIM=1 ./install.sh        # skip the headless Neovim sync
```

### Manual (stow only)

If the tools are already present you can just symlink the configs:

```bash
stow common nvim         # server / dev container (no GUI)
stow common nvim macos   # full macOS setup
```
