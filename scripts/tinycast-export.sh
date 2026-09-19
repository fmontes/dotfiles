#!/usr/bin/env zsh
# Capture Tinycast's settings into the repo.
#
# Tinycast keeps everything in ~/Library/Preferences/com.tinycast.app.plist,
# which cfprefsd owns and rewrites — symlinking it into the repo does not work.
# So this exports a copy instead, and 07-post-install.sh imports it on a new
# machine. Re-run this after changing hotkeys, aliases, or custom commands.
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${(%):-%x}")/.." && pwd)}"
dest="$DOTFILES_DIR/home/.config/tinycast/com.tinycast.app.plist"

mkdir -p "$(dirname "$dest")"
defaults export com.tinycast.app "$dest"

# Per-machine UI state — window positions, a file bookmark holding an absolute
# path, and calendar UUIDs that differ per account. None of it should travel.
for key in \
  "AppleShowScrollBars" \
  "NSNavPanelExpandedSizeForOpenMode" \
  "NSOSPLastRootDirectory" \
  "NSStatusItem VisibleCC Item-1" \
  "NSWindow Frame SettingsWindow" \
  "hiddenMeetingCalendars"; do
  /usr/libexec/PlistBuddy -c "Delete :\"$key\"" "$dest" 2>/dev/null || true
done

# XML rather than binary so the diffs are readable.
plutil -convert xml1 "$dest"
echo "Exported Tinycast settings to ${dest#$DOTFILES_DIR/}"
