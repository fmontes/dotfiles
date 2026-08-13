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
- **[AeroSpace](https://nikitabobko.github.io/AeroSpace/)** for a fixed desktop layout where every app has its own slot
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
| `codex` | OpenAI Codex CLI |
| `google-chrome` | Browser — desktop slots 5 and 6, split by profile |
| `orbstack` | Lightweight Docker alternative |
| `raycast` | Command launcher, still handles ad-hoc window resizing |
| `slack` | Chat — desktop slot 3 |
| `visual-studio-code` | Code editor — desktop slot 7 |
| `warp` | Terminal — no slot, lands in overflow |

## Desktop

The desktop layout is [AeroSpace](https://nikitabobko.github.io/AeroSpace/), configured in
[`home/.config/aerospace/aerospace.toml`](home/.config/aerospace/aerospace.toml) with navigation
in [`home/.local/bin/aerospace-track`](home/.local/bin/aerospace-track).

One horizontal track, one app per slot, every app always in the same place:

| 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|
| Desktop | Calendar | Slack | Orca | Chrome Work | Chrome Me | VS Code |

Slot 1 is deliberately empty — a clean desktop to land on, and where login drops you.

Windows never tile. A second window of an app joins that app's slot and covers the first at full
size (`accordion` with zero padding), so one app fills the screen at a time; `alt-j` / `alt-k`
cycles between them. When you do want two side by side, `alt-/` splits just the slot you are on
and toggles back — the rest of the layout stays stacked.

The one standing exception is **Slack**, whose windows always tile so a huddle sits beside the
channel rather than on top of it. macOS reports the huddle as a utility panel, so the rule uses
`layout tiling` to override AeroSpace's auto-float and `layout h_tiles` to split the slot.

The rule deliberately does not match on the title. Slack sets the `Huddle:` title a moment *after*
the window appears, so a `~= "^Huddle:"` pattern never matches at detection time — it works only
when re-run afterwards, which is a good way to be fooled into thinking a rule is correct. Tiling
every Slack window sidesteps the race. The slot stays tiled once the huddle ends, which is
indistinguishable from accordion with one window; `alt-/` switches it back.

Slot `0` is overflow — anything not in the layout lands there and takes focus with it, so a
stray app never quietly steals a slot. Utilities (System Settings, Finder, 1Password) float on
top of whatever is in front instead of being assigned anywhere.

### Navigation

| Keys | Action |
|---|---|
| `ctrl-a` / `ctrl-d` | Previous / next occupied slot, looping around the ends |
| `alt-1`…`alt-7`, `alt-0` | Jump straight to a slot; press again to bounce back |
| `alt-shift-1`…`alt-shift-0` | Move the focused window to a slot |
| `alt-tab` | Toggle between the last two windows, falling back to the last two slots |
| `alt-j` / `alt-k` | Cycle windows within a slot |
| `alt-/` | Split the current slot side by side, and back |
| `alt-shift-;` then `esc` | Service mode, then reload config |
| `alt-shift-e` | Disable AeroSpace entirely (see below) |

### Turning it off

`alt-shift-e` disables AeroSpace: hidden workspaces come back on screen and key events stop being
intercepted, which hands `ctrl-a` and `ctrl-d` back to the terminal. Useful for screen sharing, or
for an app that fights the window manager.

It is one-way. While disabled the server rejects every command except `aerospace enable on`, and
no binding fires, so the key cannot undo itself — re-enable from the menu bar icon or that
command. Windows return to their original slots afterwards.

### Seeing the whole layout

AeroSpace has no overview GUI — its tray icon shows only the active workspace — and it parks
inactive windows off-screen rather than using native macOS Spaces, so Mission Control shows
everything jumbled into one Space. Run `spaces` (alias for `aerospace-track overview`) instead:

```
   1 Desktop  2 Calendar  3 Slack  4 Orca  5 Chrome Work [6 Chrome Me] 7 VS Code
   0 Warp, krisp
```

The focused slot is bracketed and coloured, occupied slots are bold, and empty ones are dimmed.
Brackets rather than colour alone mark the focus, so the output still reads correctly when piped
into something else. The overflow row only appears when something is in it.

`ctrl-a` / `ctrl-d` loop around the ends — right off VS Code returns to the empty desktop, left
off the desktop goes to VS Code. Overflow is not on the loop; reach it with `alt-0`.

**Empty slots are skipped.** An app that is not running would otherwise present a blank screen
indistinguishable from the desktop, and you would have to count keypresses to know where you
were. Slot 1 is exempt, being the intentional desktop. The trade-off is that the number of
presses between two apps changes as apps open and close — the slots themselves never move, and
`alt-N` always jumps straight to one.

Both navigation keys are global grabs, so they shadow the terminal's readline bindings —
`ctrl-a` (beginning of line) and `ctrl-d` (EOF). If that bites inside Warp, prefix both with
`alt-` in `aerospace.toml` to hand them back to the shell.

### Splitting Chrome by profile

Most rules match on bundle ID, which cannot tell two windows of the same app apart. Chrome is the
exception: once more than one profile is running it appends the profile name to every window
title, so the title becomes a usable discriminator.

```toml
if = 'test %{app-bundle-id} = com.google.Chrome && test %{window-title} ~= "Freddy \(dotcms\.com\)$"'
```

Three things this depends on:

- **Anchor the pattern.** Bare `Freddy` is a prefix of `Freddy (dotcms.com)` and matches both
  profiles. `~=` is a case-insensitive regex, so `$` works.
- **Renaming a Chrome profile silently breaks the rule.** The profile name is hardcoded.
- **With one profile running, Chrome drops the suffix.** A third rule matching bundle ID alone
  catches that case and sends the window to slot 5, so it never falls through to overflow.

Note that a regex beginning with `-` is parsed as a CLI flag and silently fails to match — write
`Chrome - Freddy$` rather than `- Freddy$`.

Other identifiers do not work for this: `window-id` is reassigned at runtime, and both profiles
share one `app-pid` and one bundle path. Everywhere else in the layout, an app owns exactly one
slot and extra windows stack full-screen on top (`alt-j` / `alt-k` cycles them).

### Changing the layout

Adding or reordering an app means two edits that must stay in sync:

1. The `[[on-window-detected]]` rule in `aerospace.toml` that maps a bundle ID to a slot.
2. The `TRACK` and `LABELS` arrays at the top of `aerospace-track`, which must stay
   positionally aligned with each other.

Find a bundle ID with:

```bash
osascript -e 'id of app "Slack"'
```

Config reloads on save (`auto-reload-config = true`). To check it before trusting it:

```bash
aerospace reload-config --dry-run
```

Reloading does not re-place windows that are already open — routing only fires when a window is
detected. Rather than restarting AeroSpace, apply new rules retroactively:

```bash
aerospace run-callback --for-every-window on-window-detected   # re-route everything
aerospace run-callback --window-id <id> on-window-detected     # test one rule
```

The second form is the way to check a rule against a live window; it forwards the output of every
command in the callback.

Every slot is pinned to the main display, so the layout is identical on the MacBook screen and
on an external monitor. To push some slots onto a second display instead, change their rows in
`[workspace-to-monitor-force-assignment]` from `main` to `secondary`.

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
