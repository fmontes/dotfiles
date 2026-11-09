---
name: herdr-app
description: Drive the Herdr app and herdr-core from the terminal — create, select, rename or close spaces, tabs and panes; create git worktrees as Herdr spaces; start, message, wait on or read agents and terminals (hc); change layouts, keys or mods. Use whenever the user mentions herdr, a space, tab, pane, worktree, or asks to "spin up / hand off to an agent", "open X in a new space", "create a worktree and work in X", or uses `herdr-app` / `hc`. Takes precedence over Claude Code's built-in worktree tool when running inside Herdr.
---

# Herdr

Herdr is two programs. `herdr-app` is the window (spaces > tabs > panes, layouts, keys, mods). `hc` (herdr-core) runs every terminal and agent and keeps them alive. If `$HC_TERMINAL_ID` is set, this session is itself a terminal inside Herdr.

## 1. Load the current manuals first

Both CLIs ship an agent manual that tracks the installed version. Read the one(s) the task needs before acting, never work from memory:

```sh
herdr-app --skill     # spaces, tabs, panes, focus, layouts: what the person sees
hc --skill            # starting, messaging, waiting on, reading agents and programs
herdr-app commands    # every command and its arguments (* = required)
herdr-app ls          # current spaces, tabs, terminals and pane IDs
```

For layouts, keys, settings, themes or writing mods, read `~/.config/herdr-app/AGENTS.md` (rewritten by the app on every start). Shipped mods live in `~/.config/herdr-app/mods/`; clone with `mod.clone` before editing one.

## 2. Worktrees: use Herdr's, not Claude Code's

Inside Herdr, never use the built-in `EnterWorktree` tool or `.claude/worktrees/`. Herdr's sidebar only nests worktrees it can recognise. Follow the shipped `worktree` mod (`~/.config/herdr-app/mods/worktree/main.js`):

1. Checkout path: `~/.herdr/worktrees/<repo-name>/<branch with / replaced by ->`.
2. Branch exists: `git -C <repo> worktree add <path> <branch>`. New branch: `git -C <repo> worktree add -b <branch> <path> HEAD`.
3. Open a space on it and leave the space unnamed (no `--name`), so it nests under its repo and shows branch, ahead/behind and changes: `herdr-app do space.new --folder <path> --tab "<short task name>" [--argv '["claude"]' --task "<task>"]`.

Remove: `herdr-app do space.close --id <id> --confirmed true`, then `git -C <repo> worktree remove <path>` (check `git status` there first and ask before discarding uncommitted work).

## 3. "Create a worktree / space and work in X"

Default is hand-off: create the worktree (if asked) and a space whose first tab runs a new `claude` with the task, via `--argv '["claude"]' --task "..."`. This session stays where it is and reports the space it made. Only move this session's own work into the new folder if the user says so ("you work there", "move yourself").

Write the task so the new agent can work alone: the goal, the repo/branch, scope limits, and "report with `hc send $HC_TERMINAL_ID` when done or stuck" if the user wants results back here.

## 4. Rules

- New spaces and tabs appear on screen immediately: only create them when asked. Name tabs, and name spaces except worktree spaces (see above).
- Use IDs from `herdr-app ls`; never guess or act on whatever happens to be focused.
- `herdr-app do` prints what it made or `{ "error": ... }`: check it, and report the real space/tab/terminal IDs.
- Don't launch bare `herdr-app` (opens the window) and don't stop, restart or signal the app or core.
- Wait on agents with `hc wait`, never `sleep`.
