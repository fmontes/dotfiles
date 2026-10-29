# ─── Homebrew ───────────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Oh My Zsh ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=()
fpath+=("/opt/homebrew/share/zsh/site-functions")
source $ZSH/oh-my-zsh.sh

# ─── Completions ────────────────────────────────────────────────────────────
# Tab-complete *remote* paths for scp/ssh (`scp f.zip mac2:/var/ww<TAB>`). zsh
# shells out to ssh to list the remote dir, so the host must log in without a
# prompt — key in the agent, `BatchMode=yes` clean. _remote_files reads this
# zstyle with `zstyle -T`, so remote access is already on unless something sets
# it to false; the line is here to say so out loud and to survive a plugin that
# turns it off. The speed comes from the `Host *` ControlMaster block in
# ~/.ssh/config (not committed): without multiplexing every Tab pays for a
# fresh TCP + auth handshake.
zstyle ':completion:*' remote-access yes

# ─── Editor ─────────────────────────────────────────────────────────────────
export EDITOR="nano"
export VISUAL="nano"

# ─── Environment ────────────────────────────────────────────────────────────
# The chromium cask was disabled on 2026-09-01 for failing the macOS Gatekeeper
# check, so Puppeteer runs against the Google Chrome that is already installed.
# Skipping the download only works while that path resolves — if Chrome ever
# leaves the Brewfile, drop both of these and let Puppeteer fetch its own.
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export DOCKER_HOST=unix:///var/run/docker.sock

# ─── Keys ───────────────────────────────────────────────────────────────────
# Clear the screen and drop the scrollback with it. zsh's own clear-screen sends
# terminfo `clear`, ESC[H ESC[2J, which blanks the visible screen and leaves the
# scrollback — the reason cmd+k looked like it had done nothing. ESC[3J is the
# part that drops it, and herdr's emulator honours it.
#
# On two keys: cmd+k, which herdr.app sends as F14 (`"cmd-k": "send:\u001b[26~"`
# in keys.json), and ctrl+k directly. cmd+k has to be rewritten rather than left
# alone because only the shell can clear its own scrollback. ctrl+k is bound here
# in zsh rather than in herdr.app on purpose: herdr would take it from every pane,
# and Fresh spends ⌃K on delete-to-line-end. The cost is zsh's kill-line.
clear-screen-and-scrollback() {
  printf '\033[H\033[2J\033[3J'
  zle .reset-prompt
}
zle -N clear-screen-and-scrollback
bindkey '^[[26~' clear-screen-and-scrollback

# cmd+left/right are rewritten to Home/End in herdr.app's keys.json, because the
# \x01 and \x05 they send by default are ctrl+a and ctrl+e, which Fresh spends on
# select_all and focus_file_explorer. zsh knows ^A and ^E, but not these.
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^K' clear-screen-and-scrollback

# ─── PATH ───────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"   # claude and other native-installer bins
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:$HOME/.cache/lm-studio/bin"
export PATH="~/.console-ninja/.bin:$PATH"

# ─── Tool Loaders ───────────────────────────────────────────────────────────
# Cargo
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Docker
source "$HOME/.docker/init-zsh.sh" 2>/dev/null || true

# mise (replaces nvm, pyenv, sdkman)
# Auto-trust mise configs under these roots, so a fresh clone does not need a
# manual `mise trust`. Note this trusts any .mise.toml found there, including
# in repos cloned from elsewhere — mise configs can set env vars and run hooks.
# herdr puts its worktrees outside ~/Developer, so they need their own entry.
export MISE_TRUSTED_CONFIG_PATHS="$HOME/Developer:$HOME/.herdr/worktrees"
eval "$(mise activate zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || true

# ─── Aliases ────────────────────────────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do source "$f"; done

# ─── Tools ──────────────────────────────────────────────────────────────────
# fzf
eval "$(fzf --zsh)"

# zoxide (replaces cd)
eval "$(zoxide init zsh)"

# atuin (shell history)
eval "$(atuin init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last before starship)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt (must be last)
eval "$(starship init zsh)"

# try-cli (tobi/try) — ephemeral workspace manager
#
# Both halves must name the *binary*, not the function. The eval below defines a
# shell function called `try`, so on a re-source that function shadows the
# binary: `try init ~/src/tries` then reaches try.rb as `exec ... init`, which
# reads `init` as a search query and opens the interactive selector instead of
# printing anything. `command -v try` finds the function too, so it is no guard.
# `whence -p` searches only $PATH, and `command try` skips the function.
whence -p try &>/dev/null && eval "$(command try init ~/src/tries)"

# direnv hook
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# >>> railway initialize >>>
# Guarded: the Railway CLI writes this file on first `railway login`, so it is
# absent on a fresh machine and an unguarded source errors on every new shell.
source "$HOME/.railway/env" 2>/dev/null || true
# <<< railway initialize <<<


# Load Angular CLI autocompletion.
source <(ng completion script)
