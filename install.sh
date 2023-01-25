#!/bin/sh

function usage() {
  echo "usage: \`$0 [mac|linux] <subarch>\`"
  echo "   ... where <subarch> is optional:"
  echo "       - [m1|intel] for mac"
  echo "       - [apt|pacman|src] for linux"
}

function command() {
  if [ "$1" != "" ]; then
    echo ". . . . . . . . . . . . . . . . . . . . . . . "
    echo "$1"
  fi
  if [ ! -z "$2" ]; then
    $2
    if [ $? -eq 0 ]; then
      echo "[OK]"
    else
      echo "[FAIL]"
      exit 1
    fi
  fi
}

arch=$1
subarch=$2

function init_zsh() {
  if [ ! -d $HOME/.oh-my-zsh/ ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    echo "oh-my-zsh already installed"
  fi
  rm -f $HOME/.zshrc
  touch $HOME/.zshrc
  echo ". $HOME/.dotfiles/.zshrc" >> $HOME/.zshrc
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  touch $HOME/.p10k.zsh
  echo ". $HOME/.dotfiles/.p10k.zsh" >> $HOME/.p10k.zsh
}

function init_gitconfig() {
  if [ ! -e $HOME/.gitconfig ]; then
    touch $HOME/.gitconfig
  fi
  if ! grep -q "[user]" $HOME/.gitconfig; then
    echo "[user]" >> $HOME/.gitconfig
    echo "  name = haykh" >> $HOME/.gitconfig
    echo "  email = haykh.mfs+github@gmail.com" >> $HOME/.gitconfig
  fi
}

function init_nvimconfig() {
  if [ ! -e $HOME/.config/nvim ]; then
    ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
  fi
  if [ ! -e $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim +PlugUpdate
  fi
}

function install_virtualenv_if_not_exists() {
  if python3 -m virtualenv --version > /dev/null; then
    echo "virtualenv already installed"
  else
    python3 -m pip install virtualenv
  fi
}

function init_ssh() {
  mkdir -p $HOME/.ssh
  mkdir -p $HOME/.ssh/sockets
  eval "$(ssh-agent -s)"
  include="Include ~/.dotfiles/.ssh/config"
  if [ ! -e $HOME/.ssh/config ]; then
    touch $HOME/.ssh/config
  fi

  if ! grep -q "$include" "$HOME/.ssh/config"; then
    echo "$include" >> $HOME/.ssh/config
  fi
  
  if [ ! -e $HOME/.ssh/id_git ]; then
    ssh-keygen -t ed25519 -C "git" -f $HOME/.ssh/id_git
    ssh-add $HOME/.ssh/id_git
  fi

  if [ ! -e $HOME/.ssh/id_$arch\_ssh ]; then
    ssh-keygen -C "mac-ssh" -f $HOME/.ssh/id_$arch\_ssh
    ssh-add $HOME/.ssh/id_$arch\_ssh
  fi
}

function install_mac_brew() {
  if [ "$subarch" = "m1" ]; then
    brew="/opt/homebrew/bin/brew"
  elif [ "$subarch" = "intel" ]; then
    brew="/usr/local/bin/brew"
  else
    usage
    exit 1
  fi
  if [ -e "$brew" ]; then
    echo "brew is already installed"
  else
    eval 'bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.zprofile
    if [ "$subarch" = "m1" ]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ "$subarch" = "intel" ]; then
      echo 'eval "$(/usr/local/bin/brew shellenv)"' >> $HOME/.zprofile
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
}

function install_mac_iterm2() {
  dir="/Applications/iTerm.app"
  if [ -d "$dir" ]; then
    echo "iTerm2 is already installed"
  else
    wget https://iterm2.com/downloads/stable/latest
    mv latest build
    cd build && unzip latest
    mv iTerm.app /Applications
    cd ..
  fi
}

function brew_install_if_not_exists() {
  find="$(brew ls $1)"
  if [ "$find" = "" ]; then
    brew install $2 $1
  else
    echo "$1 is already installed"
  fi
}

function install_command_line_tools_if_not_exists() {
  if [ ! -e /Library/Developer/CommandLineTools ]; then
    xcode-select --install
  else
    echo "command line tools are already installed"
  fi
}

function mac_copy_keyboard_layouts() {
  if [ ! -d /Library/Keyboard\ Layouts/ArmenianPhonetic.bundle/ ]; then
    sudo cp -r $HOME/.dotfiles/key_layouts/ArmenianPhonetic.bundle /Library/Keyboard\ Layouts/
  else
    echo "ArmenianPhonetic keyboard layout is already installed"
  fi
  if [ ! -d /Library/Keyboard\ Layouts/RussianPhonetic.bundle/ ]; then
    sudo cp -r $HOME/.dotfiles/key_layouts/RussianPhonetic.bundle /Library/Keyboard\ Layouts/
  else
    echo "RussianPhonetic keyboard layout is already installed"
  fi
}

if [ -z "$arch" ]; then
  usage
  exit 1
else
  echo "using configurations for \`$1\`"
fi

if [ "$arch" = "mac" ]; then
  mkdir build
  command "0.1 initialize ssh" "init_ssh"
  command "0.2 initialize gitconfig" "init_gitconfig"
  command "0.3 copy keyboard layouts" "mac_copy_keyboard_layouts"

  command "1. installing zsh" "init_zsh"

  command "2. installing xcode command line tools" "install_command_line_tools_if_not_exists"

  command "3. installing python virtualenv" "install_virtualenv_if_not_exists"

  command "4. installing homebrew" "install_mac_brew"

  command "5.0 installing wget" "brew_install_if_not_exists wget"
  command "5.1 installing nvim" "brew_install_if_not_exists neovim"
  init_nvimconfig
  command "5.2 installing exa" "brew_install_if_not_exists exa"
  command "5.3 installing bat" "brew_install_if_not_exists bat"
  command "5.4 installing chroma" "brew_install_if_not_exists chroma"
  command "5.5 installing bitwarden-cli" "brew_install_if_not_exists bitwarden-cli"
  command "5.6 installing gcc" "brew_install_if_not_exists gcc"
  command "5.7 installing node" "brew_install_if_not_exists node"
  # DEPRECATED: node16 not required anymore
  #command "5.8 installing node@16" "brew_install_if_not_exists node@16"
  command "5.9 installing gitmoji-cli" "npm i -g gitmoji-cli"
  command "5.10 installing gpg" "brew_install_if_not_exists gnupg"
  command "5.11 installing qview" "brew_install_if_not_exists qview"

  command "6. installing iterm2" "install_mac_iterm2"

  command "7.1 installing raycast" "brew_install_if_not_exists raycast --cask"
  command "7.2 installing slack" "brew_install_if_not_exists slack --cask"
  command "7.3 installing bitwarden" "brew_install_if_not_exists bitwarden --cask"
  command "7.4 installing cmake" "brew_install_if_not_exists cmake --cask"
  command "7.5 installing spotify" "brew_install_if_not_exists spotify --cask"
  command "7.6 installing brave" "brew_install_if_not_exists brave-browser --cask"
  command "7.7 installing fontbase" "brew_install_if_not_exists fontbase --cask"
  command "7.8 installing notion" "brew_install_if_not_exists notion --cask"
  command "7.9 installing scroll-reverser" "brew_install_if_not_exists scroll-reverser --cask"
  command "7.10 installing AltTab" "brew_install_if_not_exists alt-tab --cask"
  command "7.11 installing VScode" "brew_install_if_not_exists visual-studio-code --cask"
  command "7.12 installing mpv" "brew_install_if_not_exists mpv --cask"
  command "7.13 installing mos" "brew_install_if_not_exists mos --cask"
  rm -rf build
elif [ "$arch" = "linux" ]; then
  echo "two"
  # init_gitconfig
  # sudo apt install neovim
else
  echo "unknown configuration"
  usage
fi
