#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# select the master directory
printf "%bMaster directory%b " "${BLUE}" "${NC}"
read -rp "(default: $HOME): " HOMEDIR
HOMEDIR=${HOMEDIR:-$HOME}

printf "Master directory is %b%b%b\n" "${RED}" "${HOMEDIR}" "${NC}"

# select the shell
printf "%bSelect the shell%b " "${BLUE}" "${NC}"
read -rp "(default: zsh): " MYSHELL
MYSHELL=${MYSHELL:-zsh}

if [[ "$MYSHELL" != "zsh" && "$MYSHELL" != "bash" ]]; then
  echo "Unsupported shell: $MYSHELL. Only zsh and bash are supported."
  exit 1
fi

printf "Shell selected to be %b%b%b\n" "${RED}" "${MYSHELL}" "${NC}"

# mode
printf "%bSelect the mode (install/uninstall)%b " "${BLUE}" "${NC}"
read -rp "(default: install): " MODE
MODE=${MODE:-install}

if [[ "$MODE" != "install" && "$MODE" != "uninstall" ]]; then
  echo "Unsupported mode: $MODE. Only install and uninstall are supported."
  exit 1
fi

printf "%b%b%b mode\n" "${RED}" "${MODE}" "${NC}"

# global variables
TEMPDIR=$HOMEDIR/.temp
LOCAL=$HOMEDIR/.local
ZSHFUNC=$HOMEDIR/.zfunc
PYTHONEXEC=$(which python3)
OPTPATH=$HOMEDIR/opt

FZF_VERSION=0.61.1
PIPX_VERSION=1.7.1
NVIM_VERSION=0.11.1
GO_VERSION=1.24.2

mkdir -p "$TEMPDIR" && cd "$TEMPDIR" || exit 1
mkdir -p "$LOCAL/bin"
mkdir -p "$OPTPATH"

if [[ "$MODE" == "install" && "$MYSHELL" == "zsh" ]]; then
  mkdir -p "$ZSHFUNC"
fi

