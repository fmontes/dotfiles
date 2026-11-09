---
name: herdr-app
description: Drives the Herdr app and herdr-core from the terminal — creates, selects, renames or closes spaces, tabs and panes; creates git worktrees as Herdr spaces; starts, messages, waits on or reads agents and terminals (hc); changes layouts, keys or mods. Use whenever the user mentions herdr, a space, tab, pane, worktree, or asks to "spin up / hand off to an agent", "open X in a new space", "create a worktree and work in X", or uses `herdr-app` / `hc`. Also use when a task should be split across parallel worker agents, or the user says orchestrate, fan out, split this up, or spin up workers. Takes precedence over the harness's built-in worktree tool when running inside Herdr.
---

# Herdr

Herdr is two programs. `herdr-app` is the window (spaces > tabs > panes, layouts, keys, mods). `hc` (herdr-core) runs every terminal and agent and keeps them alive. If `$HC_TERMINAL_ID` is set, this session is itself a terminal inside Herdr.

Terms used below: **lead** is the session coordinating the work, a **worker** is a visible agent the lead tracks, a **helper** is a hidden throwaway.

## 1. Load the current manuals first

Both CLIs ship an agent manual that tracks the installed version. Read the one(s) the task needs before acting, never work from memory:

```sh
herdr-app --skill     # spaces, tabs, panes, focus, layouts: what the person sees
hc --skill            # starting, messaging, waiting on, reading agents and programs
herdr-app commands    # every command and its arguments
herdr-app ls          # current spaces, tabs, terminals and pane IDs
```

For layouts, keys, settings, themes or writing mods, read `~/.config/herdr-app/AGENTS.md` (rewritten by the app on every start). Shipped mods live in `~/.config/herdr-app/mods/`; clone with `mod.clone` before editing one.

## 2. Worktrees: use Herdr's, not the harness's

Inside Herdr, never use a harness's built-in worktree tool (e.g. Claude Code's `EnterWorktree`, `.claude/worktrees/`). Herdr's sidebar only nests worktrees it can recognise. Follow the shipped `worktree` mod (`~/.config/herdr-app/mods/worktree/main.js`):

1. Checkout path: `~/.herdr/worktrees/<repo-name>/<branch with / replaced by ->`.
2. Branch exists: `git -C <repo> worktree add <path> <branch>`. New branch: `git -C <repo> worktree add -b <branch> <path> HEAD`.
3. Open a space on it and leave the space unnamed (no `--name`), so it nests under its repo and shows branch, ahead/behind and changes: `herdr-app do space.new --folder <path> --tab "<short task name>"`. That always opens a shell tab, so for orchestrated workers skip this step: the first worker creates the space (section 5, rule 5).

Remove: `herdr-app do space.close --id <id> --confirmed true`, then `git -C <repo> worktree remove <path>` (check `git status` there first and ask before discarding uncommitted work).

## 3. Starting another agent

**Which agent: the lead's own.** This skill is synced to every agent platform, so never hardcode `claude`. Before starting any worker, read your own launch command: `hc get $HC_TERMINAL_ID --json` → `foreground.argv` (e.g. `["claude"]`, with `status.app` `"claude-code"`). Reuse that argv, model and flags included, everywhere `<lead argv>` appears below. Strip resume and one-shot flags (`--resume`, `-c`/`--continue`, `-p`/`--print`): workers start fresh and interactive. A user-named agent ("have codex review it") overrides this, and a fitting `hc templates` template is also fine. If `foreground.argv` can't be read (e.g. not inside Herdr), ask the user which agent; never default to `claude`.

**Two modes for "create a worktree / space and work in X":**

- **Hand-off** (fire and forget, "go work on X there"): `herdr-app do space.new --folder <path> --tab "<name>" --argv '<lead argv as JSON>' --task "<brief>"`. No report back required; this session stays where it is and reports the space it made.
- **Orchestrated** (the lead needs results): start workers with `hc run` (section 5, rule 5), not `space.new --argv`, so the lead keeps `hc wait --children`, `hc read`, `hc interrupt` and the blocked/exit notices.

Only move this session's own work into the new folder if the user says so ("you work there", "move yourself").

## 4. Rules

- New spaces and tabs appear on screen immediately: only create them when asked. A user asking to orchestrate, fan out or split work counts as asking. Name tabs, and name spaces except worktree spaces (see section 2).
- Use IDs from `herdr-app ls`; never guess or act on whatever happens to be focused.
- `herdr-app do` prints what it made or `{ "error": ... }`: check it, and report the real space/tab/terminal IDs.
- Don't launch bare `herdr-app` (opens the window) and don't stop, restart or signal the app or core.
- Wait on agents with `hc wait`, never `sleep`.

## 5. Orchestrating workers

1. The lead runs inside Herdr (`$HC_TERMINAL_ID` set), in its own space. Workers report with `hc send <lead address>`: the literal value of the lead's `$HC_TERMINAL_ID` (e.g. `t39`), written into the brief. Inside a worker that variable is the worker's own address, so never pass it unexpanded.
2. One deliverable = one worktree = one space. Agents editing different code never share a checkout.
3. Tab = a role on the same worktree (impl / review / tests). A second editing agent in a tab only if it touches disjoint files.
4. Pane = something watched next to an agent (dev server, logs, test watcher). Never two editing agents as panes in one tab.
5. Visible worker: `hc run --bg --name <role> --cwd <worktree> --label herdr.space=<space id> <lead argv> "<brief>"`. `--bg` keeps the lead unblocked; the label makes it visible. For a worktree's first worker, use a new ID (`sp$(openssl rand -hex 16)`): Herdr creates an unnamed space holding only that worker, one tab and no leftover shell, and it nests under its repo. Later workers reuse that ID and each get their own tab. Adding `--label herdr.tab=<id>` puts the worker in that tab as an extra pane (only for rule 4). Then `herdr-app do tab.rename --id <tab> --name <role>` (tab ID from `herdr-app ls`).
6. Helper: plain `hc run --bg --name <name> <argv> "<task>"`, no labels.
7. Brief, every time: goal; worktree path and branch; files allowed; no sub-agents; definition of done; "report with `hc send <lead address>` (rule 1): commit SHA, files changed, test results; long output to a file, send the path."
8. One reply channel per worker: `hc send`. Use the harness's own messaging (e.g. Claude Code `SendMessage`) only for sessions the lead didn't create (hand-started, cloud, Remote Control).
9. At most 3–4 workers at once.
10. Lifetime: workers end when the lead's program ends. Add `--outlive-parent` when a worker must survive the lead exiting; it still counts for `hc wait --children` (tested: `wait --children all` blocked until it exited).
11. Cleanup after merge: close the space (killing its last terminal also closes it), remove the worktree; ask first if anything is uncommitted.

Lead checklist:

```
[ ] lead inside Herdr? ($HC_TERMINAL_ID set; if not, stop and tell the user)
[ ] read own argv (hc get $HC_TERMINAL_ID --json → foreground.argv)
[ ] worktree per deliverable
[ ] start workers with briefs (rules 5 and 7); the first one per worktree creates its space
[ ] hc wait --children any / all
[ ] review actual output; if not done, hc send the worker a follow-up and wait again (repeat until done)
[ ] merge
[ ] cleanup (rule 11)
```
