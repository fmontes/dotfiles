# ─── Git ────────────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gp="git push"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbd="git branch -d"
alias gl="git log --oneline --graph --decorate -20"
alias gll="git log --oneline --graph --decorate --all"

# ─── CLI Replacements ───────────────────────────────────────────────────────
alias cat="bat"
alias f="fd"
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first --git"
alias lt="eza --tree --level=2 --icons"

# ─── Ports ──────────────────────────────────────────────────────────────────
alias devports='lsof -i :3000,3001,4200,5173,8080,8090,8443 | grep LISTEN'

# ─── Projects ───────────────────────────────────────────────────────────────
# Stays a function: a script runs in a child process and cannot cd this shell.
proj() {
  local dir
  dir=$(zoxide query -l | fzf --preview 'eza --tree --level=1 --icons {}')
  [[ -n "$dir" ]] && cd "$dir" && code --new-window .
}

# ─── GitHub ─────────────────────────────────────────────────────────────────
alias prs="gh dash"

# ─── Dotfiles ───────────────────────────────────────────────────────────────
# Stays an alias: sourcing has to happen in this shell, not a child.
alias zreload="source ~/.zshrc && echo 'Reloaded'"

# ─── Desktop ────────────────────────────────────────────────────────────────
# AeroSpace has no overview GUI and parks inactive windows off-screen rather
# than using macOS Spaces, so Mission Control is no help either. Workspaces are
# generic and exist only while occupied, so there is nothing to label — just
# list what is where.
alias spaces="aerospace list-windows --all --format '%{workspace}  %{app-name}  %{window-title}' | sort -n"

# ─── Misc ───────────────────────────────────────────────────────────────────
alias run-help=man
alias code="code --new-window"
