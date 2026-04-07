# dotfiles

My personal Mac setup. Clone and run `install.sh` to go from zero to a fully configured machine.

## What's included

- **Zsh** with Oh My Zsh, Starship prompt, autosuggestions, syntax highlighting, atuin history
- **Homebrew** packages and casks via `Brewfile`
- **Aliases** split by context (git, misc) — work aliases stay local, not committed
- **Git** with delta for syntax-highlighted diffs, gh-dash for PR reviews
- **mise** for managing Node, Python, and Java versions
- **CLI tools** — fd, curlie, yazi, mole, tldr, zoxide, fzf, ripgrep, bat, mprocs and more
- **macOS defaults** for Dock, Finder, keyboard

## Bootstrap a new Mac

```bash
git clone https://github.com/fmontes/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles
zsh install.sh
```

The script will:

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from `Brewfile`
3. Symlink all dotfiles to `~/`
4. Install Oh My Zsh
5. Install mise
6. Apply macOS defaults
7. Set up cmux CLI symlink
8. Print a checklist of manual steps

## After running install.sh

- Install **1Password** and sign in first
- Update `~/.gitconfig` with your name and email
- Generate SSH key: `ssh-keygen -t ed25519 -C "your@email.com"` and add to GitHub
- Run `gh auth login`
- Run `gh extension install dlvhdr/gh-dash`
- Run `mise use --global node@lts`
- Run `npm install -g @anthropic-ai/claude-code @angular/cli @fmontes/md2clip dev-browser yarn`
- Run `mise use --global python@latest`
- Run `atuin login` (optional, for cross-machine history sync)
- Sign in to Raycast to restore extensions

## Handy aliases

| Alias | Command |
|---|---|
| `prs` | Open gh-dash PR dashboard |
| `port 3000` | See what's running on a port |
| `killport 3000` | Kill process on a port |
| `ports` | List all running node/bun/deno processes |
| `devports` | List all common dev ports |
| `killdev` | Kill all common dev ports |
| `node-update` | Update Node to latest LTS via mise |
| `proj` | Fuzzy-jump to a project and open in Cursor |
| `dotfiles` | Open dotfiles in Cursor |
| `zreload` | Reload zsh config |
| `gl` | Git log (graph, last 20) |
| `gll` | Git log (graph, all branches) |
| `gcb` | git checkout -b |
| `gcleanbranches` | Delete merged/gone remote branches |
| `z <dir>` | Jump to directory with zoxide |
| `cat` | bat (syntax highlighted) |
| `curl` | curlie (friendlier curl) |
| `f` | fd (faster find) |
| `ct` | Launch Claude Code with agent teams (cmux) |
| `ct-continue` | Resume last Claude Code teams session |

## Structure

```
dotfiles/
├── Brewfile                  # Homebrew packages and casks
├── install.sh                # Bootstrap entry point
├── scripts/                  # Individual setup steps
└── home/                     # Dotfiles (mirrored to ~/)
    ├── .zshrc
    ├── .gitconfig
    └── .config/
        └── zsh/
            └── aliases.zsh   # Git + misc aliases
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/Developer/dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
