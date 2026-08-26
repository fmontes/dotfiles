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
list, so `Caps` + `5` creates workspace 5 on demand and it disappears when you close its last
window.
That is also what makes `Caps` + `tab` / `` ` `` useful: they cycle only workspaces that currently
hold something, so you never land somewhere blank.

### Tiling

Windows tile. A second window in a workspace splits it rather than covering it, and
`default-root-container-orientation = 'auto'` picks the axis from the container's shape — a wide
container splits side by side, a tall one stacks. Nested splits alternate axis automatically
(`enable-normalization-opposite-orientation-for-nested-containers`), the same instinct as
Hyprland's dwindle: new windows land somewhere predictable with no manual split bookkeeping.

Gaps are 6px, uniform inside and out. AeroSpace has no animations, so there is nothing to disable
for latency.

`Caps` + `/` collapses a workspace into an `accordion` stack and back, for when three windows tiled
is two too many. Floating is the exception rather than the default: granted per app in the window
rules, or per window with `Caps` + `t`.

**The cursor is the focus indicator.** AeroSpace draws nothing around the focused window — its
author left borders out on purpose — so `on-focus-changed = ['move-mouse window-lazy-center']`
sends the pointer to the centre of whatever you focus. That doubles as a fix for the cursor being
orphaned over a window that no longer has focus, which is easy to do when navigating by keyboard.
`lazy` means it only moves when the cursor is not already inside that window, so it never fights
you mid-drag.

`focus-follows-mouse` stays off deliberately: the two together form a loop, the cursor landing on a
window and that landing re-triggering focus.

If you want a real border instead, [JankyBorders](https://github.com/FelixKratz/JankyBorders)
(`brew install felixkratz/formulae/borders`) is the usual companion, launched from
`after-startup-command`. It is not installed here — it leans on private macOS APIs that major
releases tend to break, and the cursor cue costs nothing and cannot break.

### Navigation

**Caps Lock is the modifier**, standing in for Omarchy's `Super`, via Raycast's Hyper Key. Each
modifier keeps one job:

| Key | Belongs to |
|---|---|
| Caps | Window management |
| Option | Text navigation — Option+←/→ word jump is untouched |
| Ctrl | Terminal — `ctrl-a` and `ctrl-d` are untouched |
| Cmd | macOS and app shortcuts |

Raycast makes Caps Lock emit `ctrl+alt+shift+cmd`, so every binding is written against that literal
sequence — read `ctrl-alt-shift-cmd-` in the config as "Caps".

| Keys | Action |
|---|---|
| `Caps` + arrows | Focus left / down / up / right |
| `Caps` + `-` / `=` | Shrink / grow the focused window along its container's axis |
| `Caps` + `1`…`9` | Switch to a workspace, creating it if needed; press again to bounce back |
| `Caps` + `tab` | Next occupied workspace |
| `Caps` + `` ` `` | Previous occupied workspace |
| `Caps` + `b` | Former workspace (back and forth) |
| `Caps` + `f` | Fullscreen the focused window, and back |
| `Caps` + `t` | Pop the focused window out of tiling into floating, and back |
| `Caps` + `j` | Flip the container between side-by-side and stacked (Hyprland's togglesplit) |
| `Caps` + `/` | Collapse the workspace into an accordion stack, and back |
| `Caps` + `\` | Rebuild the workspace's tree as one flat row |
| `Caps` + `a` | Enter move mode (below) |
| `Caps` + `;` then `esc` | Service mode, then reload config |
| `Caps` + `r` | Re-apply the window rules to every open window |
| `Caps` + `e` | Disable AeroSpace entirely (see below) |

`Caps` + `-` / `=` need at least two tiled windows in the workspace — with one there is nothing to
resize against, and the command fails silently.

#### Move mode

Moving a window is a mode rather than a chord, and that is forced rather than chosen. Raycast's
Hyper **includes Shift**, so holding Shift alongside Caps sets a bit that is already set:
`Caps+Shift+←` is byte-identical to `Caps+←` and AeroSpace cannot tell them apart. The same goes
for Ctrl and Cmd — Hyper consumes all four modifiers AeroSpace supports, and `fn` is not one it
accepts. There is no second chord level to use.

So the move commands live in a mode, the way i3 and sway have always done resize mode:

| Keys | Action |
|---|---|
| `Caps` + `a` | Enter move mode (`a` is next to Caps Lock) |
| then arrows | Move the focused window; stays in the mode for repeated nudges |
| then `1`…`9` | Send the window to that workspace, and leave the mode |
| `esc`, `enter`, or `Caps` + `a` | Leave the mode |

Unbound keys pass through to the focused app, so the mode is not a keyboard trap — but it is not
visually obvious you are in it either. `esc` is the way out.

To get the literal `Caps+Shift` model instead, set Raycast's Hyper Key to `ctrl+alt+cmd` **without**
Shift. `Caps+Shift` then becomes a distinct combination and these could go back to being plain
chords.

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

`Caps` + `r` re-applies these rules to every open window. Since no rule moves anything between
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

`Caps` + `e` disables AeroSpace: hidden workspaces come back on screen and key events stop being
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
