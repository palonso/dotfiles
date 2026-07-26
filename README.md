# My dotfiles

## Layout

Configs are split into profiles so a machine can take only what it needs
(directory names use a `dot-` prefix that maps to `.` in `$HOME`):

- `common`: shell (zsh), tmux, starship, mise, `~/.local/bin` scripts
- `nvim`: Neovim / LazyVim config
- `macos`: macOS GUI apps (aerospace, karabiner, ghostty)

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

## Adding new configs

- Add new configs by creating the appropriate files and deciding whether they go to `common`, `macos`, or a new specific profile. In directory names, write the leading `.` as a `dot-` prefix (e.g. `dot-config`); `install.sh` maps it back to `.` when symlinking into `$HOME`.
- Put custom shell scripts in `dotfiles/common/dot-local/bin/`

## Keymap structure

<ctrl> is the main modifier on Linux and <cmd> is the main modifier on macOS. Each is mapped to the caps lock key to have a common modifier across platforms. To use <cmd> as a modifier for terminal apps on Mac, I use Karabiner to swap <cmd> and <ctrl> in terminal apps for selected keys. E.g., <cmd>+r is mapped to <ctrl>+r in terminal apps, but <cmd>+r is still <cmd>+r in GUI apps.

Window/workspace related-stuff is managed by aerospace and uses <alt> as the main modifier.
<cmd+nums> is used to navigate workspaces despite shadowing certain app's shortcuts since it's the most ergonomic option.

## Tiling vs floating

After some experiments, my conclusion is that macOS is not suitable for tiled window managers and I've decided to go for a hybrid approach: browser and terminal are tiled and live in workspaces 1 and 2. Everything else is floating by default.
See [dotfiles/macos/dot-aerospace.toml](dotfiles/macos/dot-aerospace.toml) for details.
