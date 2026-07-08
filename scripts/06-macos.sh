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

# Screenshots
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

killall Dock
killall Finder
echo "macOS defaults applied."
