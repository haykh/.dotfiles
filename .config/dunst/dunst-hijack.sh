#!/usr/bin/env bash

if [ "$1" == "Slack" ]; then
  ACTION=$(
    dunstify \
      -u "$5" -a "Slack" -i "slack" \
      -A "default,Open" \
      "$2" "$3"
  )

  case "$ACTION" in
  "default")
    hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --slack
    ;;
  esac
elif [ "$1" == "Betterbird" ]; then
  ACTION=$(
    dunstify \
      -u "$5" -a "Betterbird" -i "email" \
      -t 10000 \
      -A "default,Open" \
      "$2" "$3"
  )

  case "$ACTION" in
  "default")
    hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --thunderbird
    ;;
  esac
elif [ "$1" == "Spotify" ]; then
  artUrl=$(echo "$(playerctl metadata)" | grep -oP 'artUrl\K.*$' | tr -d ' ')
  old_artUrl=$(cat /tmp/player_artUrl)
  if [ "$artUrl" != "$old_artUrl" ]; then
    wget --output-document /tmp/player_album "$artUrl"
    echo "$artUrl" >/tmp/player_artUrl
  fi

  ACTION=$(
    dunstify \
      -h string:x-dunst-stack-tag:$artUrl \
      -I "/tmp/player_album" \
      -A "default,Open" \
      "$2" "$3"
  )

  case "$ACTION" in
  "default")
    hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --spotify
    ;;
  esac
fi
