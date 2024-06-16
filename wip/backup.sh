#!/bin/sh

function usage() {
  echo "usage: \`$0 [mac|linux] <subarch>\`"
  echo "   ... where <subarch> is optional:"
  echo "       - [m1|intel] for mac"
  echo "       - [apt|pacman|src] for linux"
}

arch=$1
subarch=$2

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

function mac_backup_app_support() {
  zipfile=$HOME/.dotfiles/backup/mac/$subarch/"$1".zip
  mkdir -p $HOME/.dotfiles/backup/mac/$subarch/
  if [ -e "$zipfile" ]; then
    rm -f "$zipfile"
  fi
  if [ -d $HOME/Library/Application\ Support/"$1" ]; then
    zip -r "$zipfile" $HOME/Library/Application\ Support/"$1" > /dev/null
    echo "backed up $1"
  else
    echo $HOME/Library/Application\ Support/"$1"
    echo "No $1 found in Application Support"
  fi
}

if [ -z "$arch" ]; then
  usage
  exit 1
else
  echo "using configurations for \`$1\`"
fi

if [ "$arch" = "mac" ]; then
  mkdir -p backup/mac/$subarch
  command "1. backup Bitwarden" "mac_backup_app_support Bitwarden"
  command "2. backup Bitwarden CLI" ""
  mac_backup_app_support "Bitwarden CLI"
  command "" "cd ."
  command "3. backup Slack" "mac_backup_app_support Slack"
  command "4. backup Spotify" "mac_backup_app_support Spotify"
  command "5. backup Notion" "mac_backup_app_support Notion"
  command "6. backup FontBase" "mac_backup_app_support FontBase"
  command "7. backup BraveSoftware" "mac_backup_app_support BraveSoftware"
  command "8. backup iTerm2" "mac_backup_app_support iTerm2"
  command "9. backup Raycast" "mac_backup_app_support com.raycast.macos"
elif [ "$arch" = "linux" ]; then
  echo "two"
  # init_gitconfig
  # sudo apt install neovim
else
  echo "unknown configuration"
  usage
fi