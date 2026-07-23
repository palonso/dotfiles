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

```bash
git clone git@github.com:palonso/dotfiles.git
cd dotfiles

# server / dev container (no GUI):
stow common nvim

# full macOS setup:
stow common nvim macos
```
