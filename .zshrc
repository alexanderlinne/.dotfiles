export PATH=$HOME/.cargo/bin:$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/alexander/.oh-my-zsh"

ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"

plugins=(git fzf)

ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

# User configuration

bindkey -s ^f "tmux-sessionizer\n"

alias vim=nvim
alias cls="tput reset"
alias config="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

