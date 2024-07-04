# Initialize Nix environment
export NIX_PROFILE="/Users/robin/.nix-profile"
export PATH="$NIX_PROFILE/bin:$PATH"

export TERM=xterm-256color

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# Initialize Atuin
eval "$(atuin init zsh)"

eval "$(zoxide init zsh)"

# Start the SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add your SSH key to the SSH agent
ssh-add ~/.config/ssh/id_rsa &>/dev/null

# Plugin configs
# zsh-vi-mode use jk for normal mode 
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

if [ -f "/nix/store/0hiahxhfkb2ghg4swps7f5xff248awcf-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/nix/store/0hiahxhfkb2ghg4swps7f5xff248awcf-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "/nix/store/0hiahxhfkb2ghg4swps7f5xff248awcf-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/nix/store/0hiahxhfkb2ghg4swps7f5xff248awcf-zsh-autosuggestions-0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -f "/nix/store/wmapqzrfkmlbxlfsknnjw127y2nlgx0h-zsh-vi-mode-0.9.0/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]; then
  source "/nix/store/wmapqzrfkmlbxlfsknnjw127y2nlgx0h-zsh-vi-mode-0.9.0/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

if [ -f "/nix/store/mflzfgjwkaynii35yxpz16bd7kykimli-nixpkgs/nixpkgs/pkgs/shells/zsh/zsh-completions" ]; then
  source "/nix/store/mflzfgjwkaynii35yxpz16bd7kykimli-nixpkgs/nixpkgs/pkgs/shells/zsh/zsh-completions"
fi

# Ensure Nix completion scripts are sourced
NIX_COMPLETIONS="/nix/store/q8lnp4zwm64q23344p7vrr59jbssgc0k-nix-zsh-completions-unstable-2023-01-30/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh"
NIX_COMPLETION_FUNC="/nix/var/nix/profiles/default/share/zsh/site-functions/_nix"

# Source the Nix completions plugin if it exists
if [ -f "$NIX_COMPLETIONS" ]; then
  source "$NIX_COMPLETIONS"
fi

# Update fpath to include Nix completions
fpath=("/nix/var/nix/profiles/default/share/zsh/site-functions" $fpath)

# Load completions
autoload -Uz compinit
compinit

# Initialize Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Docker/Docker-compose
alias dcu='docker-compose up -d --build'
alias dcd='docker-compose down --remove-orphans'

# Git
alias gfu='git fetch upstream'
alias gdm='git diff upstream/master..HEAD'
alias grm='git pull --rebase upstream master'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gaa='git add .'
alias gs='git status'
alias gl='git log'
alias gca='git commit --amend --no-edit'
alias gh="sed -n '/# git/,/^$/p' ~/.bash_profile"
alias gcm='git checkout master'
alias gd='git diff'

# Custom Aliases
alias rv='z /Users/robin/.config/nvim/lua'
alias ws='z ~/go-workspace'
alias desk='z ~/Desktop'
alias down='z ~/Downloads'
alias todo='vim ~/todo.txt'
alias pg='z ~/go-workspace/playground'
alias fuck="mv ~/Library/Preferences/com.apple.symbolichotkeys.plist ~/Desktop/com.apple.symbolichotkeys.plist"
alias bc='z ~/go-workspace/blockchain/'
alias lv='z ~/go-workspace/logviewer'

# Config entries
alias tc='vim ~/.config/tmux/tmux.conf'
alias rtc='tmux source ~/.config/tmux/tmux.conf'
alias vc='vim ~/.config/nvim/lua/custom/mappings.lua'
alias sc='vim ~/.config/ssh/config'
alias zc="vim ~/.config/zsh/.zshrc"
alias rzc="source ~/.config/zsh/.zshrc"
alias wtc="vim ~/.config/wezterm/wezterm.lua"
alias d="z ~/dotfiles"

# Remaps
alias vim='nvim'
alias ta='tmux attach'
alias td='tmux detach'
alias cd="echo 'Use z or alt-c for navigation instead of cd.'"
alias cd..="echo 'Use z or alt-c for navigation instead of cd ...'"

# Terminal Commands
alias l='eza -l --icons --git -a'
alias lt='eza --tree --level=2 -l --icons --git'

# Export configurations
export SSH_CONFIG=~/.config/ssh/config
export SSH_DIR=~/.config/ssh
export GOLANGCI_LINT_CONFIG=$HOME/.config/golangci/config.yml
export WEZTERM_CONFIG_FILE="$HOME/.config/wezterm/wezterm.lua"
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export GOPASS_CONFIG=~/.config/gopass/config
export TIGRC_USER="$HOME/.config/tig/.tigrc"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
