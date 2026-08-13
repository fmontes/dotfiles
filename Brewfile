tap "charliesbot/tap"
tap "nikitabobko/tap"
tap "tobi/try", "https://github.com/tobi/try"

# ─── Formulae ───────────────────────────────────────────────────────────────
brew "atuin"
brew "bat"
brew "btop"
brew "cloudflared"
brew "fd"
brew "git-delta"
brew "deno"
brew "direnv"
brew "dust"
brew "eza"
brew "ffmpeg"
brew "flyctl"
brew "fzf"
brew "gh"
brew "imagemagick"
brew "jq"
brew "just"
brew "lazydocker"
brew "mise"
brew "mkcert"

brew "mole"
brew "mprocs"
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
cask "chai"
cask "chromedriver"
cask "codex"
cask "orbstack"
cask "raycast"

# Puppeteer's headless browser (PUPPETEER_EXECUTABLE_PATH in .zshrc), not part
# of the desktop layout. Heads up: this cask is deprecated for failing the macOS
# Gatekeeper check and Homebrew disables it on 2026-09-01.
cask "chromium"

# ─── Desktop layout ─────────────────────────────────────────────────────────
# The AeroSpace layout in home/.config/aerospace/aerospace.toml pins each of
# these to a fixed slot by bundle ID. Slot 1 is a deliberately empty desktop,
# and Orca (slot 4) has no cask — see scripts/07-post-install.sh.
cask "nikitabobko/tap/aerospace"

cask "slack"                      # slot 3
cask "google-chrome"              # slots 5 and 6, split by profile
cask "visual-studio-code"         # slot 7

# Not in the layout — Warp has no slot, so it lands in overflow (slot 0).
cask "warp"
