# My dotfiles

## Layout

Configs are split into profiles so a machine can take only what it needs
(directory names use a `dot-` prefix that maps to `.` in `$HOME`):

- `common` — shell (zsh), tmux, starship, mise, `~/.local/bin` scripts
- `nvim` — Neovim / LazyVim config
- `macos` — macOS GUI apps (aerospace, karabiner, kitty, skhd, yabai, ghostty)

## Installation

One command bootstraps everything: installs [mise](https://mise.jdx.dev) and
the user-space tools, symlinks the selected profiles into `$HOME`, clones the
zsh plugins, and syncs Neovim plugins. The only prerequisites are `git`,
`curl`, and `bash`. Works on macOS and any Linux, including dev containers:

```bash
git clone git@github.com:palonso/dotfiles.git
cd dotfiles
./install.sh                         # auto: common + nvim (+ macos on a Mac)
PROFILE="common nvim" ./install.sh   # explicit profile selection
SKIP_NVIM=1 ./install.sh             # skip the headless Neovim sync
```

Re-running is safe: existing symlinks are refreshed and any real file in the
way is backed up to `*.bak`.
