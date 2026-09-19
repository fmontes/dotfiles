#!/usr/bin/env zsh
# Capture Tinycast's settings into the repo.
#
# Tinycast keeps everything in ~/Library/Preferences/com.tinycast.app.plist,
# which cfprefsd owns and rewrites — symlinking it into the repo does not work.
# So this exports a copy instead, and 07-post-install.sh imports it on a new
# machine. The pre-commit hook runs this, so hotkey changes travel on their own.
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${(%):-%x}")/.." && pwd)}"
dest="$DOTFILES_DIR/home/.config/tinycast/com.tinycast.app.plist"
rel="${dest#$DOTFILES_DIR/}"

# `defaults export` on a missing domain writes an empty <dict/> and still exits
# 0, so without this guard a machine without Tinycast would wipe the tracked
# copy — and the pre-commit hook would commit the wipe.
if ! defaults read com.tinycast.app >/dev/null 2>&1; then
  echo "Tinycast preferences not found — leaving $rel untouched."
  exit 0
fi

tmp="$(mktemp -t tinycast-export)"
trap 'rm -f "$tmp"' EXIT

defaults export com.tinycast.app "$tmp"

# Per-machine UI state — window positions, a file bookmark holding an absolute
# path, and calendar UUIDs that differ per account. None of it should travel.
for key in \
  "AppleShowScrollBars" \
  "NSNavPanelExpandedSizeForOpenMode" \
  "NSOSPLastRootDirectory" \
  "NSStatusItem VisibleCC Item-1" \
  "NSWindow Frame SettingsWindow" \
  "hiddenMeetingCalendars"; do
  /usr/libexec/PlistBuddy -c "Delete :\"$key\"" "$tmp" 2>/dev/null || true
done

# XML rather than binary so the diffs are readable.
plutil -convert xml1 "$tmp"

# Second belt: a near-empty export means something went wrong upstream.
keys=$(grep -c "<key>" "$tmp" || true)
if (( keys < 5 )); then
  echo "Tinycast export produced only $keys keys — refusing to overwrite $rel."
  exit 0
fi

mkdir -p "$(dirname "$dest")"
mv "$tmp" "$dest"
trap - EXIT
echo "Exported Tinycast settings to $rel ($keys keys)"
