if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$HOME/deps/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.rbenv/bin

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git colorize colored-man-pages extract zsh-syntax-highlighting zsh-autosuggestions docker docker-compose)

source $ZSH/oh-my-zsh.sh

# -------------------------------
# Custom:
# -------------------------------
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

zstyle ':completion:*:default' list-colors "ow=30;44"

fpath+=$HOME/.dotfiles/.zsh_functions
autoload -U $fpath[-1]/*(.:t)

autoload compinit -Uz && compinit

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_CHROMA_FORMATTER=terminal16m

export EDITOR=nvim

alias vimconfig="vi $HOME/.config/nvim/init.vim"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f "/etc/arch-release" ]; then
    alias cat='bat -pp --theme=TwoDark'
  else
    alias cat='batcat -pp --theme=TwoDark'
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  alias cat='bat -pp --theme=TwoDark'
fi
alias ls='EXA_ICON_SPACING=1 exa -a --icons --sort=type'
alias ll='EXA_ICON_SPACING=1 exa -a --long --icons --header --sort=type --time-style=long-iso'
alias vim='nvim'
alias vi='nvim'
alias less='vim -R'
