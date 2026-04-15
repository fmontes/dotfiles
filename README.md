# dotfiles

My personal Mac setup. One command to go from zero to a fully configured machine.

```bash
curl -fsSL https://fmontes.com/install.sh | bash
```

This clones the repo to `~/.dotfiles` and runs the installer.

## What's included

- **Zsh** with Oh My Zsh, Starship prompt, autosuggestions, syntax highlighting, atuin history
- **Homebrew** packages and casks via `Brewfile`
- **Aliases** split by context — work aliases stay local, not committed
- **Git** with delta for diffs, gh-dash for PR reviews
- **mise** for managing Node, Python, and Java versions
- **helix** for terminal code search and browsing
- **macOS defaults** for Dock, Finder, keyboard

## Manual install

```bash
git clone https://github.com/fmontes/dotfiles ~/.dotfiles
cd ~/.dotfiles
zsh install.sh
```

The script will:

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from `Brewfile`
3. Symlink all dotfiles to `~/`
4. Install Oh My Zsh
5. Set up mise and install Node and Python
6. Apply macOS defaults
7. Install gh-dash, global npm packages, fix permissions, set up cmux

## After running install.sh

These steps require human interaction and can't be automated:

- Install **1Password** and sign in first
- Generate SSH key: `ssh-keygen -t ed25519 -C "your@email.com"` and add to GitHub
- Update `~/.gitconfig` with your name and email
- Run `gh auth login`
- Run `atuin login` (optional, for cross-machine history sync)
- Sign in to Raycast to restore extensions

## Aliases

### Git

| Alias | Command |
|---|---|
| `g` | git |
| `gs` | git status |
| `ga` | git add |
| `gaa` | git add . |
| `gcm` | git commit -m |
| `gp` | git push |
| `gco` | git checkout |
| `gcb` | git checkout -b |
| `gbd` | git branch -d |
| `gl` | Git log graph (last 20) |
| `gll` | Git log graph (all branches) |
| `gcleanbranches` | Delete local branches whose remote is gone |

### CLI Replacements

| Alias | Replaces |
|---|---|
| `cat` | bat (syntax highlighted) |
| `curl` | curlie (friendlier interface) |
| `f` | fd (faster find) |

### Ports

| Alias | Command |
|---|---|
| `port 3000` | Show process listening on a port |
| `killport 3000` | Kill process on a port |
| `ports` | List all running node/bun/deno processes |
| `devports` | List processes on common dev ports |
| `killdev` | Kill all common dev ports at once |

### Projects

| Alias | Command |
|---|---|
| `proj` | Fuzzy-jump to a project and open in Cursor |

### GitHub

| Alias | Command |
|---|---|
| `prs` | Open gh-dash PR dashboard |

### Dotfiles

| Alias | Command |
|---|---|
| `dotfiles` | Open dotfiles repo in Cursor |
| `zreload` | Reload zsh config |

### Claude / cmux

| Alias | Command |
|---|---|
| `ct` | Launch Claude Code agent teams |
| `ct-continue` | Resume last agent teams session |
| `claude-teams` | Same as `ct` (full name) |

### Misc

| Alias | Command |
|---|---|
| `cursor` | Open Cursor in a new window |
| `run-help` | man (show manual) |

## CLI Tools

| Tool | Description |
|---|---|
| `atuin` | Shell history with search and optional sync |
| `bat` | `cat` with syntax highlighting |
| `cloudflared` | Cloudflare tunnel client |
| `curlie` | Friendlier `curl` |
| `deno` | JavaScript/TypeScript runtime |
| `fd` | Faster `find` |
| `ffmpeg` | Audio/video processing |
| `flyctl` | Fly.io CLI |
| `fzf` | Fuzzy finder (used by proj, atuin, zsh history) |
| `gh` | GitHub CLI |
| `git-delta` | Syntax-highlighted git diffs |
| `helix` | Terminal editor for code search and browsing |
| `imagemagick` | Image processing |
| `jq` | JSON processor |
| `just` | Task runner (used in dotCMS project) |
| `mise` | Version manager for Node, Python, Java |
| `mkcert` | Local SSL certificates |
| `mole` | SSH tunnel manager |
| `mprocs` | Run multiple processes in split panes |
| `ripgrep` | Fast grep replacement |
| `rtk` | Token-optimized CLI proxy for Claude Code |
| `starship` | Cross-shell prompt |
| `tlrc` | `tldr` client — simplified man pages |
| `tree` | Directory tree viewer |
| `wget` | File downloader |
| `yazi` | Terminal file manager with preview |
| `zoxide` | Smart `cd` replacement |

### Apps (Casks)

| App | Description |
|---|---|
| `1password-cli` | 1Password CLI |
| `chromium` + `chromedriver` | Headless browser for Puppeteer |
| `cmux` | Claude Code agent teams |
| `codex` | OpenAI Codex CLI |
| `cursor` | AI code editor |
| `ghostty` | Terminal emulator |
| `ollama` | Run local LLMs |
| `orbstack` | Lightweight Docker alternative |
| `raycast` | Command launcher |

## Helix

Terminal editor used for code search and browsing. Launch with `hx .` from any project.

| Key | Action |
|---|---|
| `Space+/` | Live grep across all files |
| `Space+f` | Fuzzy file finder |
| `Space+s` | Symbol picker (current file) |
| `Space+S` | Workspace symbol picker |
| `Ctrl+o` | Copy current file path to clipboard |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover docs |
| `:q` | Quit |

TypeScript LSP: `npm install -g typescript-language-server typescript`

## Structure

```
dotfiles/
├── Brewfile                  # Homebrew packages and casks
├── bootstrap.sh              # Remote entry point (curl | bash)
├── install.sh                # Local installer
├── scripts/                  # Individual setup steps
└── home/                     # Dotfiles (mirrored to ~/)
    ├── .zshrc
    ├── .gitconfig
    └── .config/
        ├── zsh/
        │   └── aliases.zsh   # Git + misc aliases
        ├── helix/
        │   └── config.toml   # Helix editor config
        └── starship.toml     # Starship prompt config
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/.dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
