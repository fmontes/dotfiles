#!/usr/bin/env zsh
echo "Applying macOS defaults..."

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false

# Dock apps — reset to just the ones I keep pinned
dock_app() {
  local app="$1"
  printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>' "$app"
}
defaults delete com.apple.dock persistent-apps 2>/dev/null
defaults delete com.apple.dock persistent-others 2>/dev/null
for app in \
  "file:///System/Applications/Apps.app/" \
  "file:///System/Applications/iPhone Mirroring.app/"; do
  defaults write com.apple.dock persistent-apps -array-add "$(dock_app "$app")"
done

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keyboard
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Mission Control keyboard shortcuts — free up Ctrl for AeroSpace
#
# AeroSpace uses plain Ctrl+arrows for focus, Ctrl+Shift+arrows to move a
# window, and Ctrl+1..9 for workspaces. macOS claims all of those for Spaces
# and Mission Control, and system shortcuts win over app-registered hotkeys, so
# they have to be off or the bindings silently do nothing.
#
# The Shift variants (ids 80 and 82) are the trap: System Settings shows one
# checkbox per "Move left/right a space" row, but macOS registers two hotkeys
# behind it — Ctrl+arrow and Ctrl+Shift+arrow. Ids 80 and 82 have no UI control
# at all, so they survive turning the visible ones off.
#
# Written through `defaults import` rather than `defaults write -dict-add`
# because the old-style syntax stores the parameters as strings, and this table
# wants integers. Idempotent: existing entries keep their parameters and only
# get enabled=false; missing ones are created disabled.
echo "  disabling Mission Control shortcuts that collide with AeroSpace..."
/usr/bin/python3 - <<'PYEOF'
import plistlib, subprocess

# id: (ascii, keycode, modifiers) — modifiers 262144=Ctrl, 393216=Ctrl+Shift,
# 8650752=Ctrl plus the 0x800000 flag arrows carry.
TARGETS = {
    "32":  (65535, 126, 8650752),   # Ctrl+Up        Mission Control
    "33":  (65535, 125, 8650752),   # Ctrl+Down      Application windows
    "79":  (97,      0,  262144),   # Ctrl+Left      Move left a space
    "80":  (97,      0,  393216),   # Ctrl+Shift+Left    (no UI checkbox)
    "81":  (100,     2,  262144),   # Ctrl+Right     Move right a space
    "82":  (100,     2,  393216),   # Ctrl+Shift+Right   (no UI checkbox)
    "118": (65535,  18,  262144),   # Ctrl+1         Switch to Desktop 1
    "119": (65535,  19,  262144),   # Ctrl+2         Switch to Desktop 2
    "120": (65535,  20,  262144),   # Ctrl+3         Switch to Desktop 3
    "121": (65535,  21,  262144),   # Ctrl+4         Switch to Desktop 4
}

DOMAIN = "com.apple.symbolichotkeys"
raw = subprocess.run(["defaults", "export", DOMAIN, "-"],
                     capture_output=True).stdout
dom = plistlib.loads(raw) if raw.strip() else {}
hk = dom.get("AppleSymbolicHotKeys", {})

CTRL, SHIFT, OPTION, COMMAND = 262144, 131072, 524288, 1048576

# Keycodes AeroSpace binds: digits 1-9, the four arrows, and the legacy 0/2
# encoding ids 79-82 use for left/right.
CLAIMED = {18, 19, 20, 21, 23, 22, 26, 28, 25, 123, 124, 125, 126, 0, 2}


def collides(entry):
    """True when an existing entry is a bare Ctrl or Ctrl+Shift chord on a key
    AeroSpace binds. Excluding Cmd and Option matters: it keeps this away from
    the Ctrl+Shift+Cmd+3/4 screenshot shortcuts, which share the digit keys."""
    par = (entry.get("value") or {}).get("parameters") or []
    if len(par) < 3:
        return False
    mods = par[2]
    return (mods & CTRL) and not (mods & COMMAND) and not (mods & OPTION) \
        and par[1] in CLAIMED


def disable(hid, entry):
    if entry.get("enabled") is False:
        return 0
    entry["enabled"] = False          # keep whatever parameters it already had
    return 1


changed = 0

# Anything already in the table that collides, whether or not it is listed
# below. macOS adds "Switch to Desktop 5".."9" entries as you create Spaces,
# and their ids are not documented — this catches them without guessing.
for hid, entry in hk.items():
    if isinstance(entry, dict) and collides(entry):
        changed += disable(hid, entry)

# Then the known ids, so the ones macOS has not created yet are pre-disabled.
for hid, params in TARGETS.items():
    cur = hk.get(hid)
    if isinstance(cur, dict) and "value" in cur:
        changed += disable(hid, cur)
    else:
        hk[hid] = {"enabled": False,
                   "value": {"parameters": list(params), "type": "standard"}}
        changed += 1

if changed:
    dom["AppleSymbolicHotKeys"] = hk
    subprocess.run(["defaults", "import", DOMAIN, "-"],
                   input=plistlib.dumps(dom, fmt=plistlib.FMT_XML), check=True)
    print(f"    {changed} shortcut(s) disabled")
else:
    print("    already disabled")
PYEOF

# Apply the hotkey table without needing a logout.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

killall Dock
killall Finder
echo "macOS defaults applied."
