#!/usr/bin/env zsh

# ─── gh-dash extension ───────────────────────────────────────────────────────
if command -v gh &>/dev/null; then
  echo "Installing gh-dash extension..."
  gh extension install dlvhdr/gh-dash 2>/dev/null || echo "gh-dash already installed or gh not authenticated yet"
fi

# ─── Claude Code (native installer) ──────────────────────────────────────────
# Use the official native installer rather than the npm package — the npm
# global install can skip the platform-native binary (--ignore-scripts /
# --omit=optional), leaving a `claude` on PATH that exists but won't run.
# The installer drops the binary in ~/.local/bin, which this script's PATH
# may not include yet — add it so the run-check and verification work here.
export PATH="$HOME/.local/bin:$PATH"
# Test that it actually runs, not just that it's present, so a broken npm
# install gets replaced.
if claude --version &>/dev/null; then
  echo "Claude Code already installed."
else
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || echo "Claude Code install failed — run 'curl -fsSL https://claude.ai/install.sh | bash' manually."
  if claude --version &>/dev/null; then
    echo "Claude Code ready."
  else
    echo "Claude Code still not runnable — check ~/.local/bin/claude manually."
  fi
fi

# ─── herdr annotate plugin ───────────────────────────────────────────────────
# herdr comes from the Brewfile but its plugins install at runtime, so a fresh
# machine has to fetch this one again. The manifest is pinned to a commit, so
# the install is deterministic.
if command -v herdr &>/dev/null; then
  if herdr plugin list 2>/dev/null | grep -q annotate; then
    echo "herdr annotate plugin already installed."
  else
    echo "Installing herdr annotate plugin..."
    herdr plugin install plannotator/herdr-annotate -y || echo "annotate install failed — run 'herdr plugin install plannotator/herdr-annotate' manually."
  fi
  if herdr plugin list 2>/dev/null | grep -q herdr-automatic-rename; then
    echo "herdr automatic-rename plugin already installed."
  else
    echo "Installing herdr automatic-rename plugin..."
    herdr plugin install qu8n/herdr-automatic-rename --yes || echo "automatic-rename install failed — run 'herdr plugin install qu8n/herdr-automatic-rename --yes' manually."
  fi
  if herdr plugin list 2>/dev/null | grep -q persiyanov.reviewr; then
    echo "herdr reviewr plugin already installed."
  else
    echo "Installing herdr reviewr plugin..."
    herdr plugin install persiyanov/herdr-reviewr --yes || echo "reviewr install failed — run 'herdr plugin install persiyanov/herdr-reviewr --yes' manually."
  fi
else
  echo "herdr not available yet — install the Brewfile first, then run 'herdr plugin install plannotator/herdr-annotate' and 'herdr plugin install qu8n/herdr-automatic-rename'."
fi

# ─── Global npm packages ─────────────────────────────────────────────────────
if command -v npm &>/dev/null; then
  echo "Installing global npm packages..."
  npm install -g @angular/cli @fmontes/md2clip dev-browser yarn
else
  echo "npm not available yet — skipping global packages. Run manually after mise sets up Node."
fi

# ─── chai: sync AI agent config to all platforms ─────────────────────────────
# Distributes ai/instructions, ai/skills, and ai/subagents (plus external deps
# declared in chai.toml) to every configured agent platform.
if command -v chai &>/dev/null; then
  echo "Syncing AI agent config with chai..."
  chai update || echo "chai update failed — run 'chai update' manually."
  chai sync   || echo "chai sync failed — run 'chai sync' manually."
else
  echo "chai not available yet — run 'chai update && chai sync' after Homebrew finishes."
fi

# ─── Tinycast settings ───────────────────────────────────────────────────────
# Hotkeys, the Caps Lock hyper key, launcher aliases, and custom commands live
# in a cfprefsd-owned plist, so they are imported rather than symlinked. Do this
# before launching Tinycast for the first time — a running app overwrites the
# domain from memory. Re-capture with scripts/tinycast-export.sh.
tinycast_plist="$HOME/.config/tinycast/com.tinycast.app.plist"
if [[ -f "$tinycast_plist" ]]; then
  if pgrep -qx Tinycast; then
    echo "Tinycast is running — quit it and run 'defaults import com.tinycast.app $tinycast_plist' to restore its settings."
  else
    defaults import com.tinycast.app "$tinycast_plist"
    echo "Tinycast settings imported."
  fi
fi

# ─── pr-watch LaunchAgent ────────────────────────────────────────────────────
# Polls each herdr workspace's PR into the sidebar and notifies on changes.
# The plist is symlinked by 03-symlinks.sh; launchd still has to be told.
agent="$HOME/Library/LaunchAgents/com.fmontes.pr-watch.plist"
if [[ -e "$agent" ]]; then
  mkdir -p "$HOME/.local/state/pr-watch"
  launchctl unload "$agent" 2>/dev/null
  if launchctl load "$agent" 2>/dev/null; then
    echo "pr-watch LaunchAgent loaded."
  else
    echo "pr-watch LaunchAgent failed to load — run 'launchctl load $agent' manually."
  fi
fi

# ─── Fix .netrc permissions ──────────────────────────────────────────────────
if [[ -f "$HOME/.netrc" ]]; then
  chmod 600 "$HOME/.netrc"
  echo ".netrc permissions fixed."
fi

# ─── VS Code CLI symlink ─────────────────────────────────────────────────────
code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -f "$code_bin" ]]; then
  echo "Setting up VS Code CLI symlink..."
  sudo mkdir -p /usr/local/bin
  if sudo ln -sf "$code_bin" /usr/local/bin/code; then
    echo "VS Code CLI ready."
  else
    echo "VS Code CLI symlink failed."
  fi
fi

# ─── Manual steps ────────────────────────────────────────────────────────────
echo ""
echo "======================================"
echo "  Manual Steps Required"
echo "======================================"
echo ""
echo "1. Install 1Password and sign in"
echo "2. Generate SSH key and add to GitHub:"
echo "   ssh-keygen -t ed25519 -C 'your@email.com'"
echo "   https://github.com/settings/keys"
echo "3. Update name and email in ~/.gitconfig"
echo "4. gh auth login"
echo "5. atuin login  (optional, for cross-machine history sync)"
echo "6. Launch Tinycast and grant it Accessibility access (hotkeys are already restored)"
echo "7. Grant AeroSpace Accessibility access, then relaunch it:"
echo "   System Settings > Privacy & Security > Accessibility"
echo "   Without it AeroSpace cannot move windows into their slots."
echo "8. Install Orca (desktop slot 4) — no Homebrew cask: https://stably.ai"
echo ""
