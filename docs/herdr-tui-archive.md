# herdr TUI and Ghostty archive

Removed on 2026-10-29, when the terminal stack collapsed from two programs to one. Ghostty was uninstalled and the herdr TUI went with it; [herdr.app](https://herdr.dev/) replaced both. Nothing here is loaded by anything — it is a paste-back copy, kept with the comments that explain why each line existed.

## What replaced what

herdr shipped as two separate programs. The **TUI** was a terminal multiplexer that ran *inside* a terminal emulator, configured by `~/.config/herdr/config.toml`. The **app** is a native window that runs its own terminals through herdr-core, configured by `~/.config/herdr-app/`. They do not share agents, config format, or a plugin API, so this is a replacement rather than an upgrade — none of the config below carries across.

| Was | Is now |
|---|---|
| Ghostty window + herdr TUI inside it | herdr.app, one program |
| `~/.config/ghostty/config` (6 keybinds) | `~/.config/herdr-app/keys.json`, `terminal` section |
| `~/.config/herdr/config.toml` `[keys]` | `~/.config/herdr-app/keys.json`, `global` section |
| `[[keys.command]]` shell commands | not ported — see the orphaned tools in the README |
| herdr TUI plugins (annotate, reviewr, pr-refresh, automatic-rename) | no equivalent installed; herdr.app has its own mods |

The one piece of config that had to survive verbatim is the escape-sequence rewriting. Ghostty did it with `keybind = cmd+left=csi:H`; herdr.app does the same thing with `"cmd-left": "send:\u001b[H"` in the `terminal` section of `keys.json`. Both exist for the same reason: Fresh's vscode keymap spends `ctrl+a` on `select_all` and `ctrl+e` on `focus_file_explorer`, and `\x01`/`\x05` are exactly those two control characters.

## Ghostty — `home/.config/ghostty/config`

```
shell-integration = none
# left option = alt (opt+backspace deletes a word)
# right option stays free for composing accented characters
macos-option-as-alt = left

# The title bar stays, but it has to disappear into the window. Ghostty's
# default background is #282c34 while herdr paints catppuccin base, and a
# transparent titlebar takes Ghostty's colour — which is why the bar read as a
# lighter grey strip above everything.
background = #1e1e2e

# No folder proxy icon; herdr already says where it is.
macos-titlebar-proxy-icon = hidden

# Both zero. The top was 20 back when the title bar was hidden and content sat
# flush against the top edge; with the bar visible that padding was only an
# empty band. The second value is the bottom, and 20 there just left an empty
# strip under herdr's status bar.
window-padding-y = 0,0

# Cmd+W is Ghostty's close_surface again, and the surface it closes is the one
# herdr is running in. `true` decides whether to prompt from what shell
# integration reports about a running process, and shell-integration is none
# here, so it may not prompt at all. `always` prompts regardless. Closing it is
# survivable — herdr is a server, `herdr` reattaches and the panes kept
# running — but the prompt is cheaper than the reattach.
confirm-close-surface = always

# Ghostty's cmd+k is clear_screen, which clears Ghostty's own grid and scrollback
# — and inside herdr that is a frame buffer herdr repaints a moment later. The
# scrollback that matters lives in herdr's pane, which Ghostty cannot reach. So
# send F14 and let the shell do the clearing: herdr's emulator honours ESC[3J, so
# the scrollback goes with the screen. See the widget in .zshrc. Cost: in a pane
# that is not a shell — an agent, Fresh — cmd+k does nothing, as it did before.
keybind = cmd+k=csi:26~

# Ghostty sends \x01 and \x05 for cmd+left/right — the readline line-start/end
# convention — and Fresh's vscode keymap spends ctrl+a on select_all and ctrl+e
# on focus_file_explorer. So cmd+left selected the buffer and cmd+right threw
# focus into the file tree, neither of which moves a cursor. Home/End are what
# Fresh wants: it binds Home to smart_home, End to move_line_end, and the shifted
# pair to select_line_start/end. The shell needs bindkey lines for them, in .zshrc.
keybind = cmd+left=csi:H
keybind = cmd+right=csi:F
keybind = cmd+shift+left=csi:1;2H
keybind = cmd+shift+right=csi:1;2F

# herdr's direct layer lives on cmd+alt, because Fresh drops the super modifier
# in CSI-u and so can never collide with it. Ghostty's own cmd+alt defaults are
# few and none are load-bearing here; only the inspector sits on a chord herdr
# wants (focus_pane_up). The others — cmd+alt+w, cmd+alt+shift+w/j and
# cmd+alt+arrows — are left alone, since herdr claims none of them.
keybind = cmd+alt+i=unbind
```

## herdr TUI — `home/.config/herdr/config.toml`

```toml
onboarding = false

[update]
# herdr is installed with Homebrew now, so its self-updater would fetch its own
# build into ~/.local/bin and shadow the brew binary on PATH. Upgrade with
# `brew upgrade herdr` instead of `herdr update`.
version_check = false

# Layered on the default catppuccin base
[theme.custom]
sidebar_bg    = "reset"     # no panel of its own - takes the terminal background
panel_bg      = "reset"     # same, so borders are the only thing dividing regions
active_row_bg = "#313244"   # surface0 - the focused space reads as selected
accent        = "#cba6f7"   # mauve - the active tab and highlights read lavender

[ui]
status_indicators = "symbols"
hide_tab_bar_when_single_tab = true

# Frame every pane, not only splits, and keep the outside edge of the pane
# area. With sidebar_bg at base there is no colour change left to separate the
# sidebar from the panes, so the outer border is what draws that line.
pane_borders = "always"
pane_outer_borders = true

# No scrollbar column beside panes. It is a vertical line the borders already
# imply, and dropping it keeps the column out of terminal-native selections.
pane_scrollbars = false

# What the titlebar says. The default is "{hostname}: {workspace}", and the
# hostname is the one thing on screen that never changes and never matters.
window_title = "{workspace} › {tab}"
show_agent_labels_on_pane_borders = true

# `prefix c` opens a tab immediately instead of asking for a name first. Tabs
# get a generated name, and rename is there via the right-click menu if one
# earns it.
prompt_new_tab_name = false

# Order the agent list by attention rather than by position, so the rows climb
# as agents start wanting something. This is also the order next_agent and
# previous_agent step through, which is the point: stepping follows whoever
# needs answering rather than wherever they happen to sit. The alternative is
# "spaces", grouped by space, which is herdr's default.
agent_panel_sort = "priority"

[ui.toast]
delivery = "terminal"

# Separate space entries by weight, not blank rows
[ui.sidebar.agents]
row_gap = 1
# The task gets its own row, full width. Beside the workspace name it had
# maybe a dozen columns left and every label ended in an ellipsis, which
# defeats the point of summarising it in the first place.
#
# The `agent` token renders the reported agent display name, which the
# label-agents tool sets to the agent's own task shortened to three words. It
# is herdr's own field rather than a custom token, so the pane border labels
# show the same thing, and an agent that has not been labelled yet falls back
# to "claude" instead of an empty row.
#
# terminal_title_stripped is not here: it is what the label is made from, so
# showing both was the same sentence twice, both halves cut off.
#
# $remote is set only for agents on another machine, which is the closest the
# sidebar gets to a conditional: the builtin `machine` token would print
# "Local" on every local row. It sits with the workspace because it is part of
# where the agent is, not part of what it is doing.
rows = [
  [{ token = "state_icon" }, { token = "workspace", bold = true }, { token = "$remote", fg = "#7f849c" }],
  [{ token = "agent", fg = "#cba6f7" }],
]

[ui.sidebar.spaces]
row_gap = 1
# Explicit catppuccin greys rather than dim: dim multiplies the theme's own
# muted colour and the second and third rows came out barely legible.
rows = [
  [{ token = "state_icon" }, { token = "workspace", bold = true }],
  [{ token = "branch", fg = "#7f849c" }, { token = "git_status", fg = "#7f849c" }],
  # Reported by the pr-watch LaunchAgent. One word, coloured by severity, so
  # there is no legend: red is your problem, yellow is waiting on someone else,
  # green means it can merge. Only the matching token is ever set.
  [
    { token = "$pr", fg = "#7f849c" },
    { token = "$pr_blocked", fg = "#f38ba8" },
    { token = "$pr_waiting", fg = "#f9e2af" },
    { token = "$pr_ready",   fg = "#a6e3a1" },
  ],
]

# File explorer and editing: the Fresh editor in a tab, toggled by the
# `sidebar` tool. This replaced the herdr-sidebar plugin, whose viewer was
# read-only and handed off to an editor anyway.
#
[keys]

# Two chords per action: the prefix, which works everywhere including over SSH,
# and a direct cmd+alt chord for the ones used constantly. herdr takes an array
# per action, so neither has to win. The prefix half is also the fallback that
# survives SSH, where a cmd chord may not arrive at all.
#
# The direct chords are a flattened map of the prefix ones rather than a copy.
# The direct layer is cmd+alt, and that choice is structural rather than a taste.
# Fresh drops the super modifier when decoding CSI-u, so it cannot receive a cmd
# chord at all — which means nothing here can ever shadow a Fresh binding, no
# matter what Fresh adds in a future release. ctrl+alt was the old home and it
# shared a modifier with Fresh's own keymap: pane focus on ctrl+alt+arrows ate
# add_cursor_above/below, and ctrl+alt+r was unreachable behind lsp_rename.
# AeroSpace is on ctrl and ctrl+shift, so it is clear of this too.
#
# Pane focus is the ijkl inverted-T; the prefix half keeps herdr's vim letters.
# Splits are on s, not the d/shift+d that matches their shape, because cmd+alt+d
# is a live macOS system hotkey (Dock show/hide, symbolichotkey 52) and macOS
# takes it before Ghostty ever sees it. cmd+alt+i needs one unbind in Ghostty,
# which spends it on inspector:toggle.
focus_pane_left  = ["prefix+h", "cmd+alt+j"]
focus_pane_down  = ["prefix+j", "cmd+alt+k"]
focus_pane_up    = ["prefix+k", "cmd+alt+i"]
focus_pane_right = ["prefix+l", "cmd+alt+l"]
previous_tab     = ["prefix+p", "cmd+alt+["]
next_tab         = ["prefix+n", "cmd+alt+]"]
new_tab          = ["prefix+c", "cmd+alt+c"]
split_vertical   = ["prefix+v", "cmd+alt+s"]
split_horizontal = ["prefix+minus", "cmd+alt+shift+s"]
zoom             = ["prefix+z", "cmd+alt+z"]

# Step through agents. herdr ships these unbound. On n/p for next/previous, since
# pane focus took the ijkl block; Fresh binds neither, and herdr's own p/n for
# tabs is behind the prefix, so the two never meet on the same chord.
# The order is agent_panel_sort, which is "priority" here, so next is whoever
# wants something rather than whoever is below.
next_agent       = ["prefix+shift+j", "cmd+alt+n"]
previous_agent   = ["prefix+shift+k", "cmd+alt+p"]

# These four sit on cmd+alt with the rest of the direct layer, for the same
# reason: Fresh cannot see a cmd chord, so they are safe from its keymap by
# construction. The prefix was not an option for them — prefix+e, prefix+o and
# prefix+l are herdr's own edit_scrollback, open_notification_target and
# focus_pane_right.
#
# There is no cmd+p here any more. The plugin's quick-open was a file picker
# of its own; Fresh has one built in, on ctrl+p.
[[keys.command]]
key = "cmd+alt+e"
type = "shell"
command = "editor"

# Annotate. Ctrl+clicking a Markdown path also opens it — the plugin registers
# a link handler for ^file://.*\.(md|markdown|mdx)$ — but that only reaches a
# file you can see. This opens the review UI over the focused pane's folder.
[[keys.command]]
key = "cmd+alt+a"
type = "shell"
command = "annotate"

# Code review: diffs with line and range comments, a changed-file browser, and
# a read-only mirror of the branch's PR. Toggle, so the same key puts it away.
# On cmd+alt+shift+l, keeping the l of the original cmd+l: plain cmd+alt+l is
# focus_pane_right in the ijkl block, so reviewr takes the shift variant.
[[keys.command]]
key = "cmd+alt+shift+l"
type = "shell"
command = "herdr plugin action invoke toggle --plugin persiyanov.reviewr"

# Open the focused workspace's PR in the browser. The sidebar shows its number
# but cannot make it clickable — workspace metadata is display-only, and
# clicking the row switches workspace.
[[keys.command]]
key = "cmd+alt+o"
type = "shell"
command = "pr-open"
```
