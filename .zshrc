# Nathaniel's .zshrc
# Minimal configuration for PHP/Laravel and Node development

# ============================================================================
# GENERAL SETTINGS
# ============================================================================

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# Enable colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Homebrew (Apple Silicon)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Local bin directories
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"

# Composer global packages
export PATH="$HOME/.composer/vendor/bin:$PATH"

# ============================================================================
# MINIMAL ALIASES
# ============================================================================

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"

# List files
alias ll="ls -lah"
alias la="ls -A"

# Git shortcuts (minimal)
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph"

# Quick reload
alias reload="source ~/.zshrc"

# Brewfile update
alias brewup="brew update && brew upgrade && brew cleanup"

# ============================================================================
# SIMPLE FUNCTIONS
# ============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ============================================================================
# PROMPT
# ============================================================================

# Enable parameter expansion in prompt
setopt PROMPT_SUBST

# Show git branch in prompt
git_branch() {
    git branch 2>/dev/null | grep '^*' | colrm 1 2
}

# Simple, clean prompt
PROMPT='%F{cyan}%~%f %F{yellow}$(git_branch)%f %F{green}❯%f '

# ============================================================================
# COMPLETIONS
# ============================================================================

# Enable completion system
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ============================================================================
# LOCAL CUSTOMIZATIONS
# ============================================================================

# Source local configurations (won't error if file doesn't exist)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
