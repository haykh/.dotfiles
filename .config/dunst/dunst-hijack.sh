#!/usr/bin/env bash

ICON_PATH=$HOME/.local/share/icons/
MAIN_ICON_THEME=Fluent-dark
ALT_ICON_THEME=Fluent

echo "urgency: "$DUNST_URGENCY >>/tmp/dunst.log
echo "appname: "$DUNST_APP_NAME >>/tmp/dunst.log
echo "id: "$DUNST_ID >>/tmp/dunst.log
echo "icon: "$DUNST_ICON >>/tmp/dunst.log
echo "summary: "$DUNST_SUMMARY >>/tmp/dunst.log
echo "body: "$DUNST_BODY >>/tmp/dunst.log
echo "cat: "$DUNST_CATEGORY >>/tmp/dunst.log
echo "....." >>/tmp/dunst.log
echo "" >>/tmp/dunst.log

icon=$DUNST_ICON
summary=$DUNST_SUMMARY
body=$DUNST_BODY

action_primary=""
action_secondary=""
action=""

action_tag=""

if [[ $DUNST_APP_NAME == "Slack" ]]; then
  icon="slack"
  action_primary="OpenSlack"
  action_tag="default,Open"
elif [[ $DUNST_APP_NAME == "Betterbird" ]]; then
  icon=$(find $ICON_PATH/$MAIN_ICON_THEME -name "better*")
  if [[ $icon == "" ]]; then
    icon=$(find $ICON_PATH/$ALT_ICON_THEME -name "better*")
  fi
  summary=$(echo $summary | sed 's/received.*//')
fi

if [ ! -f /tmp/$DUNST_ID-not ]; then
  if [[ $DUNST_STACK_TAG != "sys-notify" ]]; then
    ACTION=$(
      echo "block" >/tmp/$DUNST_ID-not &&
        dunstify \
          -u "$DUNST_URGENCY" -a "$DUNST_APP_NAME" -i "$icon" \
          -A "$action_tag" \
          -r $DUNST_ID \
          "$summary" "$body" &&
        rm /tmp/$DUNST_ID-not
    )
    case "$ACTION" in
    "default")
      action=$action_primary
      ;;
    esac
  fi
fi

if [[ $action == "OpenSlack" ]]; then
  hyprctl dispatch exec $HOME/.dotfiles/scripts/hypr/launcher -- --slack
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
