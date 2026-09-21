#!/usr/bin/env bash
#
# Refresh the agent sidebar labels.
#
# label-agents is free when every title is cached, so firing this on every
# rename costs nothing in the common case. A new title costs one batched model
# call, which is why this holds a lock: a burst of renames should summarise
# once, not nine times over the top of itself.
set -euo pipefail

LOCK="${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr/plugins/agent-labels}/lock"

command -v label-agents >/dev/null 2>&1 || exit 0

mkdir -p "$(dirname "$LOCK")"
# mkdir is the atomic test-and-set here. A stale lock older than five minutes
# is assumed dead, since the batched call has a two minute timeout.
if ! mkdir "$LOCK" 2>/dev/null; then
  if [[ -d $LOCK ]]; then
    age=$(( $(date +%s) - $(stat -f %m "$LOCK" 2>/dev/null || echo 0) ))
    (( age < 300 )) && exit 0
    rmdir "$LOCK" 2>/dev/null || true
    mkdir "$LOCK" 2>/dev/null || exit 0
  fi
fi

( label-agents >/dev/null 2>&1; rmdir "$LOCK" 2>/dev/null || true ) &
exit 0
