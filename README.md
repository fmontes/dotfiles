# dotfiles

> From factory reset to coding in five minutes.

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
- **[AeroSpace](https://nikitabobko.github.io/AeroSpace/)** for a fixed two-track desktop layout with WASD navigation
- **[Fresh](https://getfresh.dev/)** for terminal code editing and browsing
- **[AI](ai/)** skills, instructions, and subagents for agentic coding harnesses
- **macOS defaults** for Dock, Finder, keyboard

## Manual install

```bash
git clone https://github.com/fmontes/dotfiles ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The script will:

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from `Brewfile`
3. Symlink all dotfiles to `~/`
4. Install Oh My Zsh
5. Set up mise and install Node and Python
6. Apply macOS defaults
7. Install gh-dash, global npm packages, fix permissions, set up the VS Code CLI
8. Sync AI agent config to every platform with `chai`

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
| `f` | fd (faster find) |
| `ls` | eza (icons, dirs first) |
| `ll` | eza long view with git status |
| `lt` | eza tree view (2 levels) |

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
| `proj` | Fuzzy-jump to a project and open in VS Code |

### GitHub

| Alias | Command |
|---|---|
| `prs` | Open gh-dash PR dashboard |

### Dotfiles

| Alias | Command |
|---|---|
| `dotfiles` | Open dotfiles repo in VS Code |
| `zreload` | Reload zsh config |

### Misc

| Alias | Command |
|---|---|
| `code` | Open VS Code in a new window |
| `run-help` | man (show manual) |

## CLI Tools

| Tool | Description |
|---|---|
| `atuin` | Shell history with search and optional sync |
| `bat` | `cat` with syntax highlighting |
| `btop` | Resource monitor (CPU, memory, processes) |
| `cloudflared` | Cloudflare tunnel client |
| `deno` | JavaScript/TypeScript runtime |
| `dust` | Visual `du` — disk usage by directory |
| `eza` | Modern `ls` with icons and git status |
| `fd` | Faster `find` |
| `ffmpeg` | Audio/video processing |
| `flyctl` | Fly.io CLI |
| `fresh-editor` | [Fresh](https://getfresh.dev/) — terminal editor for code editing and browsing |
| `fzf` | Fuzzy finder (used by proj, atuin, zsh history) |
| `gh` | GitHub CLI |
| `git-delta` | Syntax-highlighted git diffs |
| `imagemagick` | Image processing |
| `jq` | JSON processor |
| `just` | Task runner (used in dotCMS project) |
| `lazydocker` | Terminal UI for Docker containers |
| `mise` | Version manager for Node, Python, Java |
| `mkcert` | Local SSL certificates |
| `mole` | SSH tunnel manager |
| `mprocs` | Run multiple processes in split panes |
| `ripgrep` | Fast grep replacement |
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
| `aerospace` | Tiling window manager, drives the desktop layout |
| `chai` | Sync AI agent config across platforms |
| `chromedriver` | Headless driver for Puppeteer |
| `chromium` | Puppeteer's browser (cask disabled 2026-09-01) |
| `cmux` | Personal terminal, Ghostty-based |
| `codex` | OpenAI Codex CLI |
| `google-chrome` | Work browser |
| `google-chrome@canary` | Personal browser |
| `orbstack` | Lightweight Docker alternative |
| `raycast` | Command launcher, still handles ad-hoc window resizing |
| `slack` | Work chat |
| `visual-studio-code` | Work editor |
| `visual-studio-code@insiders` | Personal editor |
| `warp` | Work terminal |

## Desktop

The desktop layout is [AeroSpace](https://nikitabobko.github.io/AeroSpace/), configured in
[`home/.config/aerospace/aerospace.toml`](home/.config/aerospace/aerospace.toml) with navigation
in [`home/.local/bin/aerospace-track`](home/.local/bin/aerospace-track).

Two horizontal tracks, one app per slot, every app always in the same place:

| | 1 | 2 | 3 | 4 | 5 | 6 |
|---|---|---|---|---|---|---|
| **Work** | Chrome | Orca | Slack | Calendar | Warp | VS Code |

| | 7 | 8 | 9 |
|---|---|---|---|
| **Personal** | Chrome Canary | cmux | VS Code Insiders |

Slot `0` is overflow — anything not in the layout lands there and takes focus with it, so a
stray app never quietly steals a track slot. Utilities (System Settings, Finder, 1Password)
float on top of whatever is in front instead of being assigned anywhere.

### Navigation

| Keys | Action |
|---|---|
| `alt-a` / `alt-d` | Previous / next slot in the current track, stopping at the edges |
| `alt-w` / `alt-s` | Work track / Personal track, resuming that track's last slot |
| `alt-1`…`alt-9`, `alt-0` | Jump straight to a slot |
| `alt-shift-1`…`alt-shift-0` | Move the focused window to a slot |
| `alt-tab` | Toggle between the last two slots |
| `alt-j` / `alt-k` | Cycle windows within a slot |
| `alt-shift-;` then `esc` | Service mode, then reload config |

`alt-w` / `alt-s` remember where you were: leave Work on Slack, wander around Personal, and
`alt-w` puts you back on Slack. That memory lives in `~/.local/state/aerospace/`, written by
`aerospace-track record` on every workspace change.

### Why the apps are split

AeroSpace routes windows by **bundle ID**, so two windows of the same app are indistinguishable
to it. Work and Personal therefore use different apps rather than different profiles:

| Work | Personal | |
|---|---|---|
| `com.google.Chrome` | `com.google.Chrome.canary` | Chrome / Chrome Canary |
| `com.microsoft.VSCode` | `com.microsoft.VSCodeInsiders` | VS Code / VS Code Insiders |

Chrome profiles alone could not be pinned to separate slots, because a Chrome window title
carries no profile information. Canary is a separate signed app with its own profile store, so
Personal browsing stays genuinely separate while keeping the Chrome engine and extensions.
The routing rules use `=` (exact match), not `~=` (substring), so `com.google.Chrome` never
captures Canary's windows.

### Changing the layout

Adding or reordering an app means two edits that must stay in sync:

1. The `[[on-window-detected]]` rule in `aerospace.toml` that maps a bundle ID to a slot.
2. The `WORK` / `PERSONAL` arrays at the top of `aerospace-track`.

Find a bundle ID with:

```bash
osascript -e 'id of app "Slack"'
```

Config reloads on save (`auto-reload-config = true`). To check it before trusting it:

```bash
aerospace reload-config --dry-run
```

Every slot is pinned to the main display, so the layout is identical on the MacBook screen and
on an external monitor. To spread the tracks across two displays instead, change the Personal
rows in `[workspace-to-monitor-force-assignment]` from `main` to `secondary`.

AeroSpace needs Accessibility access (System Settings → Privacy & Security → Accessibility)
before it can move any windows.

## Fresh

[Fresh](https://getfresh.dev/) is the terminal editor used for code editing and browsing. Launch with `fresh .` from any project. No config file fiddling required.

## AI

All AI agent config lives in [`ai/`](ai/) as a single source of truth:

- [`ai/instructions/`](ai/instructions/) — shared instructions (`AGENTS.md`)
- [`ai/skills/`](ai/skills/) — [agent skills](https://docs.claude.com/en/docs/claude-code/skills) (one folder per skill)
- [`ai/subagents/`](ai/subagents/) — custom subagent definitions

### Syncing with chai

I author the config once and let [**chai**](https://github.com/charliesbot/chai) distribute it to every agent platform — Claude, Codex, Droid, OpenCode, and Antigravity — instead of hand-maintaining each one's config files. The manifest lives in [`home/chai.toml`](home/chai.toml) (symlinked to `~/chai.toml`).

`install.sh` runs `chai update && chai sync` for you, so a fresh machine is ready with no extra steps. Afterwards, the loop for changes is:

```bash
# 1. Edit the source of truth
$EDITOR ai/instructions/AGENTS.md      # or add a skill/subagent under ai/

# 2. Distribute to every platform listed in chai.toml
chai update   # clone/pull any external deps first (skills from other repos, etc.)
chai sync     # copy instructions, skills, and subagents into each platform's config dir
```

`chai sync` uses hash-based dirty detection: if an agent edited its copy, it prompts before overwriting. Add `--dry-run` to preview changes or `--force` to skip the dirty check. Because `ai/` is the only place you edit, every machine and every agent stays in sync from one commit.

Skills can also come from other people's repos. Declare them under `[deps]` in `chai.toml` — `chai update` clones each to `~/.chai/deps/`, and `[skills]` paths reference them with `@name`. Current external skills: [impeccable](https://github.com/pbakaus/impeccable), [frontend-slides](https://github.com/zarazhangrui/frontend-slides), and [dev-browser](https://github.com/sawyerhood/dev-browser).

### Installing a single skill elsewhere

The skills are also installable standalone in any project, without chai:

```bash
npx skills add https://github.com/fmontes/dotfiles/tree/main/ai --skill <skill-name>
```

See the [skills README](ai/skills/README.md) for the full list.

## Structure

```
dotfiles/
├── Brewfile                  # Homebrew packages and casks
├── bootstrap.sh              # Remote entry point (curl | bash)
├── install.sh                # Local installer
├── scripts/                  # Individual setup steps
├── ai/                       # AI tooling
│   ├── skills/               # Agent skills (any agentic harness)
│   ├── instructions/         # Reusable prompt instructions
│   └── subagents/            # Custom subagent definitions
└── home/                     # Dotfiles (mirrored to ~/)
    ├── .zshrc
    ├── .gitconfig
    ├── chai.toml             # AI config sync manifest (~/chai.toml)
    ├── .local/bin/
    │   └── aerospace-track   # WASD track navigation for the desktop layout
    └── .config/
        ├── aerospace/
        │   └── aerospace.toml # Desktop layout: slots, routing, keys
        ├── zsh/
        │   └── aliases.zsh   # Git + misc aliases
        └── starship.toml     # Starship prompt config
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/.dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
