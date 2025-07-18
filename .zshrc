export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/.dotfiles"

ZSH_THEME=""

plugins=(
  git
  colorize
  colored-man-pages
  extract
  zsh-syntax-highlighting
  zsh-autosuggestions
  nvm
  docker
  docker-compose
)

# Functions . . . . . . . . . . .
zstyle ':completion:*:default' list-colors "ow=30;44"

fpath+=$DOTFILES/.zsh_functions
autoload -U $fpath[-1]/*(.:t)
fpath+=$HOME/.zfunc
fpath+=$HOME/.zsh/functions
autoload compinit -Uz && compinit

source $ZSH/oh-my-zsh.sh

# Paths . . . . . . . . . . . . .
export LOCAL=$HOME/.local

export PATH=$HOME/bin:$HOME/deps/bin:/usr/local/bin:$PATH
export PATH=$LOCAL/bin:$PATH

# ssh
eval "$(ssh-agent -s)" >/dev/null
for key in $HOME/.ssh/id_*; do
  if [ -f "$key" ] && [[ ! $key == *.pub ]]; then
    ssh-add $key 2>/dev/null
  fi
done

# go
if command -v go &>/dev/null; then
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$PATH
fi

# nvm
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# linuxbrew
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  # modules
  if [ -d "$HOMEBREW_PREFIX/opt/modules" ]; then
    source $HOMEBREW_PREFIX/opt/modules/init/zsh
    moddir=$(module path dot | sed 's/\/dot//g')
    module unuse "${moddir}"
    module config color always
    if [ -d "$HOME/.modules" ]; then
      module use --append $HOME/.modules/modfiles
    fi
  fi
fi

# spicetify
if [ -d "$HOME/.spicetify" ]; then
  export PATH=$PATH:$HOME/.spicetify
fi

# kitty
if command -v kitty &>/dev/null; then
  alias icat="kitten icat"
else
  # export TERM=xterm-256color
fi

# fzf
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)
fi

if [ -d "$HOME/spack/" ]; then
  . $HOME/spack/share/spack/setup-env.sh
fi

# Aliases . . . . . . . . . . .

if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  alias vimconfig="vi $HOME/.config/nvim/init.vim"
  alias vim='nvim'
  alias vi='nvim'
  alias less='vim -R'
fi

if command -v ranger &>/dev/null; then
  export RANGER_LOAD_DEFAULT_RC=false
  alias rr='ranger'
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if [ -f "/etc/arch-release" ]; then
    if command -v bat &>/dev/null; then
      alias cat='bat -pp --theme=TwoDark'
    fi
  else
    if command -v batcat &>/dev/null; then
      alias cat='batcat -pp --theme=TwoDark'
    fi
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if command -v bat &>/dev/null; then
    alias cat='bat -pp --theme=TwoDark'
  fi
fi

if command -v eza &>/dev/null; then
  alias ls='EXA_ICON_SPACING=1 eza -a --icons --sort=type'
  alias ll='EXA_ICON_SPACING=1 eza -a --long --icons --header --sort=type --git --time-style=long-iso'
  alias lt='EXA_ICON_SPACING=1 eza -a --icons --sort=type --tree --level 2 --icons --color'
  alias ld='EXA_ICON_SPACING=1 eza -a --long --icons --header --sort=type --git --time-style=long-iso --total-size'
fi

if [ -d "$HOME/.cargo" ]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

if command -v gh &>/dev/null; then
  function howto() {
    gh copilot suggest $1
  }
  function wtf() {
    gh copilot explain $1
  }
fi

if command -v fastfetch &>/dev/null; then
  alias ff='fastfetch'
fi

if command -v nerdfetch &>/dev/null; then
  alias nf='nerdfetch'
fi

if command -v waybar &>/dev/null; then
  if command -v hyprctl &>/dev/null; then
    alias resetwaybar="killall waybar & hyprctl dispatch exec waybar"
  fi
fi

if command -v hyprctl &>/dev/null; then
  if command -v thunar &>/dev/null; then
    function ofd() {
      hyprctl dispatch -- exec thunar -- $(pwd)
    }
  fi
fi

if command -v bw &>/dev/null; then
  if command -v pass &>/dev/null; then
    alias bw='BW_SESSION=$(pass bw_session) BITWARDENCLI_APPDATA_DIR=$HOME/.bw/ NODE_OPTIONS="--no-deprecation" bw'
  fi
fi

if command -v codium &>/dev/null; then
  alias code='codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland'
fi

# Theme . . . . . . . . . . .
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG=$DOTFILES/.config/starship.toml
fi
