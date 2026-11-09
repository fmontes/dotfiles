#!/usr/bin/env zsh
# Install the launch agents in launchd/ into ~/Library/LaunchAgents.
#
# They are rendered, not symlinked: launchd wants a real file it owns, and the
# templates carry __HOME__ instead of a hardcoded user path. Idempotent: an
# agent that is already current and loaded is left alone, a changed one is
# rewritten and reloaded, a missing one is installed and loaded.

# Runnable on its own, not just via install.sh which exports DOTFILES_DIR.
: "${DOTFILES_DIR:="${0:a:h:h}"}"

agents_dir="$HOME/Library/LaunchAgents"
domain="gui/$(id -u)"
mkdir -p "$agents_dir"

for template in "$DOTFILES_DIR"/launchd/*.plist(N); do
  name="${template:t}"
  label="${name%.plist}"
  dest="$agents_dir/$name"
  rendered="$(sed "s|__HOME__|$HOME|g" "$template")"

  loaded=false
  launchctl print "$domain/$label" &>/dev/null && loaded=true

  if [[ -f "$dest" && "$(cat "$dest")" == "$rendered" ]]; then
    if $loaded; then
      echo "  [skip]    $label"
      continue
    fi
  else
    $loaded && launchctl bootout "$domain/$label" 2>/dev/null
    print -r -- "$rendered" > "$dest"
    loaded=false
  fi

  if launchctl bootstrap "$domain" "$dest"; then
    echo "  [loaded]  $label"
  else
    echo "  [failed]  $label — try: launchctl bootstrap $domain $dest"
  fi
done
