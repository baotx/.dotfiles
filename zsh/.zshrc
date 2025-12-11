# Set environment variables
export ZSH="$HOME/.oh-my-zsh"
export TERM=xterm-256color
export PNPM_HOME="$HOME/.local/share/pnpm"
export PYENV_ROOT="$HOME/.pyenv"
export BW_PRE_COMMIT_CSPELL=false
export BW_PRE_COMMIT_PRETTIER=false
export BW_PRE_COMMIT_LINT=false

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Auto-use Node.js version from .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"
  
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Set ZSH theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# Load additional tools
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Aliases
alias air='$(go env GOPATH)/bin/air'

# Path configuration
export PATH="$PATH:$HOME/.local/scripts:$HOME/.local/bin:/usr/local/go/bin"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin:/opt/homebrew/bin"
# Add fzf, rg (ripgrep), and bat to PATH
export PATH="$PATH:$HOME/.fzf/bin:/usr/bin"

# Ensure pnpm is in PATH
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;; 
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Automatically start ngrok session in tmux
check_and_open_ngrok() {
  if ! tmux has-session -t "ngrok" 2>/dev/null; then
    tmux new-session -d -s "ngrok" "~/ngrok tcp 22"
  fi
}
check_and_open_ngrok

# Key bindings
bindkey -s ^f "tmux-sessionizer\n"

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ryantong/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ryantong/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ryantong/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ryantong/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

