if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH=$HOME/bin:$HOME/deps/bin:/usr/local/bin:$PATH
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.rbenv/bin

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git colorize colored-man-pages extract)

source $ZSH/oh-my-zsh.sh

# -------------------------------
# custom:
# -------------------------------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

zstyle ':completion:*:default' list-colors "ow=30;44"

fpath+=$HOME/.dotfiles/.zsh_functions
autoload -U $fpath[-1]/*(.:t)

export EDITOR=nvim

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
. "$HOME/.cargo/env"

autoload compinit -Uz && compinit

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_CHROMA_FORMATTER=terminal16m

alias vimconfig="vi $HOME/.config/nvim/init.vim"
alias cat='ccat'
alias ls='exa -a --icons --git --sort=type'
alias ll='exa -a --long --icons --header --git --sort=type --time-style=long-iso'
