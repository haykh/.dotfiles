#!/usr/bin/env bash

HOMEDIR=$(mktemp -d)

TEMPDIR=$HOMEDIR/.temp
LOCAL=$HOMEDIR/.local
ZSHFUNC=$HOMEDIR/.zfunc
PYTHONEXEC=$(which python3.11)
OPTPATH=$HOMEDIR/opt

mkdir -p $TEMPDIR && cd $TEMPDIR
mkdir -p $LOCAL/bin
mkdir -p $ZSHFUNC
mkdir -p $OPTPATH

function prompt() {
  local prompt="$1"
  local default="$2"
  local response

  read -p "$prompt ($default): " response
  response=${response:-$default}

  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

# install eza
prompt "install eza? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "eza installation skipped"
else 
  echo "installing eza..."
  wget https://github.com/eza-community/eza/releases/download/v0.21.0/eza_x86_64-unknown-linux-gnu.tar.gz && \
    tar xvf eza_x86_64-unknown-linux-gnu.tar.gz && \
    mv eza $LOCAL/bin/ && \
    rm eza_x86_64-unknown-linux-gnu.tar.gz && \
    echo "eza installed to $LOCAL/bin" || \
    echo "eza installation failed"
fi


# install fzf
prompt "install fzf? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "fzf installation skipped"
else
  echo "installing fzf..."
  wget https://github.com/junegunn/fzf/releases/download/v0.61.1/fzf-0.61.1-linux_amd64.tar.gz && \
    tar xvf fzf-0.61.1-linux_amd64.tar.gz && \
    mv fzf $LOCAL/bin/ && \
    rm fzf-0.61.1-linux_amd64.tar.gz && \
    echo "fzf installed to $LOCAL/bin" || \
    echo "fzf installation failed"
fi

# install bat
prompt "install bat? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "bat installation skipped"
else
  echo "installing bat..."
  wget https://github.com/sharkdp/bat/releases/download/v0.25.0/bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz && \
    tar xvf bat-v0.25.0-x86_64-unknown-linux-gnu.tar.gz && \
    mv bat-v0.25.0-x86_64-unknown-linux-gnu/bat $LOCAL/bin/ && \
    mv bat-v0.25.0-x86_64-unknown-linux-gnu/autocomplete/bat.zsh $ZSHFUNC && \
    rm -rf bat-v0.25.0-x86_64-unknown-linux-gnu && \
    echo "bat installed to $LOCAL/bin" || \
    echo "bat installation failed"
fi

# install starship
prompt "install starship? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "starship installation skipped"
else 
  echo "installing starship..."
  wget https://github.com/starship/starship/releases/download/v1.22.1/starship-x86_64-unknown-linux-gnu.tar.gz && \
    tar xvf starship-x86_64-unknown-linux-gnu.tar.gz && \
    mv starship $LOCAL/bin/ && \
    rm starship-x86_64-unknown-linux-gnu.tar.gz && \
    echo "starship installed to $LOCAL/bin" || \
    echo "starship installation failed"
fi 

# install omz & plugins
prompt "install oh-my-zsh? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "oh-my-zsh installation skipped"
else
  echo "installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    echo "oh-my-zsh and plugins installed" || \
    echo "oh-my-zsh and plugins installation failed"
fi

# install pipx
prompt "install pipx? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "pipx installation skipped"
else
  echo "installing pipx..."
  wget https://github.com/pypa/pipx/releases/download/1.7.1/pipx.pyz && \
    mv pipx.pyz $OPTPATH/ && \
    chmod +x $OPTPATH/pipx.pyz && \
    echo "pipx installed to $OPTPATH" || \
    echo "pipx installation failed"
fi

# install fortls
prompt "install fortls with pipx? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "fortls installation skipped"
else
  echo "installing fortls..."
  $PYTHONEXEC $OPTPATH/pipx.pyz install fortls && \
    echo "fortls installed" || \
    echo "fortls installation failed"
fi

# install nvim
prompt "install nvim? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "nvim installation skipped"
else
  echo "installing nvim..."
  wget https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz && \
    tar xvf nvim-linux-x86_64.tar.gz && \
    mv nvim-linux-x86_64 $OPTPATH && \
    ln -s $OPTPATH/nvim-linux-x86_64/bin/nvim $LOCAL/bin/ && \
    rm nvim-linux-x86_64.tar.gz && \
    echo "nvim installed to $LOCAL/bin" || \
    echo "nvim installation failed"
fi

# install n
prompt "install n? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "n installation skipped"
else
  echo "installing n..."
  export N_PREFIX=$LOCAL/n && \
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts && \
    echo "n installed to $LOCAL/n" || \
    echo "n installation failed"
fi

# rewrite zshrc
prompt "rewrite .zshrc? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo ".zshrc rewrite skipped"
else
  echo "rewriting .zshrc..."
  zshrc_content=$(cat <<EOF
export TERM=xterm-256color
export PATH=\$PATH:$LOCAL/bin
export PATH=\$PATH:\$HOME/.n/bin
export ZSH="\$HOME/.oh-my-zsh"
export N_PREFIX="\$HOME/.local/n"

plugins=(git colorize colored-man-pages extract zsh-autosuggestions zsh-syntax-highlighting)

source \$ZSH/oh-my-zsh.sh

eval "\$(starship init zsh)"
eval "\$(fzf --zsh)"

alias -- cat='bat --completion zsh -pp --theme=TwoDark'
alias -- eza='eza --icons always --color always --git -a '\''--sort=type'\'''
alias -- la='eza -a'
alias -- ld='ls --long --header --time-style=long-iso --total-size'
alias -- ll='ls --long --header --time-style=long-iso'
alias -- lla='eza -la'
alias -- ls=eza
alias -- lt='ls --tree --level 2 --icons=always --color'
alias -- vi=nvim
alias -- vim=nvim
export EDITOR=nvim

fpath=(\$HOME/.zfunc \$fpath)
autoload compinit -Uz && compinit

export PYTHON=$PYTHONEXEC
alias -- pipx="\$PYTHON $OPTPATH/pipx.pyz"

alias -- sque="squeue --start -u \$USER"
EOF
)

  echo "$zshrc_content" > $HOMEDIR/.zshrc
fi 
