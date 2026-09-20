#!/usr/bin/env bash
#
# Refresh the focused workspace's PR status.
#
# The LaunchAgent polls every 5 minutes, which is fine for noticing a change
# but means the row you are looking at can be five minutes stale. This closes
# that gap for the one workspace you just focused.
set -euo pipefail

STATE="$HOME/.local/state/pr-watch"
DEBOUNCE=45   # seconds; flicking through workspaces should not hammer the API

command -v pr-watch >/dev/null 2>&1 || exit 0

ws=$(printf '%s' "${HERDR_PLUGIN_CONTEXT_JSON:-}" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
# Prefer an explicit workspace id; otherwise take the prefix of any id herdr
# gave us, since they are all "<workspace>:<thing>".
for k in ("workspace_id", "workspace"):
    v = d.get(k)
    if isinstance(v, str) and v:
        print(v); sys.exit(0)
for k in ("tab_id", "pane_id", "id"):
    v = d.get(k)
    if isinstance(v, str) and ":" in v:
        print(v.split(":", 1)[0]); sys.exit(0)
' 2>/dev/null) || exit 0

[[ -n $ws ]] || exit 0

mkdir -p "$STATE"
marker="$STATE/last-$ws"
if [[ -f $marker ]]; then
  age=$(( $(date +%s) - $(stat -f %m "$marker" 2>/dev/null || echo 0) ))
  (( age < DEBOUNCE )) && exit 0
fi
touch "$marker"

# Detached: a workspace switch should not wait on the network. --quiet because
# focusing something is not the moment to be told what changed while you were
# away; the LaunchAgent poll owns notifications.
( pr-watch --workspace "$ws" --quiet >/dev/null 2>&1 & ) &
exit 0
