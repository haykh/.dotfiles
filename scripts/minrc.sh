#!/usr/bin/env bash

RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

printf "${BLUE}Master directory${NC} "
read -p "(default: $HOME): " HOMEDIR
HOMEDIR=${HOMEDIR:-$HOME}

printf "Master directory is ${RED}${HOMEDIR}${NC}\n"

TEMPDIR=$HOMEDIR/.temp
LOCAL=$HOMEDIR/.local
ZSHFUNC=$HOMEDIR/.zfunc
PYTHONEXEC=/usr/licensed/anaconda3/2024.10/bin/python3
OPTPATH=$HOMEDIR/opt

EZA_VERSION=0.21.0
FZF_VERSION=0.61.1
BAT_VERSION=0.25.0
STARSHIP_VERSION=1.22.1
PIPX_VERSION=1.7.1
NVIM_VERSION=0.11.1
GO_VERSION=1.24.2

mkdir -p $TEMPDIR && cd $TEMPDIR
mkdir -p $LOCAL/bin
mkdir -p $ZSHFUNC
mkdir -p $OPTPATH

function prompt() {
  local prompt="\033[0;34m$1\033[0m"
  local default="$2"
  local response

  printf "\n${BLUE}${prompt}${NC}: "

  read -p "" response
  response=${response:-$default}

  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

# install eza
prompt "install eza v${EZA_VERSION} in $LOCAL/bin? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "eza installation skipped"
else
  echo "installing eza..."
  wget https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz &&
    tar xvf eza_x86_64-unknown-linux-gnu.tar.gz &&
    mv eza $LOCAL/bin/ &&
    rm eza_x86_64-unknown-linux-gnu.tar.gz &&
    echo "eza installed to $LOCAL/bin" ||
    echo "eza installation failed"
fi

# install fzf
prompt "install fzf v${FZF_VERSION} in $LOCAL/bin? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "fzf installation skipped"
else
  echo "installing fzf..."
  wget https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
    tar xvf fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
    mv fzf $LOCAL/bin/ &&
    rm fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
    echo "fzf installed to $LOCAL/bin" ||
    echo "fzf installation failed"
fi

# install bat
prompt "install bat v${BAT_VERSION} in $LOCAL/bin? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "bat installation skipped"
else
  echo "installing bat..."
  wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz &&
    tar xvf bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu.tar.gz &&
    mv bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu/bat $LOCAL/bin/ &&
    mv bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu/autocomplete/bat.zsh $ZSHFUNC &&
    rm -rf bat-v${BAT_VERSION}-x86_64-unknown-linux-gnu &&
    echo "bat installed to $LOCAL/bin" ||
    echo "bat installation failed"
fi

# install starship
prompt "install starship v${STARSHIP_VERSION} in $LOCAL/bin? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "starship installation skipped"
else
  echo "installing starship..."
  wget https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz &&
    tar xvf starship-x86_64-unknown-linux-gnu.tar.gz &&
    mv starship $LOCAL/bin/ &&
    rm starship-x86_64-unknown-linux-gnu.tar.gz &&
    echo "starship installed to $LOCAL/bin" ||
    echo "starship installation failed"
fi

# install omz & plugins
prompt "install oh-my-zsh + plugins $HOMEDIR/.oh-my-zsh? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "oh-my-zsh + plugins installation skipped"
else
  echo "installing oh-my-zsh + plugins..."
  ZSH="${HOMEDIR}/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&
    echo "oh-my-zsh & plugins installed" ||
    echo "oh-my-zsh & plugins installation failed"
fi

# install pipx
prompt "install pipx v${PIPX_VERSION} in $LOCAL/bin? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "pipx installation skipped"
else
  echo "installing pipx..."
  wget https://github.com/pypa/pipx/releases/download/${PIPX_VERSION}/pipx.pyz &&
    mv pipx.pyz $LOCAL/bin &&
    chmod +x $LOCAL/bin/pipx.pyz &&
    echo "pipx installed to $LOCAL/bin" ||
    echo "pipx installation failed"
fi

# install fortls + clang-format + cmakelang
prompt "install fortls + clang-format + cmakelang with pipx? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "fortls + clang-format + cmakelang installation skipped"
else
  echo "installing fortls + clang-format + cmakelang..."
  $PYTHONEXEC $LOCAL/bin/pipx.pyz install fortls &&
    echo "fortls installed" ||
    echo "fortls installation failed"
  $PYTHONEXEC $LOCAL/bin/pipx.pyz install clang-format &&
    echo "clang-format installed" ||
    echo "clang-format installation failed"
  $PYTHONEXEC $LOCAL/bin/pipx.pyz install cmakelang &&
    echo "cmakelang installed" ||
    echo "cmakelang installation failed"
fi

# install nvim
prompt "install nvim v${NVIM_VERSION} in ${OPTPATH}/nvim-linux-x86-64? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "nvim installation skipped"
else
  echo "installing nvim..."
  wget https://github.com/neovim/neovim-releases/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz &&
    tar xvf nvim-linux-x86_64.tar.gz &&
    mv nvim-linux-x86_64 $OPTPATH &&
    ln -s $OPTPATH/nvim-linux-x86_64/bin/nvim $LOCAL/bin/ &&
    rm nvim-linux-x86_64.tar.gz &&
    echo "nvim installed to $LOCAL/bin" ||
    echo "nvim installation failed"
fi

# install n
prompt "install n in $LOCAL/n? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "n installation skipped"
else
  echo "installing n..."
  export N_PREFIX=$LOCAL/n &&
    curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts &&
    echo "n installed to $LOCAL/n" ||
    echo "n installation failed"
fi

# install go
prompt "install go v${GO_VERSION} in $LOCAL/go? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "go installation skipped"
else
  echo "installing go..."
  wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz &&
    tar -C "$LOCAL" -xzf go${GO_VERSION}.linux-amd64.tar.gz &&
    echo "go installed to $LOCAL/go" ||
    echo "go installation failed"
fi

# install gopls
prompt "install gopls with go? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "gopls installation skipped"
else
  echo "installing gopls..."
  go install golang.org/x/tools/gopls@latest &&
    echo "gopls installed" ||
    echo "gopls installation failed"
fi

# install rust + cargo
prompt "install rust + cargo in $HOMEDIR/.rustup & $HOMEDIR/.cargo? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "rust + cargo installation skipped"
else
  echo "installing rust + cargo..."
  CARGO_HOME="$HOMEDIR/.cargo" RUSTUP_HOME="$HOMEDIR/.rustup" bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y' &&
    echo "rust & cargo installed in $HOMEDIR/.rustup and $HOMEDIR/.cargo" ||
    echo "rust & cargo installation failed"
fi

# install stylua + neocmakelsp + ripgrep
prompt "install stylua + neocmakelsp + ripgrep + git-delta with cargo? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo "stylua + neocmakelsp + ripgrep + git-delta installation skipped"
else
  echo "installing stylua + neocmakelsp + ripgrep + git-delta..."
  $HOMEDIR/.cargo/bin/cargo install stylua &&
    echo "stylua installed" ||
    echo "stylua installation failed"
  $HOMEDIR/.cargo/bin/cargo install neocmakelsp &&
    echo "neocmakelsp installed" ||
    echo "neocmakelsp installation failed"
  $HOMEDIR/.cargo/bin/cargo install ripgrep &&
    echo "ripgrep installed" ||
    echo "ripgrep installation failed"
  $HOMEDIR/.cargo/bin/cargo install git-delta &&
    echo "git-delta installed" ||
    echo "git-delta installation failed"
fi

# append .gitconfig
prompt "append .gitconfig with delta configs? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo ".gitconfig append skipped"
else
  echo "appending .gitconfig..."
  mkdir -p $LOCAL/share/delta &&
    wget https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig &&
    mv themes.gitconfig $LOCAL/share/delta/themes.gitconfig
  gitconfig_content=$(
    cat <<EOF
[core]
  pager = delta

[interactive]
  diffFilter = delta --color-only

[delta]
  features = arctic-fox
  side-by-side = true
  navigate = true

[include]
  path = $LOCAL/share/delta/themes.gitconfig
EOF
  )

  echo "$gitconfig_content" >>$HOMEDIR/.gitconfig
fi

# rewrite zshrc
prompt "rewrite .zshrc? (Y/n)" "y"
if [[ $? -ne 0 ]]; then
  echo ".zshrc rewrite skipped"
else
  echo "rewriting .zshrc..."
  zshrc_content=$(
    cat <<EOF
export TERM=xterm-256color
export PATH=\$PATH:$LOCAL/bin
export PATH=\$PATH:$LOCAL/go/bin
export PATH=\$PATH:$LOCAL/n/bin
export PATH=\$PATH:$HOMEDIR/.cargo/bin
export ZSH="$HOMEDIR/.oh-my-zsh"
export N_PREFIX="$LOCAL/n"

plugins=(git colorize colored-man-pages extract zsh-autosuggestions zsh-syntax-highlighting)

source $HOMEDIR/.oh-my-zsh/oh-my-zsh.sh

eval "\$(starship init zsh)"
eval "\$(fzf --zsh)"

alias -- cat='bat -pp --theme=TwoDark'
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

fpath=($HOMEDIR/.zfunc \$fpath)
autoload compinit -Uz && compinit

export PYTHON=$PYTHONEXEC
alias -- pipx="$PYTHONEXEC $LOCAL/bin/pipx.pyz"

alias -- sque="squeue --start -u \$USER"
EOF
  )

  echo "$zshrc_content" >$HOMEDIR/.zshrc
fi
