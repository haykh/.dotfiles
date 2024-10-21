#!/usr/bin/env bash

if [ ! -f /tmp/$DUNST_ID-not ]; then
  if [[ $DUNST_STACK_TAG != "sys-notify" ]]; then
    ACTION=$(
      echo "block" >/tmp/$DUNST_ID-not &&
        dunstify \
          -u "$DUNST_URGENCY" -a "$DUNST_APP_NAME" -i "$DUNST_ICON" \
          -A "default,Open" \
          -r $DUNST_ID \
          "Summary: $DUNST_SUMMARY" "Body: $DUNST_BODY $DUNST_CATEGORY" &&
        rm /tmp/$DUNST_ID-not
    )
  fi
fi

# if [[ "$1" == "Slack" ]]; then
#
#   ACTION=$(
#     dunstify \
#       -u "$5" -a "Slack" -i "slack" \
#       -A "default,Open" \
#       "$2" "$3"
#   )
#
#   case "$ACTION" in
#   "default")
#     hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --slack
#     ;;
#   esac
#
# elif [[ "$1" == "Betterbird" ]]; then
#
#   ACTION=$(
#     dunstify \
#       -u "$5" -a "Betterbird" -i "email" \
#       -t 10000 \
#       -A "default,Open" \
#       "$2" "$3"
#   )
#
#   case "$ACTION" in
#   "default")
#     hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --thunderbird
#     ;;
#   esac
#
# elif [[ "$1" == "Spotify" ]]; then
#
#   artUrl=$(echo "$(playerctl metadata)" | grep -oP 'artUrl\K.*$' | tr -d ' ')
#   old_artUrl=$(cat /tmp/player_artUrl)
#   if [ "$artUrl" != "$old_artUrl" ]; then
#     wget --output-document /tmp/player_album "$artUrl"
#     echo "$artUrl" >/tmp/player_artUrl
#   fi
#
#   ACTION=$(
#     dunstify \
#       -h string:x-dunst-stack-tag:$artUrl \
#       -I "/tmp/player_album" \
#       -A "default,Open" \
#       "$2" "$3"
#   )
#
#   case "$ACTION" in
#   "default")
#     hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --spotify
#     ;;
#   esac
#
# elif [[ "$1" == "battery-low" ]]; then
#
#   echo 'зарадка болшэ нэт' |
#     /opt/piper-tts/piper --model $HOME/Music/voices/ka_GE-natia-medium.onnx --output-raw |
#     aplay -r 22050 -f S16_LE -t raw -
#
# else
#
#   dunstify "$@"
#
# fi
