#!/usr/bin/env bash
# Create a git worktree the way Herdr expects and open it as a space.
#
#   worktree.sh <branch>                create the worktree and open a space on it
#   worktree.sh --no-space <branch>     create the worktree only (orchestrated workers make the space)
#
# Run it from anywhere inside the repo. Prints the worktree path on the last line.
set -euo pipefail

space=1
if [ "${1:-}" = "--no-space" ]; then space=0; shift; fi

branch="${1:-}"
if [ -z "$branch" ]; then
  echo "usage: worktree.sh [--no-space] <branch>" >&2
  exit 2
fi

# The main checkout, even when run from a linked worktree.
common="$(git rev-parse --path-format=absolute --git-common-dir)"
repo="${common%/.git}"

# Same path rule as Herdr's worktree mod: ~/.herdr/worktrees/<repo>/<branch, slashes as dashes>.
slug="$(printf %s "$branch" | sed -E 's/[^A-Za-z0-9._-]+/-/g; s/^-+//; s/-+$//')"
path="$HOME/.herdr/worktrees/$(basename "$repo")/$slug"

if [ -e "$path" ]; then
  echo "worktree already exists: $path" >&2
elif git -C "$repo" show-ref --verify --quiet "refs/heads/$branch" ||
  git -C "$repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
  git -C "$repo" worktree add "$path" "$branch" >&2
else
  git -C "$repo" worktree add -b "$branch" "$path" HEAD >&2
fi

# A shell in the worktree, labelled with a new space ID: Herdr shows it as an
# unnamed space, so it nests under its repo in the sidebar.
if [ "$space" = 1 ]; then
  hc run --bg --no-notify --outlive-parent --cwd "$path" \
    --label "herdr.space=sp$(openssl rand -hex 16)" >&2
fi

echo "$path"
