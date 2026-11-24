# Fresh editor archive

Historical setup notes. TTT is now the default terminal editor and Fresh is no longer installed by the Brewfile. Its existing configuration and plugin files remain available for reference.

[Fresh](https://getfresh.dev/) remains available as an alternative terminal editor for code editing and browsing. Launch with `fresh .` from any project.

fresh ships a macOS keymap built on `Cmd`, but it drops the super modifier when decoding CSI-u, so none of those bindings can fire inside a terminal. The keymap is therefore `vscode`, not `macos`. The `macos` map is where all 38 of those dead `Cmd` bindings live, while `vscode` is built on `Ctrl` and works in full: `⌃D` add cursor at next match, `⌃⌥↑/↓` add cursor above/below, `⌃⇧K` delete line, `⌃L` select line, `⌥↑/↓` move line.

That one structural fact — Fresh cannot see a `Cmd` chord — is what the rest of the keyboard setup is built around. It leaves the whole of `cmd+*` to herdr.app, permanently, no matter what either program adds in a later release. [Terminal](../README.md#terminal) has the whole layer map.

herdr.app keeps five rewrites for Fresh's benefit, in the `terminal` section of [`home/.config/herdr-app/keys.json`](../home/.config/herdr-app/keys.json). `Cmd+←/→` and `Cmd+⇧←/→` become Home/End and their shifted pair, because the `\u0001`/`\u0005` it sends by default are `⌃A` and `⌃E`, which the vscode map spends on `select_all` and `focus_file_explorer` — so `Cmd+←` used to select the whole buffer and `Cmd+→` threw focus into the file tree. `Cmd+K` becomes F14 so the shell can clear its own scrollback. Everything else Fresh gets raw.

herdr.app sends `esc b`/`esc f` for `⌥←/→`, which Fresh decodes as `alt+b`/`alt+f`. [`home/.config/fresh/config.json`](../home/.config/fresh/config.json) disables menu mnemonics so `Alt+F` cannot open the File menu. In Fresh 0.5.8, disabling mnemonics alone leaves `Alt+F` without word motion in the vscode map, so one explicit binding maps it to `move_word_right`. `Alt+B` already moves left by a word. The menu bar remains clickable.

`Cmd+C` is herdr.app's `terminal.copy`. Selecting already copies, so dragging a selection lands it on the clipboard either way.

## Keys

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

[md-pretty](https://github.com/sunnypdater/fresh-md-pretty) renders Markdown as a read-only preview panel. It is vendored into [`home/.config/fresh/plugins/packages/md-pretty/`](../home/.config/fresh/plugins/packages/md-pretty/) rather than installed, because it does not run against Fresh 0.4.3 as published — it needs seven changes, five of them plugin-API drift and two packaging. [`docs/fresh-md-pretty/`](fresh-md-pretty/) lists them and keeps the upstream originals so the diff survives the next release. Being under `home/` means `03-symlinks.sh` installs it with everything else.

Fresh runs as a **persistent daemon per workspace**, not a process per window, so closing a tab reattaches to the same process rather than starting a new one — a config or plugin change does not take effect until that daemon dies. They show up in `ps` as plain `fresh <path>` and can outlive a reboot-free week. `fresh --cmd daemon kill <name>` prints the name and then hangs rather than returning, so `pkill fresh` is the way to restart them.