function prompt() {
  local prompt="\033[0;34m$1\033[0m"
  local default="$2"
  local response

  printf "\n%b%b%b: " "${BLUE}" "${prompt}" "${NC}"

  read -rp "" response
  response=${response:-$default}

  if [[ "$response" =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

function cargoinstall() {
  local package=$1
  echo "installing $package..."
  "$HOMEDIR"/.cargo/bin/cargo install "$package" &&
    echo "$package installed" ||
    echo "$package installation failed"
}

function promptcargoinstall() {
  local package=$1
  if ! prompt "install $package with cargo? (Y/n)" "y"; then
    echo "$package installation skipped"
  else
    cargoinstall "$package"
  fi
}

function pipxinstall() {
  local package=$1
  echo "installing $package..."
  $PYTHONEXEC "$LOCAL/bin/pipx.pyz" install "$package" &&
    echo "$package installed" ||
    echo "$package installation failed"
}

function promptpipxinstall() {
  local package=$1
  if ! prompt "install $package with pipx? (Y/n)" "y"; then
    echo "$package installation skipped"
  else
    pipxinstall "$package"
  fi
}

# install fzf
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install fzf v${FZF_VERSION} in $LOCAL/bin? (Y/n)" "y"; then
    echo "fzf installation skipped"
  else
    echo "installing fzf..."
    wget https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
      tar xvf fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
      mv fzf "$LOCAL/bin/" &&
      rm fzf-${FZF_VERSION}-linux_amd64.tar.gz &&
      echo "fzf installed to $LOCAL/bin" ||
      echo "fzf installation failed"
  fi
else
  if ! prompt "uninstall fzf from $LOCAL/bin? (y/N)" "n"; then
    echo "fzf uninstallation skipped"
  else
    echo "uninstalling fzf..."
    rm -f "$LOCAL/bin/fzf" &&
      echo "fzf uninstalled from $LOCAL/bin" ||
      echo "fzf uninstallation failed"
  fi
fi

if [[ "$MYSHELL" == "zsh" ]]; then
  # install omz & plugins
  if [[ "$MODE" == "install" ]]; then
    if ! prompt "install oh-my-zsh + plugins $HOMEDIR/.oh-my-zsh? (Y/n)" "y"; then
      echo "oh-my-zsh + plugins installation skipped"
    else
      echo "installing oh-my-zsh + plugins..."
      ZSH="${HOMEDIR}/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &&
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" &&
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOMEDIR/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" &&
        echo "oh-my-zsh & plugins installed" ||
        echo "oh-my-zsh & plugins installation failed"
    fi
  else
    if ! prompt "uninstall oh-my-zsh from $HOMEDIR/.oh-my-zsh? (y/N)" "n"; then
      echo "oh-my-zsh uninstallation skipped"
    else
      echo "uninstalling oh-my-zsh..."
      rm -rf "$HOMEDIR/.oh-my-zsh" &&
        echo "oh-my-zsh uninstalled from $HOMEDIR/.oh-my-zsh" ||
        echo "oh-my-zsh uninstallation failed"
    fi
  fi
else
  # install omb
  if [[ "$MODE" == "install" ]]; then
    if ! prompt "install oh-my-bash + ble.sh $HOMEDIR/.oh-my-bash? (Y/n)" "y"; then
      echo "oh-my-bash + ble.sh installation skipped"
    else
      echo "installing oh-my-bash + ble.sh..."
      OSH="${HOMEDIR}/.oh-my-bash" bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended &&
        git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git &&
        make -C ble.sh install PREFIX="$LOCAL" &&
        rm -rf ble.sh &&
        echo "oh-my-bash & ble.sh installed" ||
        echo "oh-my-bash & ble.sh installation failed"
    fi
  else
    if ! prompt "uninstall oh-my-bash from $HOMEDIR/.oh-my-bash? (y/N)" "n"; then
      echo "oh-my-bash uninstallation skipped"
    else
      echo "uninstalling oh-my-bash..."
      uninstall_oh_my_bash && rm -rf "$HOMEDIR/.oh-my-bash" && rm -rf "$LOCAL/share/blesh" &&
        echo "oh-my-bash uninstalled from $HOMEDIR/.oh-my-bash" ||
        echo "oh-my-bash uninstallation failed"
    fi
  fi
fi

# install pipx & packages
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install pipx v${PIPX_VERSION} in $LOCAL/bin? (Y/n)" "y"; then
    echo "pipx installation skipped"
  else
    echo "installing pipx..."
    wget https://github.com/pypa/pipx/releases/download/${PIPX_VERSION}/pipx.pyz &&
      mv pipx.pyz "$LOCAL/bin" &&
      chmod +x "$LOCAL/bin/pipx.pyz" &&
      echo "pipx installed to $LOCAL/bin" ||
      echo "pipx installation failed"
  fi
  if [[ -f "$LOCAL/bin/pipx.pyz" ]]; then
    promptpipxinstall fortls
    promptpipxinstall clang-format
    promptpipxinstall cmakelang
  fi
else
  if [[ -f "$LOCAL/bin/pipx.pyz" ]]; then
    if ! prompt "uninstall all pipx packages? (y/N)" "n"; then
      echo "pipx package uninstallation skipped"
    else
      echo "uninstalling all pipx packages..."
      "$PYTHONEXEC" "$LOCAL/bin/pipx.pyz" uninstall-all &&
        echo "all pipx packages uninstalled" ||
        echo "pipx package uninstallation failed"
    fi
  fi

  if ! prompt "uninstall pipx from $LOCAL/bin? (y/N)" "n"; then
    echo "pipx uninstallation skipped"
  else
    echo "uninstalling pipx..."
    rm -f "$LOCAL/bin/pipx.pyz" &&
      rm -rf "$LOCAL/share/pipx" &&
      rm -rf "$LOCAL/state/pipx" &&
      echo "pipx uninstalled from $LOCAL/bin" ||
      echo "pipx uninstallation failed"
  fi
fi

# install nvim
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install nvim v${NVIM_VERSION} in ${OPTPATH}/nvim-linux-x86-64? (Y/n)" "y"; then
    echo "nvim installation skipped"
  else
    echo "installing nvim..."
    wget https://github.com/neovim/neovim-releases/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz &&
      tar xvf nvim-linux-x86_64.tar.gz &&
      mv nvim-linux-x86_64 "$OPTPATH" &&
      ln -s "$OPTPATH/nvim-linux-x86_64/bin/nvim" "$LOCAL/bin/" &&
      rm nvim-linux-x86_64.tar.gz &&
      echo "nvim installed to $LOCAL/bin" ||
      echo "nvim installation failed"
  fi
else
  if ! prompt "uninstall nvim from $OPTPATH/nvim-linux-x86-64? (y/N)" "n"; then
    echo "nvim uninstallation skipped"
  else
    echo "uninstalling nvim..."
    rm -rf "$OPTPATH/nvim-linux-x86_64" &&
      rm -f "$LOCAL/bin/nvim" &&
      rm -rf "$LOCAL/share/nvim" &&
      rm -rf "$LOCAL/state/nvim" &&
      echo "nvim uninstalled from $OPTPATH/nvim-linux-x86-64" ||
      echo "nvim uninstallation failed"
  fi
fi

# install n
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install n in $LOCAL/n? (Y/n)" "y"; then
    echo "n installation skipped"
  else
    echo "installing n..."
    export N_PREFIX=$LOCAL/n &&
      curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s install lts &&
      echo "n installed to $LOCAL/n" ||
      echo "n installation failed"
  fi
else
  if [[ -d "$HOMEDIR/.npm" ]]; then
    if ! prompt "uninstall npm from $HOMEDIR/.npm? (y/N)" "n"; then
      echo "npm uninstallation skipped"
    else
      echo "uninstalling npm..."
      rm -rf "$HOMEDIR/.npm" &&
        echo "npm uninstalled from $HOMEDIR/.npm" ||
        echo "npm uninstallation failed"
    fi
  fi

  if ! prompt "uninstall n from $LOCAL/n? (y/N)" "n"; then
    echo "n uninstallation skipped"
  else
    echo "uninstalling n..."
    rm -rf "$LOCAL/n" &&
      echo "n uninstalled from $LOCAL/n" ||
      echo "n uninstallation failed"
  fi
fi

# install go
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install go v${GO_VERSION} in $LOCAL/go? (Y/n)" "y"; then
    echo "go installation skipped"
  else
    echo "installing go..."
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz &&
      tar -C "$LOCAL" -xzf go${GO_VERSION}.linux-amd64.tar.gz &&
      echo "go installed to $LOCAL/go" ||
      echo "go installation failed"
  fi

  # install gopls
  if [[ -d "$LOCAL/go" ]]; then
    if ! prompt "install gopls with go? (Y/n)" "y"; then
      echo "gopls installation skipped"
    else
      echo "installing gopls..."
      "$LOCAL/go/bin/go" install golang.org/x/tools/gopls@latest &&
        echo "gopls installed" ||
        echo "gopls installation failed"
    fi
  fi
else
  if ! prompt "uninstall go from $LOCAL/go? (y/N)" "n"; then
    echo "go uninstallation skipped"
  else
    echo "uninstalling go..."
    if [[ -d "$LOCAL/go" ]]; then
      chmod 777 "$HOMEDIR/go" && rm -rf "$HOMEDIR/go" &&
        echo "go uninstalled from $HOMEDIR/go" ||
        echo "go uninstallation failed"
    fi

    if [[ -d "$LOCAL/go" ]]; then
      rm -rf "$LOCAL/go" &&
        echo "go uninstalled from $LOCAL/go" ||
        echo "go uninstallation failed"
    fi
  fi
fi

# install rust + cargo
if [[ "$MODE" == "install" ]]; then
  if ! prompt "install rust + cargo in $HOMEDIR/.rustup & $HOMEDIR/.cargo? (Y/n)" "y"; then
    echo "rust + cargo installation skipped"
  else
    echo "installing rust + cargo..."
    CARGO_HOME="$HOMEDIR/.cargo" RUSTUP_HOME="$HOMEDIR/.rustup" bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y' &&
      echo "rust & cargo installed in $HOMEDIR/.rustup and $HOMEDIR/.cargo" ||
      echo "rust & cargo installation failed"
  fi

  # cargo packages
  if [[ -d "$HOMEDIR/.cargo" ]]; then
    promptcargoinstall starship
    promptcargoinstall eza
    promptcargoinstall bat
    promptcargoinstall fd-find
    promptcargoinstall git-delta
    promptcargoinstall ripgrep
    promptcargoinstall stylua
    promptcargoinstall neocmakelsp
  fi
else
  if [[ -f "$HOMEDIR"/.cargo/bin/cargo ]]; then
    if ! prompt "uninstall cargo packages from $HOMEDIR/.cargo? (y/N)" "n"; then
      echo "cargo package uninstallation skipped"
    else
      echo "uninstalling cargo packages..."
      "$HOMEDIR"/.cargo/bin/cargo uninstall -- --all &&
        rm -rf "$LOCAL/share/delta" &&
        echo "cargo packages uninstalled" ||
        echo "cargo package uninstallation failed"
    fi

    if ! prompt "uninstall cargo & rustup from $HOMEDIR/.cargo and $HOMEDIR/.rustup? (y/N)" "n"; then
      echo "cargo & rustup uninstallation skipped"
    else
      echo "uninstalling cargo & rustup..."
      rm -rf "$HOMEDIR/.cargo" &&
        rm -rf "$HOMEDIR/.rustup" &&
        echo "cargo & rustup uninstalled from $HOMEDIR/.cargo and $HOMEDIR/.rustup" ||
        echo "cargo & rustup uninstallation failed"
    fi
  fi
fi

if [[ "$MODE" == "install" ]]; then
  # append .gitconfig
  if ! prompt "append .gitconfig with delta configs? (Y/n)" "y"; then
    echo ".gitconfig append skipped"
  else
    echo "appending .gitconfig..."
    mkdir -p "$LOCAL/share/delta" &&
      wget https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig &&
      mv themes.gitconfig "$LOCAL/share/delta/themes.gitconfig"
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

    echo "$gitconfig_content" >>"$HOMEDIR/.gitconfig"
  fi

  if [[ "$MYSHELL" == "zsh" ]]; then
    # modify zshrc
    if ! prompt "modify .zshrc? (Y/n)" "y"; then
      echo ".zshrc modify skipped"
    else
      echo "modifying .zshrc..."
      zshrc_content=$(
        cat <<EOF
export TERM=xterm-256color
export PATH=\$PATH:$LOCAL/bin
export PATH=\$PATH:$LOCAL/go/bin:$HOMEDIR/go/bin
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

fpath=($ZSHFUNC \$fpath)
autoload compinit -Uz && compinit

export PYTHON=$PYTHONEXEC
alias -- pipx="$PYTHONEXEC $LOCAL/bin/pipx.pyz"

alias -- sque="squeue --start -u \$USER"
EOF
      )

      cp "$HOMEDIR/.zshrc" "$HOMEDIR/.zshrc.pre-minrc.bak" 2>/dev/null || true
      echo "$zshrc_content" >"$HOMEDIR/.zshrc"
    fi
  else
    # modify bashrc
    if ! prompt "modify .bashrc? (Y/n)" "y"; then
      echo ".bashrc modify skipped"
    else
      echo "modifying .bashrc..."
      bashrc_content=$(
        cat <<EOF
export TERM=xterm-256color
export PATH=\$PATH:$LOCAL/bin
export PATH=\$PATH:$LOCAL/go/bin:$HOMEDIR/go/bin
export PATH=\$PATH:$LOCAL/n/bin
export PATH=\$PATH:$HOMEDIR/.cargo/bin
export OSH="$HOMEDIR/.oh-my-bash"
export N_PREFIX="$LOCAL/n"

OMB_USE_SUDO=false

plugins=(git cargo fzf npm starship colored-man-pages)

completions=(
  git
  composer
  ssh
  npm
  pip
  pip3
)

source $HOMEDIR/.oh-my-bash/oh-my-bash.sh

source $LOCAL/share/blesh/ble.sh
eval "\$(starship init bash)"
eval "\$(fzf --bash)"

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

export PYTHON=$PYTHONEXEC
alias -- pipx="$PYTHONEXEC $LOCAL/bin/pipx.pyz"

alias -- sque="squeue --start -u \$USER"
EOF
      )

      cp "$HOMEDIR/.bashrc" "$HOMEDIR/.bashrc.pre-minrc.bak" 2>/dev/null || true
      echo "$bashrc_content" >"$HOMEDIR/.bashrc"
    fi
  fi
  printf "\n%bAll done%b\nHOMEDIR: %b\nSHELL: %b\n" "${GREEN}" "${NC}" "${HOMEDIR}" "${MYSHELL}"
else
  printf "\n%bSkipping shell rc and gitconfig modifications in uninstall mode%b\n%bAll done%b\n" "${RED}" "${NC}" "${GREEN}" "${NC}"
fi
