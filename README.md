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
- **[AeroSpace](https://nikitabobko.github.io/AeroSpace/)** for an Omarchy-style tiling desktop with generic workspaces
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
| `google-chrome` | Browser — two profiles, Work and personal |
| `orbstack` | Lightweight Docker alternative |
| `raycast` | Command launcher, still handles ad-hoc window resizing |
| `slack` | Chat |
| `visual-studio-code` | Code editor |
| `warp` | Terminal — tiles into whichever workspace has focus |

## Desktop

The desktop is [AeroSpace](https://nikitabobko.github.io/AeroSpace/), configured in
[`home/.config/aerospace/aerospace.toml`](home/.config/aerospace/aerospace.toml), set up to behave
as much like Omarchy/Hyprland as macOS allows.

**Workspaces are generic contexts, not app slots.** Nothing is assigned anywhere. An app opens on
whichever workspace has focus and tiles into it, and you arrange work by moving windows. There is
no rule that sends Slack to workspace 3 — if you want it there, you put it there.

Workspaces exist only while they hold a window. There is deliberately no `persistent-workspaces`
list, so `Ctrl` + `5` creates workspace 5 on demand and it disappears when you close its last
window.
A workspace you have emptied therefore stops existing, and `Ctrl` + its number is how you get back
to it — it is recreated on arrival.

### Tiling

Windows tile. A second window in a workspace splits it rather than covering it, and
`default-root-container-orientation = 'auto'` picks the axis from the container's shape — a wide
container splits side by side, a tall one stacks. Nested splits alternate axis automatically
(`enable-normalization-opposite-orientation-for-nested-containers`), the same instinct as
Hyprland's dwindle: new windows land somewhere predictable with no manual split bookkeeping.

Gaps are 6px, uniform inside and out. AeroSpace has no animations, so there is nothing to disable
for latency.

`Ctrl+Shift` + `/` collapses a workspace into an `accordion` stack and back, for when three windows
tiled is two too many. Floating is the exception rather than the default: granted per app in the
window rules, or per window with `Ctrl+Shift` + `t`.

**There is no focus indicator**, and that is a reluctant choice. AeroSpace draws nothing around the
focused window — its author left borders out on purpose.

Moving the cursor to each newly focused window (`on-focus-changed = ['move-mouse
window-lazy-center']`) was tried and removed. It reacts to *every* focus change, including ones you
did not ask for: a transient window that appears, takes focus and vanishes — an unarchiving
progress dialog, say — drags the cursor across the screen and abandons it there. Worse than no
indicator.

`on-focused-monitor-changed` is kept, because it fires only when the focused *display* changes,
which no short-lived window on the current display can trigger.

`focus-follows-mouse` stays off deliberately: paired with a cursor-moving hook it forms a loop, the
cursor landing on a window and that landing re-triggering focus.

For a real border, [JankyBorders](https://github.com/FelixKratz/JankyBorders)
(`brew install felixkratz/formulae/borders`) is the usual companion, launched from
`after-startup-command`. Not installed here — it leans on private macOS APIs that major releases
tend to break — but it is the only option that marks focus without reacting to focus.

### Navigation

**`Ctrl` is the modifier**, split by modifier depth. Each key keeps one job:

| Key | Belongs to |
|---|---|
| `Ctrl` + arrows/digits | Window navigation |
| `Ctrl+Shift` | Window manipulation |
| `Option` | Text navigation — Option+←/→ word jump is untouched |
| `Ctrl` + letter | Terminal — `ctrl-a`, `ctrl-c`, `ctrl-d`, `ctrl-r`, `ctrl-w` untouched |
| `Cmd` | macOS and app shortcuts |

Nothing binds a plain `Ctrl`+letter. Plain `Ctrl` is used *only* with arrows and digits, neither of
which carries a control character, so the terminal keeps every readline and tmux binding it had.

| Keys | Action |
|---|---|
| `Ctrl` + arrows | Focus left / down / up / right |
| `Ctrl+Shift` + arrows | Move the focused window |
| `Ctrl` + `1`…`9` | Switch to a workspace, creating it if needed; press again to bounce back |
| `Ctrl+Shift` + `1`…`9` | Send the focused window to a workspace, without following it |
| `Ctrl+Shift` + `,` / `.` | Send the focused window to the previous / next workspace |
| `Ctrl+Shift` + `[` / `]` | Previous / next occupied workspace, wrapping |
| `Ctrl+Shift` + `b` | Former workspace (back and forth) |
| `Ctrl+Shift` + `f` | Fullscreen the focused window, and back |
| `Ctrl+Shift` + `t` | Pop the focused window out of tiling into floating, and back |
| `Ctrl+Shift` + `j` | Flip the container between side-by-side and stacked |
| `Ctrl+Shift` + `-` / `=` | Shrink / grow the focused window along its container's axis |
| `Ctrl+Shift` + `/` | Collapse the workspace into an accordion stack, and back |
| `Ctrl+Shift` + `\` | Rebuild the workspace's tree as one flat row |
| `Ctrl+Shift` + `;` then `esc` | Service mode, then reload config |
| `Ctrl+Shift` + `r` | Re-apply the window rules to every open window |
| `Ctrl+Shift` + `e` | Disable AeroSpace entirely (see below) |

`Ctrl+Shift` + `-` / `=` need at least two tiled windows in the workspace — with one there is
nothing to resize against. `Ctrl+Shift` + arrows likewise refuses, non-zero, when the window is
already at the edge of its container: it declines rather than wrapping, which is correct.

Brackets take *you* to a workspace; `,` / `.` take the *window* there. Plain `Ctrl+[` is the ESC
control character, which is why the cycling keys are bound only with Shift.

#### The macOS shortcuts this collides with

System Settings → Keyboard → Keyboard Shortcuts → **Mission Control** owns several `Ctrl`
combinations, and system shortcuts win over app-registered ones. These must be off:

| Shortcut | Needed for |
|---|---|
| `Ctrl+←` / `Ctrl+→` (move a space) | focus left/right |
| `Ctrl+↑` (Mission Control) / `Ctrl+↓` (App windows) | focus up/down |
| **`Ctrl+Shift+←` / `Ctrl+Shift+→`** | move window left/right |
| `Ctrl+1`…`Ctrl+9` (Switch to Desktop N) | workspace switching |

The `Shift` variants of "Move left/right a space" are a separate pair of checkboxes from the plain
ones and are easy to miss — they were still enabled here after the plain ones had been turned off.

#### Why not Option, Caps, or Hyper

Plain `Option` was the modifier first, and it cost `Option`+←/→ word navigation, which is used
constantly. Caps Lock via Raycast's Hyper Key came next; Raycast's Hyper is fixed at
`ctrl+alt+shift+cmd`, which consumes all four modifiers AeroSpace supports, so `Caps+Shift` was
byte-identical to `Caps` and there was no second chord level — moving a window had to become a
toggled mode. `Ctrl` has neither problem: `Shift` is free, so move is a plain chord, and the
terminal keeps its control characters because plain `Ctrl` is confined to arrows and digits.

### Window rules

Only windows that need behaviour they cannot get on their own have a rule. Nothing routes to a
workspace, and there is no catch-all.

| App | Rule | Why |
|---|---|---|
| Slack | `layout tiling` | macOS reports a huddle as a utility panel, which AeroSpace auto-floats. This hands it back to tiling so a huddle sits beside the channel instead of on top of it. |
| MacWhisper | `layout tiling` | Auto-floated the same way — macOS does not report its window as an ordinary resizable one — but it tiles fine when told to |
| System Settings | `layout floating` | Glanced at, not worked in |
| 1Password | `layout floating` | Same |
| Cap | `layout floating` | Recording overlay — a control, not a window |
| krisp | `layout floating` | Mic widget — same |

The Slack rule deliberately does not match on the title. Slack sets the `Huddle:` title a moment
*after* the window appears, so a `~= "^Huddle:"` pattern never matches at detection time — it works
only when re-run afterwards, which is a good way to be fooled into thinking a rule is correct.
Tiling every Slack window sidesteps the race.

**Dialogs are exempt without needing a rule.** macOS reports a file picker or alert as a panel and
AeroSpace floats it, so a "Save as…" sheet never wedges itself into the tiling. Worth knowing when
testing a rule — `open -a TextEdit` with no argument opens TextEdit's *Open* dialog, which floats,
while `open -a TextEdit somefile.txt` opens a document window, which tiles.

`Ctrl+Shift` + `r` re-applies these rules to every open window. Since no rule moves anything between
workspaces any more, its only job is picking up an app that was already running before its float
rule existed.

### Restoring the layout

`restore-layout` is the one place a specific arrangement is written down:

```
1 Calendar   2 Slack   3 Orca   4 Chrome Work   5 Chrome Me
```

```
restore-layout            reset to the plan
restore-layout --dry-run  report what it would do, change nothing
```

It is a **reset**, not a policy. Nothing enforces the arrangement continuously — move a window
afterwards and it stays moved. But every run ends in the same state regardless of what it started
from:

- A window in the wrong place is **moved** to its workspace. All of them, not just the first, so
  three stray Chrome windows are gathered rather than one picked and the rest ignored.
- A missing app is **launched** on its workspace. With no routing rules, the script focuses the
  target workspace first and launches there — the window lands correctly because that is where you
  were, not because a rule dragged it.
- An app already in the right place is left untouched.

So the end state depends only on the plan, never on how far things had drifted. It never closes
anything and never opens a second window of an app already up, which is what makes it safe to run
repeatedly. The workspace numbers live in that script and nowhere else — there is no
`aerospace.toml` rule backing them up.

Three details it depends on:

- **Chrome is launched per profile.** One process serves every profile, so activating the bundle ID
  cannot reach a specific one; the script passes `--profile-directory` (`Profile 1` for Work,
  `Default` for Me) with `open -n`. That is only safe because the window check already established
  the profile has no window. Renaming a Chrome profile breaks the title patterns it matches on.
- **It waits for each launched window before moving on.** The window has to exist before focus
  moves to the next workspace, or it would be born on the wrong one. Chrome also sets its profile
  suffix a moment after the window appears.
- **It flattens every workspace it added to.** Moving several windows in can leave nesting from the
  order they arrived, so without this two runs could produce the same windows in different shapes —
  the opposite of a reset.

VS Code is deliberately absent: launching it with no project gives an empty window, which is worse
than an empty workspace.

### Turning it off

`Ctrl+Shift` + `e` disables AeroSpace: hidden workspaces come back on screen and key events stop being
intercepted. Useful for screen sharing, or for an app that fights the window manager. Option,
Ctrl and Cmd are untouched either way, so there is nothing to hand back.

It is one-way. While disabled the server rejects every command except `aerospace enable on`, and
no binding fires, so the key cannot undo itself — re-enable from the menu bar icon or that
command.

### Seeing what is where

AeroSpace has no overview GUI — its tray icon shows only the active workspace — and it parks
inactive windows off-screen rather than using native macOS Spaces, so Mission Control shows
everything jumbled into one Space. Run `spaces`:

```
$ spaces
1  Calendar  Calendar
3  Slack     analysts (Channel) - dotCMS - Slack
3  krisp     Krisp Notification
4  Orca      Orca
5  Google Chrome  New Tab - Google Chrome - Freddy (dotcms.com)
```

It is a plain `aerospace list-windows` piped through `sort`, defined in
[`home/.config/zsh/aliases.zsh`](home/.config/zsh/aliases.zsh). With generic workspaces there is
nothing to label, so there is nothing to keep in sync.

### Monitors

Every workspace is pinned to the main display via `workspace-to-monitor-force-assignment`, so
behaviour is identical on the MacBook screen alone and with an external monitor attached:
everything follows whichever display macOS calls main (System Settings → Displays). That is what
stops a workspace turning up on a monitor you did not expect.

The cost is that the non-main display holds nothing, so `alt` + arrows has no second monitor to
cross into even though the bindings are set up for it
(`--boundaries all-monitors-outer-frame`). Delete the whole block to let AeroSpace spread
workspaces across both displays.

### Chrome and window titles

Nothing routes by title any more, but `restore-layout` still has to tell two Chrome profiles apart,
and Chrome is the one app where that is possible. Once more than one profile is running it appends
the profile name to every window title:

```
… - Google Chrome - Freddy              → the Default profile
… - Google Chrome - Freddy (dotcms.com) → Profile 1
```

Three things this depends on:

- **Anchor the pattern.** Bare `Freddy` is a prefix of `Freddy (dotcms.com)` and matches both
  profiles.
- **Renaming a Chrome profile silently breaks it.** The profile name is hardcoded.
- **With one profile running, Chrome drops the suffix entirely**, so neither pattern matches.

Other identifiers do not work for this: `window-id` is reassigned at runtime, and both profiles
share one `app-pid` and one bundle path.

### Changing things

Adding an app to `restore-layout` is one edit: an entry in its `PLAN` array, plus a `launch()` case
if it needs more than `open -b <bundle-id>`. Nothing else has to stay in sync — that is the payoff
of dropping the per-app model.

Find a bundle ID with:

```bash
osascript -e 'id of app "Slack"'
```

Config reloads on save (`auto-reload-config = true`). To check it before trusting it:

```bash
aerospace reload-config --dry-run
```

Reloading does not re-apply rules to windows that are already open — a rule only fires when a
window is first detected. Rather than restarting AeroSpace, apply it retroactively:

```bash
aerospace run-callback --for-every-window on-window-detected   # re-apply to everything
aerospace run-callback --window-id <id> on-window-detected     # test one rule
```

The second form is the way to check a rule against a live window; it forwards the output of every
command in the callback.

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
    │   └── restore-layout    # Reset apps onto workspaces 1-5
    └── .config/
        ├── aerospace/
        │   └── aerospace.toml # Tiling, window rules, keys
        ├── zsh/
        │   └── aliases.zsh   # Git + misc aliases
        └── starship.toml     # Starship prompt config
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/.dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
