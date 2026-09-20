tap "abue-ammar/tinycast"
tap "charliesbot/tap"
tap "nikitabobko/tap"
tap "tobi/try", "https://github.com/tobi/try"

# ─── Formulae ───────────────────────────────────────────────────────────────
brew "atuin"
brew "bat"
brew "btop"
brew "charliesbot/tap/chai"
brew "cloudflared"
brew "fd"
brew "git-delta"
brew "deno"
brew "direnv"
brew "dust"
brew "eza"
brew "ffmpeg"
# Force-linked over ffmpeg 8 — /opt/homebrew/bin/ffmpeg resolves to this one.
# ffmpeg@7 is keg-only, so without link: true a new machine gets 8 on PATH.
brew "ffmpeg@7", link: true
brew "flyctl"
brew "fzf"
brew "gh"
brew "herdr"
brew "imagemagick"
brew "jq"
brew "just"
brew "lazydocker"
brew "librsvg"
brew "mise"
brew "mkcert"

brew "mole"
brew "mprocs"
brew "opencode"
brew "poppler"
brew "railway"
brew "ripgrep"
brew "rtk"
brew "starship"
brew "fresh-editor"
brew "tlrc"
brew "tree"
brew "try"
brew "wget"
brew "yazi"
brew "zoxide"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

# ─── Casks ──────────────────────────────────────────────────────────────────
cask "1password-cli"
cask "chromedriver"
cask "codex"
cask "ghostty"
cask "orbstack"
cask "tinycast"

# Puppeteer's headless browser (PUPPETEER_EXECUTABLE_PATH in .zshrc), not part
# of the desktop layout. Heads up: this cask is deprecated for failing the macOS
# Gatekeeper check and Homebrew disables it on 2026-09-01.
cask "chromium"

# ─── Desktop layout ─────────────────────────────────────────────────────────
# AeroSpace tiles these in home/.config/aerospace/aerospace.toml. Workspaces
# are generic contexts, so nothing is assigned to one — an app opens wherever
# focus is. Only Slack and MacWhisper carry a rule, forcing windows macOS
# mislabels as panels back into tiling.
cask "nikitabobko/tap/aerospace"

cask "slack"                      # slot 3
cask "google-chrome"              # slots 5 and 6, split by profile
cask "visual-studio-code"         # slot 7

# Not in the layout — Warp has no slot, so it lands in overflow (slot 0).
cask "warp"
