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
- **Aliases** split by context. Work aliases stay local, not committed
- **Git** with delta for diffs, gh-dash for PR reviews
- **mise** for managing Node, Python, and Java versions
- **[AeroSpace](https://nikitabobko.github.io/AeroSpace/)** for an Omarchy-style tiling desktop with generic workspaces
- **[Fresh](https://getfresh.dev/)** for terminal code editing and browsing
- **[herdr.app](https://herdr.dev/)** as the terminal: spaces, tabs, panes and coding agents in one native window
- **[AI](ai/)** skills and instructions for agentic coding harnesses
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
3. Symlink all dotfiles to `~/` and enable the repo's git hooks
4. Install Oh My Zsh
5. Set up mise and install Node and Python
6. Apply macOS defaults
7. Install gh-dash and the herdr annotate plugin, global npm packages, restore Tinycast settings, fix permissions, set up the VS Code CLI
8. Sync AI agent config to every platform with `chai`

## After running install.sh

These steps require human interaction and can't be automated:

- Install **herdr.app**: `curl -fsSL https://releases.herdr.dev/app/install.sh | sh`. It has no Homebrew cask, so the Brewfile cannot carry it. The script installs to `~/Applications`, checksums the download, and leaves an existing `herdr-core` alone; the app self-updates afterwards. Launch it once so it creates `~/.config/herdr-app/`, then re-run `scripts/03-symlinks.sh` to link `keys.json` and `settings.json`
- Install **1Password** and sign in first
- Generate SSH key: `ssh-keygen -t ed25519 -C "your@email.com"` and add to GitHub
- Write `~/.gitconfig.local` with your name, email, and the two signing paths. The tracked `home/.gitconfig` turns SSH commit signing on for everyone but deliberately holds no absolute path, so `commit.gpgsign = true` fails every commit until this file exists:

  ```ini
  [user]
  	name = Your Name
  	email = your@email.com
  	signingkey = /Users/you/.ssh/github_ed25519.pub
  [gpg "ssh"]
  	allowedSignersFile = /Users/you/.ssh/allowed_signers
  ```

  `allowed_signers` is a file you write, one `email key-type key` line per identity you trust, and it is what makes `git log --show-signature` say *Good signature* rather than *No principal matched*.
- Run `gh auth login`
- Run `atuin login` (optional, for cross-machine history sync)
- Launch Tinycast. Its hotkeys and aliases are restored by the installer, but grant it Accessibility access so the hyper key works
- Grant your terminal **App Management** access (System Settings → Privacy & Security → App Management) if `brew bundle` failed on a cask with `chgrp: … Operation not permitted`. macOS blocks one app from modifying another's bundle and `sudo` does not bypass it, so adopting an app installed by hand fails every time. Delete the app and let Homebrew install it fresh, or grant the permission and keep future `brew upgrade --cask` working.

## Aliases

Only things that have to live in the shell. Standalone commands are [CLI tools](#cli-tools); run `tools` to list them.

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

### CLI Replacements

| Alias | Replaces |
|---|---|
| `cat` | bat (syntax highlighted) |
| `f` | fd (faster find) |
| `ls` | eza (icons, dirs first) |
| `ll` | eza long view with git status |
| `lt` | eza tree view (2 levels) |

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
| `zreload` | Reload zsh config |

### Misc

| Alias | Command |
|---|---|
| `code` | Open VS Code in a new window |

## CLI Tools

| Tool | Description |
|---|---|
| `atuin` | Shell history with search and optional sync |
| `bat` | `cat` with syntax highlighting |
| `btop` | Resource monitor (CPU, memory, processes) |
| `chai` | Sync AI agent config across platforms. `charliesbot/tap`, not the unrelated `chai` cask |
| `cloudflared` | Cloudflare tunnel client |
| `eza` | Modern `ls` with icons and git status |
| `fd` | Faster `find` |
| `ffmpeg` | Audio/video processing |
| `ffmpeg@7` | ffmpeg 7, force-linked over 8. `ffmpeg` on `PATH` is this one |
| `fresh-editor` | [Fresh](https://getfresh.dev/), terminal editor for code editing and browsing |
| `fzf` | Fuzzy finder (used by proj, atuin, zsh history) |
| `gh` | GitHub CLI |
| `herdr` | [herdr](https://herdr.dev), agent multiplexer that owns terminal tabs, panes, and workspaces |
| `git-delta` | Syntax-highlighted git diffs |
| `imagemagick` | Image processing |
| `jq` | JSON processor |
| `just` | Task runner (used in dotCMS project) |
| `mise` | Version manager for Node, Python, Java |
| `mkcert` | Local SSL certificates |
| `mole` | Deep clean and optimize your Mac ([mole.fit](https://mole.fit)) |
| `opencode` | AI coding agent for the terminal |
| `poppler` | PDF rendering, used by terminal file previews |
| `railway` | Railway CLI, deploys and service management |
| `ripgrep` | Fast grep replacement |
| `starship` | Cross-shell prompt |
| `zoxide` | Smart `cd` replacement |

### Apps (Casks)

| App | Description |
|---|---|
| `1password-cli` | 1Password CLI |
| `aerospace` | Tiling window manager, drives the desktop layout |
| `codex` | OpenAI Codex CLI |
| `google-chrome` | Browser, two profiles: Work and personal |
| `orbstack` | Lightweight Docker alternative |
| `tinycast` | Command launcher, hotkeys, and clipboard history |
| `slack` | Chat |
| `visual-studio-code` | Code editor |
| `warp` | Terminal, tiles into whichever workspace has focus |

## Desktop

The desktop is [AeroSpace](https://nikitabobko.github.io/AeroSpace/), configured in [`home/.config/aerospace/aerospace.toml`](home/.config/aerospace/aerospace.toml), set up to behave as much like Omarchy/Hyprland as macOS allows.

**Workspaces are generic contexts, not app slots.** Nothing is assigned anywhere. An app opens on whichever workspace has focus and tiles into it, and you arrange work by moving windows. There is no rule that sends Slack to workspace 3. If you want it there, you put it there.

Workspaces exist only while they hold a window. There is deliberately no `persistent-workspaces` list, so `Ctrl` + `5` creates workspace 5 on demand and it disappears when you close its last window. A workspace you have emptied therefore stops existing, and `Ctrl` + its number is how you get back to it. It is recreated on arrival.

### Tiling

Windows tile. A second window in a workspace splits it rather than covering it, and `default-root-container-orientation = 'auto'` picks the axis from the container's shape: a wide container splits side by side, a tall one stacks. Nested splits alternate axis automatically (`enable-normalization-opposite-orientation-for-nested-containers`), the same instinct as Hyprland's dwindle: new windows land somewhere predictable with no manual split bookkeeping.

Gaps are 6px, uniform inside and out. AeroSpace has no animations, so there is nothing to disable for latency.

`Ctrl+Shift` + `/` collapses a workspace into an `accordion` stack and back, for when three windows tiled is two too many. Floating is the exception rather than the default: granted per app in the window rules, or per window with `Ctrl+Shift` + `t`.

**There is no focus indicator**, and that is a reluctant choice. AeroSpace draws nothing around the focused window. Its author left borders out on purpose.

Moving the cursor to each newly focused window (`on-focus-changed = ['move-mouse window-lazy-center']`) was tried and removed. It reacts to *every* focus change, including ones you did not ask for: a transient window that appears, takes focus and vanishes (an unarchiving progress dialog, say) drags the cursor across the screen and abandons it there. Worse than no indicator.

`on-focused-monitor-changed` is kept, because it fires only when the focused *display* changes, which no short-lived window on the current display can trigger.

`focus-follows-mouse` stays off deliberately: paired with a cursor-moving hook it forms a loop, the cursor landing on a window and that landing re-triggering focus.

For a real border, [JankyBorders](https://github.com/FelixKratz/JankyBorders) (`brew install felixkratz/formulae/borders`) is the usual companion, launched from `after-startup-command`. Not installed here, since it leans on private macOS APIs that major releases tend to break, but it is the only option that marks focus without reacting to focus.

### Navigation

**`Ctrl` is the modifier**, split by modifier depth. Each key keeps one job:

| Key | Belongs to |
|---|---|
| `Ctrl` + arrows/digits | Window navigation |
| `Ctrl+Shift` | Window manipulation |
| `Option` | Text navigation. Option+←/→ word jump is untouched |
| `Ctrl` + letter | Terminal. `ctrl-a`, `ctrl-c`, `ctrl-d`, `ctrl-r`, `ctrl-w` untouched |
| `Cmd` | macOS and app shortcuts |

Nothing binds a plain `Ctrl`+letter. Plain `Ctrl` is used *only* with arrows and digits, neither of which carries a control character, so the terminal keeps every readline and tmux binding it had.

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

`Ctrl+Shift` + `-` / `=` need at least two tiled windows in the workspace. With one there is nothing to resize against. `Ctrl+Shift` + arrows likewise refuses, non-zero, when the window is already at the edge of its container: it declines rather than wrapping.

Brackets take *you* to a workspace; `,` / `.` take the *window* there. Plain `Ctrl+[` is the ESC control character, which is why the cycling keys are bound only with Shift.

#### The macOS shortcuts this collides with

System Settings → Keyboard → Keyboard Shortcuts → **Mission Control** owns several `Ctrl` combinations, and system shortcuts win over app-registered ones. These must be off:

| Shortcut | Needed for |
|---|---|
| `Ctrl+←` / `Ctrl+→` (move a space) | focus left/right |
| `Ctrl+↑` (Mission Control) / `Ctrl+↓` (App windows) | focus up/down |
| **`Ctrl+Shift+←` / `Ctrl+Shift+→`** | move window left/right |
| `Ctrl+1`…`Ctrl+9` (Switch to Desktop N) | workspace switching |

The `Shift` variants of "Move left/right a space" are a separate pair of checkboxes from the plain ones and are easy to miss. They were still enabled here after the plain ones had been turned off.

#### Why not Option, Caps, or Hyper

Plain `Option` was the modifier first, and it cost `Option`+←/→ word navigation, which is used constantly. Caps Lock via a launcher's Hyper Key came next. Raycast was the launcher at the time, and its Hyper is fixed at `ctrl+alt+shift+cmd`, which consumes all four modifiers AeroSpace supports, so `Caps+Shift` was byte-identical to `Caps` and there was no second chord level, forcing moves into a toggled mode. `Ctrl` has neither problem: `Shift` is free, so move is a plain chord, and the terminal keeps its control characters because plain `Ctrl` is confined to arrows and digits. Tinycast is the launcher now and its hotkeys are freely assignable, but `Ctrl` has earned its place and there is no reason to revisit it.

### Window rules

Only windows that need behaviour they cannot get on their own have a rule. Nothing routes to a workspace, and there is no catch-all.

| App | Rule | Why |
|---|---|---|
| Slack | `layout tiling` | macOS reports a huddle as a utility panel, which AeroSpace auto-floats. This hands it back to tiling so a huddle sits beside the channel instead of on top of it. |
| MacWhisper | `layout tiling` | Auto-floated the same way, since macOS does not report its window as an ordinary resizable one, but it tiles fine when told to |
| System Settings | `layout floating` | Glanced at, not worked in |
| 1Password | `layout floating` | Same |
| Cap | `layout floating` | Recording overlay, a control rather than a window |
| krisp | `layout floating` | Mic widget, same |

The Slack rule deliberately does not match on the title. Slack sets the `Huddle:` title a moment *after* the window appears, so a `~= "^Huddle:"` pattern never matches at detection time. It works only when re-run afterwards, which is a good way to be fooled into thinking a rule is correct. Tiling every Slack window sidesteps the race.

**Dialogs are exempt without needing a rule.** macOS reports a file picker or alert as a panel and AeroSpace floats it, so a "Save as…" sheet never wedges itself into the tiling. When testing a rule, `open -a TextEdit` with no argument opens TextEdit's *Open* dialog, which floats, while `open -a TextEdit somefile.txt` opens a document window, which tiles.

`Ctrl+Shift` + `r` re-applies these rules to every open window. Since no rule moves anything between workspaces any more, its only job is picking up an app that was already running before its float rule existed.

### Restoring the layout

`restore-layout` is the one place a specific arrangement is written down:

```
1 Calendar   2 Slack   3 Herdr   4 Chrome Work   5 Chrome Me
```

```
restore-layout            reset to the plan
restore-layout --dry-run  report what it would do, change nothing
```

It is a **reset**, not a policy. Nothing enforces the arrangement continuously, so move a window afterwards and it stays moved. But every run ends in the same state regardless of what it started from:

- A window in the wrong place is **moved** to its workspace. All of them, not just the first, so three stray Chrome windows are gathered rather than one picked and the rest ignored.
- A missing app is **launched** on its workspace. With no routing rules, the script focuses the target workspace first and launches there. The window lands correctly because that is where you were, not because a rule dragged it.
- An app already in the right place is left untouched.

So the end state depends only on the plan, never on how far things had drifted. It never closes anything and never opens a second window of an app already up, which is what makes it safe to run repeatedly. The workspace numbers live in that script and nowhere else. There is no `aerospace.toml` rule backing them up.

Three details it depends on:

- **Chrome is launched per profile.** One process serves every profile, so activating the bundle ID cannot reach a specific one; the script passes `--profile-directory` (`Profile 1` for Work, `Default` for Me) with `open -n`. That is only safe because the window check already established the profile has no window. Renaming a Chrome profile breaks the title patterns it matches on.
- **It waits for each launched window before moving on.** The window has to exist before focus moves to the next workspace, or it would be born on the wrong one. Chrome also sets its profile suffix a moment after the window appears.
- **It flattens every workspace it added to.** Moving several windows in can leave nesting from the order they arrived, so without this two runs could produce the same windows in different shapes, the opposite of a reset.

VS Code is deliberately absent: launching it with no project gives an empty window, which is worse than an empty workspace.

### Turning it off

`Ctrl+Shift` + `e` disables AeroSpace: hidden workspaces come back on screen and key events stop being intercepted. Useful for screen sharing, or for an app that fights the window manager. Option, Ctrl and Cmd are untouched either way, so there is nothing to hand back.

It is one-way. While disabled the server rejects every command except `aerospace enable on`, and no binding fires, so the key cannot undo itself. Re-enable from the menu bar icon or that command.

### Seeing what is where

AeroSpace has no overview GUI (its tray icon shows only the active workspace) and it parks inactive windows off-screen rather than using native macOS Spaces, so Mission Control shows everything jumbled into one Space. Run `spaces`:

```
$ spaces
1  Calendar  Calendar
3  Slack     analysts (Channel) - dotCMS - Slack
3  krisp     Krisp Notification
5  Google Chrome  New Tab - Google Chrome - Freddy (dotcms.com)
```

It is a plain `aerospace list-windows` piped through `sort`, defined in [`home/.config/zsh/aliases.zsh`](home/.config/zsh/aliases.zsh). With generic workspaces there is nothing to label, so there is nothing to keep in sync.

### Monitors

Every workspace is pinned to the main display via `workspace-to-monitor-force-assignment`, so behaviour is identical on the MacBook screen alone and with an external monitor attached: everything follows whichever display macOS calls main (System Settings → Displays). That is what stops a workspace turning up on a monitor you did not expect.

The cost is that the non-main display holds nothing, so `alt` + arrows has no second monitor to cross into even though the bindings are set up for it (`--boundaries all-monitors-outer-frame`). Delete the whole block to let AeroSpace spread workspaces across both displays.

### Chrome and window titles

Nothing routes by title any more, but `restore-layout` still has to tell two Chrome profiles apart, and Chrome is the one app where that is possible. Once more than one profile is running it appends the profile name to every window title:

```
… - Google Chrome - Freddy              → the Default profile
… - Google Chrome - Freddy (dotcms.com) → Profile 1
```

Three things this depends on:

- **Anchor the pattern.** Bare `Freddy` is a prefix of `Freddy (dotcms.com)` and matches both profiles.
- **Renaming a Chrome profile silently breaks it.** The profile name is hardcoded.
- **With one profile running, Chrome drops the suffix entirely**, so neither pattern matches.

Other identifiers do not work for this: `window-id` is reassigned at runtime, and both profiles share one `app-pid` and one bundle path.

### Changing things

Adding an app to `restore-layout` is one edit: an entry in its `PLAN` array, plus a `launch()` case if it needs more than `open -b <bundle-id>`. Nothing else has to stay in sync.

Find a bundle ID with:

```bash
osascript -e 'id of app "Slack"'
```

Config reloads on save (`auto-reload-config = true`). To check it before trusting it:

```bash
aerospace reload-config --dry-run
```

Reloading does not re-apply rules to windows that are already open. A rule only fires when a window is first detected. Rather than restarting AeroSpace, apply it retroactively:

```bash
aerospace run-callback --for-every-window on-window-detected   # re-apply to everything
aerospace run-callback --window-id <id> on-window-detected     # test one rule
```

The second form is the way to check a rule against a live window; it forwards the output of every command in the callback.

AeroSpace needs Accessibility access (System Settings → Privacy & Security → Accessibility) before it can move any windows.

## Fresh

[Fresh](https://getfresh.dev/) is the terminal editor used for code editing and browsing. Launch with `fresh .` from any project.

fresh ships a macOS keymap built on `Cmd`, but it drops the super modifier when decoding CSI-u, so none of those bindings can fire inside a terminal. The keymap is therefore `vscode`, not `macos`. The `macos` map is where all 38 of those dead `Cmd` bindings live, while `vscode` is built on `Ctrl` and works in full: `⌃D` add cursor at next match, `⌃⌥↑/↓` add cursor above/below, `⌃⇧K` delete line, `⌃L` select line, `⌥↑/↓` move line.

That one structural fact — Fresh cannot see a `Cmd` chord — is what the rest of the keyboard setup is built around. It leaves the whole of `cmd+*` to herdr.app, permanently, no matter what either program adds in a later release. [Terminal](#terminal) has the whole layer map.

herdr.app keeps five rewrites for Fresh's benefit, in the `terminal` section of [`home/.config/herdr-app/keys.json`](home/.config/herdr-app/keys.json). `Cmd+←/→` and `Cmd+⇧←/→` become Home/End and their shifted pair, because the `\u0001`/`\u0005` it sends by default are `⌃A` and `⌃E`, which the vscode map spends on `select_all` and `focus_file_explorer` — so `Cmd+←` used to select the whole buffer and `Cmd+→` threw focus into the file tree. `Cmd+K` becomes F14 so the shell can clear its own scrollback. Everything else Fresh gets raw.

`editor.menu_bar_mnemonics: false` in [`home/.config/fresh/config.json`](home/.config/fresh/config.json) is what makes `⌥←/→` word motion work. herdr.app sends `esc b`/`esc f` for opt+arrows, which Fresh decodes as `alt+b`/`alt+f` — and `alt+f` is bound **twice** in the vscode map, to `menu_open` and to `move_word_right`. The mnemonic won, so `⌥→` opened the File menu. Turning mnemonics off leaves the motion. The menu bar is still there and still clickable; only the Alt-letter shortcuts into it are gone. This replaced four custom `alt+arrow` overrides, and the config now carries no keybindings of its own at all.

`Cmd+C` is herdr.app's `terminal.copy`. Selecting already copies, so dragging a selection lands it on the clipboard either way.

### Keys

From Fresh's own **Show Keyboard Shortcuts** (`Ctrl+P`, then run it) with this keymap.

| Editing | |
|---|---|
| `⌃C` `⌃X` `⌃V` `⌃Z` `⌃Y` | Copy, cut, paste, undo, redo |
| `⌃A` `⌃L` | Select all, select line |
| `⌃⇧K` / `⌃K` | Delete line / to end of line |
| `⌥↑` `⌥↓` | Move line up / down |
| `⌥U` `⌥L` | Upper / lowercase |

| Multi-cursor | |
|---|---|
| `⌃D` | Add cursor at next match |
| `⌃⌥↑` `⌃⌥↓` | Add cursor above / below |
| `⌥⇧I` | Cursors to line ends |
| `⌥⇧↑` `⌥⇧↓` | Block select |
| `Esc` | Drop secondary cursors |

| Moving | |
|---|---|
| `⌥←→` `⌃←→` | Word motion, either modifier |
| `Home` `End` | Line start / end. `Cmd+←/→` arrives as these |
| `⌃Home` `⌃End` | Document start / end |
| `⌃G` | Go to line |

| Finding | |
|---|---|
| `⌥/` | Live grep across files |
| `⌥R` | Resume live grep |
| `⌃F` `⌃R` | Find, replace in buffer |
| `F3` `⇧F3` | Next / previous match |
| `⌃⌥R` | Interactive replace, y/n/!/q per match |

| LSP | |
|---|---|
| `F12` `⇧F12` `⌃F12` | Definition, references, implementation |
| `F2` | Rename symbol |
| `⌥.` `⌥K` | Code actions, hover docs |
| `⌃Space` | Completion |
| `F8` `⇧F8` | Next / previous diagnostic |

| Files and panes | |
|---|---|
| `⌃O` `⌃S` `⌃N` `⌃Q` | Open, save, new, quit |
| `⌃P` | Command palette and file picker |
| `⌃E` | Focus file explorer |
| `⌃PgUp` `⌃PgDn` | Previous / next buffer |
| `⌥W` | Close tab |
| `⌥\`` | Terminal in the utility dock |
| `⌥\|` | Run a shell command on the buffer or selection |

`⌥1`–`⌥9` (bookmarks) and `⌥[` / `⌥]` (splits) work. herdr keeps tab and workspace switching on the prefix and on `cmd+alt`, so nothing takes those chords first.

Fresh runs as a **persistent daemon per workspace**, not a process per window, so closing a tab reattaches to the same process rather than starting a new one — a config or plugin change does not take effect until that daemon dies. They show up in `ps` as plain `fresh <path>` and can outlive a reboot-free week. `fresh --cmd daemon kill <name>` prints the name and then hangs rather than returning, so `pkill fresh` is the way to restart them.

## Terminal

[herdr.app](https://herdr.dev/) is the terminal. Not a multiplexer inside one — the app draws its own terminals, spaces, tabs and panes, and there is no emulator under it.

This replaced a two-program stack. herdr ships as **two separate products**: the **TUI**, a multiplexer that ran inside a terminal emulator and was configured by `~/.config/herdr/config.toml`, and the **app**, a native window that runs terminals through a background server called herdr-core. They share a name and nothing else — not agents, not config format, not a plugin API. Ghostty hosted the TUI; both are gone, and [`docs/herdr-tui-archive.md`](docs/herdr-tui-archive.md) keeps their config verbatim.

Collapsing to one program also collapsed the keyboard problem. Four programs used to want the same modifiers, and keeping them apart was a running audit: add a binding, find what it broke, move it. Now:

| Layer | Owns |
|---|---|
| AeroSpace | `ctrl+arrows`, `ctrl+digits`, `ctrl+shift+*` |
| Fresh | `ctrl+letter`, `alt+letter`, `ctrl+alt+*` |
| herdr.app | all of `cmd+*`, including `cmd+alt+*` |
| Tinycast | Caps Lock, as a `⌃⌥⇧⌘` hyper key |

That holds by construction, not by vigilance. Fresh drops the super modifier when decoding CSI-u, so it cannot receive a `cmd` chord **at all** — which means nothing herdr puts on `cmd` can ever shadow a Fresh binding, whatever Fresh adds later. With Ghostty gone there is no longer a second program competing for `cmd`, so herdr.app takes the whole modifier rather than the `cmd+alt` corner of it.

`keys` prints this map and every chord under it at any prompt. `keys herdr` narrows to one layer; `keys cmd+alt` searches all of them.

### Config

`~/.config/herdr-app/` **is** the app's interface, as files. It redraws from them within a second of a change, and if a file is invalid it keeps the last good version and writes why to `<name>.error`. Two files are the person's and are tracked here:

- [`home/.config/herdr-app/keys.json`](home/.config/herdr-app/keys.json) — what every key does
- [`home/.config/herdr-app/settings.json`](home/.config/herdr-app/settings.json) — zoom and sounds

Everything else in that folder is the app's: `layouts/`, `mods/`, `themes/`, `icons/`, plus bookkeeping it rewrites on every start. Those are deliberately **not** tracked, because the app owns them and rewrites them in place.

`AGENTS.md` in that folder is the real reference — 900-odd lines, regenerated on every start so it matches the installed version, and more accurate than the website. It documents the command list, the layout format, and the mod API (mods are JavaScript against GPUI, not HTML). `herdr-app commands` prints every command with its arguments.

**`ctrl-alt-shift-escape` is the escape hatch.** It sets the layout and `keys.json` aside as `*.reset-<time>` and returns to the default layout. Nothing can rebind it, which makes a broken keymap recoverable without a terminal.

### Keys

The app's shipped keymap is kept as it is, with two exceptions below. `⌘⇧P` opens the command palette, which lists every command with its key, so the full list never needs writing down.

| Key | Does |
|---|---|
| `⌘T` / `⌘W` | New / close tab |
| `⌘1`…`9` | Select tab |
| `⌘⇧[` / `⌘⇧]` | Previous / next tab |
| `⌘N` | New space |
| `⌘⌥[` / `⌘⌥]` | Previous / next space |
| `⌘D` / `⌘⇧D` | Split right / down |
| `⌘⇧W` / `⌘⇧⏎` | Close / zoom pane |
| `⌘⌥` + arrows | Focus pane |
| `⌘⌥⇧` + arrows | Swap pane |
| `⌘[` / `⌘]` | Previous / next agent |
| `⌘B` / `⌘P` / `⌘⇧P` | Sidebar, picker, command palette |
| `F2` / `⇧F2` | Rename tab / space |

**`ctrl-1`…`ctrl-9` were removed.** The app ships them as `space.select:1`…`9`, but AeroSpace registers `Ctrl`+digits as system hotkeys and wins before herdr sees the key, so they were bindings that could never fire. Spaces are reachable on `⌘⌥[` / `⌘⌥]` and through the picker.

**Five `terminal` bindings send escape sequences** instead of running a command, which is the same job Ghostty's `keybind = cmd+left=csi:H` used to do:

```json
"terminal": {
  "cmd-k":           "send:\u001b[26~",
  "cmd-left":        "send:\u001b[H",
  "cmd-right":       "send:\u001b[F",
  "cmd-shift-left":  "send:\u001b[1;2H",
  "cmd-shift-right": "send:\u001b[1;2F"
}
```

The app's defaults sent `\u0001` and `\u0005` for `cmd+←/→` — the readline line-start/end convention, and byte-for-byte `⌃A` and `⌃E`, which Fresh's vscode keymap spends on `select_all` and `focus_file_explorer`. So `⌘←` selected the whole buffer and `⌘→` threw focus into the file tree. Home/End are what Fresh wants: it binds Home to `smart_home`, End to `move_line_end`, and the shifted pair to `select_line_start`/`end`. `⌘K` becomes F14 because only the shell can clear its own scrollback — see the widget in [`.zshrc`](home/.zshrc), which needs `bindkey` lines for all of these.

`⌥←/→` and `⌥⌫` are left as the app ships them, sending `esc b` / `esc f` / `⌃W`. Fresh reads the first two as `alt+b`/`alt+f`, and `menu_bar_mnemonics: false` is what stops `alt+f` opening the File menu instead of moving a word.

### What the herdr TUI took with it

The TUI had a plugin API and a CLI (`herdr pane`, `herdr workspace report-metadata`, `herdr notification show`). herdr.app has neither, so everything built on them is **dead code, still tracked**:

| Orphaned | Was |
|---|---|
| [`home/.local/bin/editor`](home/.local/bin/editor) | Toggled a Fresh tab at the git root |
| [`home/.local/bin/annotate`](home/.local/bin/annotate) | Toggled a plannotator-tui tab |
| [`home/.local/bin/pr-open`](home/.local/bin/pr-open) | Opened the focused workspace's PR |
| [`home/.local/bin/herdr-pane`](home/.local/bin/herdr-pane) | Reported the focused pane's workspace and cwd |
| [`home/.local/bin/label-agents`](home/.local/bin/label-agents) | Summarised each agent's task into a sidebar label |
| [`home/.local/bin/pr-watch`](home/.local/bin/pr-watch) | Polled each workspace's PR into the sidebar |
| [`herdr-plugins/`](herdr-plugins/) | `pr-refresh` and `agent-labels`, TUI plugins |

The pr-watch LaunchAgent is unloaded and `07-post-install.sh` no longer installs it, so nothing runs on a timer and fails. The plugins that came from other people — annotate, reviewr, automatic-rename — are not installed any more either; herdr.app has its own mods, which are a different thing entirely.

Porting any of these means writing a herdr.app **mod**, or calling `herdr-app do <command>` from a script. `terminal.open {argv, folder, place, name}` covers most of what `editor` and `annotate` did.

## Warp

Warp is still installed but no longer the daily terminal. It has no AeroSpace slot and lands in overflow. Its config is tracked anyway, because rebuilding those agent permission lists by hand would be miserable:

- [`home/.warp/settings.toml`](home/.warp/settings.toml): agent execution profiles and command denylist, the secret-redaction regexes, appearance, the `Ctrl+'` dedicated-window hotkey
- [`home/.warp/tab_configs/startup_config.toml`](home/.warp/tab_configs/startup_config.toml): what a new tab opens with

`~/.warp/remote-server/` is deliberately left alone: it is a 300 MB bundled binary plus SQLite state, not config. `is_settings_sync_enabled = true` means Warp also syncs settings to its own account, so the cloud copy can win. If a setting mysteriously reverts, that is why.

## Tinycast

[Tinycast](https://github.com/abue-ammar/tinycast) is the launcher, and it also owns the Caps Lock hyper key. Its settings live in a cfprefsd-managed plist, which cannot be symlinked (the app rewrites it from memory) so they are exported into the repo instead:

```bash
./scripts/tinycast-export.sh   # after changing hotkeys, aliases, or custom commands
```

A `pre-commit` hook in [`.githooks/`](.githooks/) runs that for you and stages the result, so hotkey changes travel without being remembered. It never blocks a commit. On a machine with no Tinycast the export bails and the tracked copy is left alone. `install.sh` points `core.hooksPath` at the directory; in an existing clone, run `git config core.hooksPath .githooks` once.

`07-post-install.sh` imports the result with `defaults import` on a new machine, before Tinycast first launches. Window positions, file bookmarks, and calendar UUIDs are stripped on export; hotkeys, launcher aliases, custom commands, and the hyper key travel.

## CLI tools

Standalone commands live in [`home/.local/bin/`](home/.local/bin/) and are symlinked onto `PATH` by `03-symlinks.sh`. Run `tools` to see what is installed:

```
$ tools
Tools (~/.dotfiles/home/.local/bin)
  aliases            show the shell aliases and functions this machine defines.
  dotfiles           open the dotfiles repo in a new editor window.
  gcleanbranches     delete local branches whose remote is gone.
  keys               show the keyboard cheatsheet for this machine.
  ...
Also on PATH here, installed elsewhere: claude herdr-reviewr test-sdk yellit
```

`tools` resolves each symlink and only claims the ones pointing into this repo, so anything a native installer drops into `~/.local/bin` is listed separately rather than mixed in.

### Adding one

```bash
new-tool my-thing "what it does"
```

That writes the script, makes it executable, and symlinks it so it works immediately, with no installer re-run. The convention it scaffolds:

- `#!/usr/bin/env bash` and `set -euo pipefail`
- line 3 is `# <name> — <one-line description>`, which is what `tools` reads, so documenting a tool and registering it are the same act
- `--help` prints the header block

### What stays a shell function

A script runs in a child process, so anything that has to change the *calling* shell cannot be a tool. That is `proj` (it `cd`s) and `zreload` (it sources `.zshrc`). Plain aliases stay too. `gs` as a script would be slower and lose completion.

### When a tool outgrows this

Small, personal, bash, machine-shaped tools belong here. A tool that needs dependencies, a build step, tests, or its own versioning, or that someone else would install on its own, gets its own repo and a real distribution channel, then comes back as a line in the `Brewfile` or the npm list in `07-post-install.sh`. That is how `chai` and `yellit` already work.

## AI

All AI agent config lives in [`ai/`](ai/) as a single source of truth:

- [`ai/instructions/`](ai/instructions/): shared instructions (`AGENTS.md`)
- [`ai/skills/`](ai/skills/): [agent skills](https://docs.claude.com/en/docs/claude-code/skills) (one folder per skill)

### Syncing with chai

I author the config once and let [**chai**](https://github.com/charliesbot/chai) distribute it to every agent platform (Claude, Codex, Droid, OpenCode, and Antigravity) instead of hand-maintaining each one's config files. The manifest lives in [`home/chai.toml`](home/chai.toml) (symlinked to `~/chai.toml`).

`install.sh` runs `chai update && chai sync` for you, so a fresh machine is ready with no extra steps. Afterwards, the loop for changes is:

```bash
# 1. Edit the source of truth
$EDITOR ai/instructions/AGENTS.md      # or add a skill under ai/

# 2. Distribute to every platform listed in chai.toml
chai update   # clone/pull any external deps first (skills from other repos, etc.)
chai sync     # copy instructions and skills into each platform's config dir
```

`chai sync` uses hash-based dirty detection: if an agent edited its copy, it prompts before overwriting. Add `--dry-run` to preview changes or `--force` to skip the dirty check. Because `ai/` is the only place you edit, every machine and every agent stays in sync from one commit.

Skills can also come from other people's repos. Declare them under `[deps]` in `chai.toml`. `chai update` clones each to `~/.chai/deps/`, and `[skills]` paths reference them with `@name`. Current external skills: [impeccable](https://github.com/pbakaus/impeccable), [frontend-slides](https://github.com/zarazhangrui/frontend-slides), and [dev-browser](https://github.com/sawyerhood/dev-browser).

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
├── docs/                     # Reference notes, including the keybinding archive
├── .githooks/                # pre-commit: re-exports Tinycast settings
├── ai/                       # AI tooling
│   ├── skills/               # Agent skills (any agentic harness)
│   ├── instructions/         # Reusable prompt instructions
└── home/                     # Dotfiles (mirrored to ~/)
    ├── .zshrc
    ├── .gitconfig
    ├── chai.toml             # AI config sync manifest (~/chai.toml)
    ├── .local/bin/          # Standalone commands, run `tools` to list them
    │   ├── keys              # Keyboard cheatsheet across all four layers
    │   ├── new-tool          # Scaffold a new one
    │   ├── restore-layout    # Reset apps onto workspaces 1-5
    │   └── tools             # List what is installed
    ├── .warp/
    │   ├── settings.toml     # Agent profiles, redaction, appearance
    │   └── tab_configs/      # What a new tab opens with
    └── .config/
        ├── aerospace/
        │   └── aerospace.toml # Tiling, window rules, keys
        ├── fresh/
        │   └── config.json   # Editor keybindings
        ├── herdr-app/
        │   ├── keys.json     # What every key does
        │   └── settings.json # Zoom and sounds
        ├── tinycast/
        │   └── com.tinycast.app.plist  # Exported, imported by post-install
        ├── zsh/
        │   └── aliases.zsh   # Git + misc aliases
        └── starship.toml     # Starship prompt config
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/.dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
