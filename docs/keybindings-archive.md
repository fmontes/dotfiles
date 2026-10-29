# Keyboard shortcut archive

Every keyboard binding that used to live in the Ghostty, herdr, and zsh configs, removed on 2026-09-25 to go back to stock key handling. Nothing here is loaded by anything — it is a paste-back copy, kept verbatim with the comments that explain why each line existed.

The three sets were one system: Ghostty unbound its own chords so herdr could see them, rewrote a few into CSI sequences that Fresh and zsh understand, and zsh bound the receiving end. Putting back one part without the others will not work — Ghostty's unbinds are what let herdr's `[keys]` fire at all, and zsh's `bindkey` lines are dead without Ghostty's rewrites.

> **Both programs here are gone.** Ghostty was uninstalled and the herdr TUI went with it on 2026-10-29, replaced by [herdr.app](https://herdr.dev/). This file is now an archive of an archive: it records the keymap as it stood in September 2026, one revision before the final Ghostty and TUI configs, which [`herdr-tui-archive.md`](herdr-tui-archive.md) keeps. Nothing here can be pasted back into a program that still exists.

herdr's `[[keys.command]]` blocks — editor, annotate, reviewr, pr-open — were left in place when this was written and were live in `home/.config/herdr/config.toml` on `cmd+e`, `cmd+alt+a`, `cmd+l` and `cmd+shift+o`. The direct layer later moved to `cmd+alt`, and then the whole file went.

## Ghostty — `home/.config/ghostty/config`

```
# Ghostty rewrites opt+arrows into esc:b / esc:f — the old readline word-motion
# convention. Fresh reads esc+f as alt+f, which is its File menu mnemonic, so
# opt+right opened a menu instead of moving a word. Unbound, the real
# ESC[1;3C/D arrives and Fresh's own alt+arrow word bindings fire. The shell
# needs bindkey lines for those sequences — see .zshrc.
keybind = alt+arrow_left=unbind
keybind = alt+arrow_right=unbind

# Herdr owns tabs/panes/layout.
# Ghostty should pass these through instead of handling them.

# Tabs
keybind = cmd+t=unbind
keybind = cmd+w=unbind

# Splits
keybind = cmd+d=unbind
keybind = cmd+shift+d=unbind

# Tab switching
keybind = cmd+1=unbind
keybind = cmd+2=unbind
keybind = cmd+3=unbind
keybind = cmd+4=unbind
keybind = cmd+5=unbind
keybind = cmd+6=unbind
keybind = cmd+7=unbind
keybind = cmd+8=unbind
keybind = cmd+9=unbind

# Previous / next tab
keybind = cmd+[=unbind
keybind = cmd+]=unbind

# Zoom pane
keybind = cmd+shift+enter=unbind

# Toggle the Fresh editor tab (Ghostty binds this to search_selection)
keybind = cmd+e=unbind

# Pane movement (Ghostty binds these to prev/next tab by default)
keybind = cmd+alt+left=unbind
keybind = cmd+alt+right=unbind

# Up/down go to Fresh instead, as multi-cursor. Ghostty's goto_split default
# was swallowing them, so herdr's focus_pane_up/down never fired either — the
# chord did nothing at all. Fresh puts add-cursor-above/below on ctrl+alt,
# VS Code on macOS puts it on cmd+alt, and Fresh cannot see a cmd chord, so
# rewrite one into the other.
keybind = cmd+alt+up=csi:1;7A
keybind = cmd+alt+down=csi:1;7B

# Same story for cmd+left/right. Ghostty sends \x01 and \x05 — the readline
# line-start/end convention — and in Fresh's vscode keymap ctrl+a is Select All
# and ctrl+e is Focus File Explorer, so the cursor never moved and the focus
# jumped to the tree. Home/End are what Fresh wants; the shell needs bindkey
# lines for them, see .zshrc.
keybind = cmd+left=csi:H
keybind = cmd+right=csi:F
keybind = cmd+shift+left=csi:1;2H
keybind = cmd+shift+right=csi:1;2F

# Previous / next space
keybind = cmd+shift+[=unbind
keybind = cmd+shift+]=unbind

# fresh ignores the super modifier in CSI-u, so its whole macOS keymap is dead
# in a terminal. Translate cmd+c into F13, which fresh binds to copy and every
# other pane ignores. Ctrl+Shift+C would have worked too, but it degrades to
# ^C (SIGINT) in panes that do not speak the Kitty keyboard protocol.
# Cost: Ghostty's and herdr's own cmd+c selection copy. Both copy on select anyway.
keybind = cmd+c=csi:25~

# Ghostty's cmd+k is clear_screen, which clears Ghostty's own grid and
# scrollback — and inside herdr that is a frame buffer herdr repaints a
# moment later. The scrollback that matters lives in herdr's pane, which
# Ghostty cannot reach. So send F14 and let the shell do the clearing: herdr's
# emulator honours ESC[3J, so the scrollback goes with the screen. See the
# widget in .zshrc. Cost: in a pane that is not a shell — an agent, Fresh —
# cmd+k does nothing, which is what it did before.
keybind = cmd+k=csi:26~
```

## herdr — `home/.config/herdr/config.toml`

```toml
[keys]

# Warp-style tabs
new_tab      = "cmd+t"
close_tab    = ""   # unbound - close tabs via right-click menu
previous_tab = "alt+["
next_tab     = "alt+]"
switch_tab   = "alt+1..9"   # left option only — right option composes

# Spaces
switch_workspace   = "alt+shift+1..9"
previous_workspace = "alt+shift+["
next_workspace     = "alt+shift+]"

# Warp-style splits
split_vertical   = "cmd+d"
split_horizontal = "cmd+shift+d"

# Pane movement
focus_pane_left  = "cmd+alt+left"
focus_pane_right = "cmd+alt+right"
# Up/down belong to Fresh's multi-cursor now — Ghostty rewrites cmd+alt+up/down
# into ctrl+alt+up/down before herdr sees them. These never worked anyway:
# Ghostty's goto_split default was swallowing the chord. On the prefix instead.
focus_pane_down  = "prefix+j"
focus_pane_up    = "prefix+k"

# Pane controls
zoom = "cmd+shift+enter"

# herdr's own sidebar — the workspace list, not the editor
toggle_sidebar = "cmd+b"

# Keep prefix around only as an escape hatch
prefix = "ctrl+b"
```

## zsh — `home/.zshrc`

```zsh
# ─── Keys ───────────────────────────────────────────────────────────────────
# Ghostty's opt+arrow defaults are unbound (see its config) so TUIs get the
# real modified arrows. zsh already knows ^[b / ^[f but not these, and without
# them the prompt just prints ";3C".
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# cmd+left/right are rewritten to Home/End for the same reason — zsh knew
# ^A and ^E, but not these.
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# cmd+k is rewritten to F14 (see Ghostty's config) because its own clear_screen
# only wipes Ghostty's buffer, and herdr repaints over it. zsh's clear-screen is
# no good either: it sends terminfo `clear`, ESC[H ESC[2J, which blanks the
# visible screen and leaves the scrollback — the reason cmd+k looked like it had
# done nothing. ESC[3J is the part that drops it. ctrl+L keeps its plain redraw.
clear-screen-and-scrollback() {
  printf '\033[H\033[2J\033[3J'
  zle .reset-prompt
}
zle -N clear-screen-and-scrollback
bindkey '^[[26~' clear-screen-and-scrollback
```
