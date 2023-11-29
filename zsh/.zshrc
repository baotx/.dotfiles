export TERM=xterm-256color

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Calling nvm use automatically in a directory with a .nvmrc file
# Put this after nvm initiation
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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

export PATH=$PATH:/usr/local/go/bin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bwo() {
  local=$(fdfind -e code-workspace . $HOME | fzf --height 40% --reverse)
  code $local
}

bwa() {
  local branch_name="$1" # Branch name with person
  branch_name="${branch_name// /-}" # Replace all spaces with dashes
  local wi_name="${branch_name:4}" # Remove the "RT3/"
  local project="$2"

  # Save the current directory and change directory
  pushd . > /dev/null

  if [[ $project == [wW]* ]]; then
    cd ~/WebWatcher/WebWatcher
  elif [[ $project == [uU]* ]]; then
    cd ~/UMP/UMP
  else
    cd ~/BorderWiseWeb/BorderWiseWeb
  fi

  git fetch --all

  # Git operations
  git worktree remove ${wi_name}
  git branch -D -f ${wi_name}

  # Check if the branch exists on the remote
  if [[ -n $(git ls-remote --heads origin ${branch_name}) ]]; then
    echo "Branch exists on remote"
    echo "git worktree add ../${wi_name} origin/${branch_name}"
    # If branch exists on remote, create worktree for that branch
    git worktree add ../${wi_name} origin/${branch_name}
  else
    echo "Branch DOES NOT exists on remote"
    # If branch does not exist, create a new branch and set up worktree
    echo "git worktree add -b ${wi_name} ../${wi_name}"
    git worktree add -b ${wi_name} ../${wi_name}
    # Optionally, push the new branch to remote
    echo "git -C ../${wi_name} push --set-upstream origin ${wi_name}:${branch_name}"
  fi

    git -C ../${wi_name} push --set-upstream origin ${wi_name}:${branch_name}

  # Return to the original directory
  popd > /dev/null
}
