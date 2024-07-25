#!/bin/sh

# metadata about the status of the player is stored in /tmp/player_* and is read when render is called

interpret_time() {
  min=$(echo "$1 / 60 / 1000000" | bc)
  sec=$(echo "$1 / 1000000 % 60" | bc)
  printf "%02d:%02d" "$min" "$sec"
}

roll() {
  len=${#1}
  tolen=$2
  if [ $len -le $tolen ]; then
    echo $1
  else
    delta=$(($len - $tolen))
    if [ $(($delta % 2)) -eq 0 ]; then
      delta=$(($delta + 1))
    fi
    lcrop=$((($(date +%s) % $delta - $delta / 2) * 2))
    lcrop=${lcrop#-}
    rcrop=$(($delta - $lcrop))
    if [ $lcrop -gt 0 ]; then
      lfill="…"
    else
      lfill=""
    fi
    if [ $rcrop -le 1 ]; then
      rfill=""
      rcrop=$len
    else
      rfill="…"
      rcrop=$((-$rcrop))
    fi
    echo $lfill${1:$lcrop:$rcrop}$rfill
  fi
}

trim() {
  read -r var
  echo "$var" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

update_metadata() {
  active_player=$(playerctl -l | head -n 1)
  if [ -z "$active_player" ]; then
    echo "" > /tmp/player_active
    echo "" > /tmp/player_metadata
    echo "" > /tmp/player_status
    echo "" > /tmp/player_seek
  fi
  echo $active_player > /tmp/player_active

  metadata=$(playerctl metadata)
  if [[ "$metadata" != "" ]]; then
    echo "$metadata" > /tmp/player_metadata
  fi
  can_seek=$(qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.CanSeek)
  if [ "$can_seek" = "true" ]; then
    length=$(echo "$metadata" | grep -oP 'length\K.*$' | tr -d ' ')
    length=$(interpret_time "$length")
    position=$(qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Position)
    position=$(interpret_time "$position")
    seek="$position / $length"
  else
    seek=""
  fi
  echo $seek > /tmp/player_seek

  status=$(qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus) 
  if [[ "$status" != "" ]]; then
    echo $status > /tmp/player_status
  fi
}

check_if_active() {
  player=$(cat /tmp/player_active)
  metadata=$(cat /tmp/player_metadata)
  if [ -z "$player" ] || [ -z "$metadata" ]; then
    echo 1
  else
    echo 0
  fi
}

render() {
  active_player=$(cat /tmp/player_active)
  if [ -z "$active_player" ]; then
    exit 1
  else
    metadata=$(cat /tmp/player_metadata)
    status=$(cat /tmp/player_status)
    seek=$(cat /tmp/player_seek)

    title=$(echo "$metadata" | grep -oP 'title\K.*$' | trim)
    artist=$(echo "$metadata" | grep -oP 'artist\K.*$' | trim)
    album=$(echo "$metadata" | grep -oP 'album\K.*$' | trim)

    title=$(echo "$title" | sed 's/\[.*\]//')

    if [[ $active_player == *"firefox"* ]]; then
      player_icon="󰈹"
    elif [[ $active_player == *"mpv"* ]]; then
      player_icon=""
    elif [[ $active_player == *"spotify"* ]]; then
      player_icon=""
    elif [[ $active_player == *"vlc"* ]]; then
      player_icon="󰕼"
    else
      player_icon=""
    fi

    if [ "$status" = "Playing" ]; then
      status_icon=""
    elif [ "$status" = "Paused" ]; then
      status_icon=""
    fi

    text=$(echo \
      "<tt><big>"$player_icon"</big></tt>"\
      "<span font=\"6px\">"$status_icon"</span> " \
      $(roll "$title" 15) "|" $(roll "$artist" 13))

    if [ -z "$album" ]; then
      tooltip_album=""
    else
      tooltip_album=$(echo -e "\n:: <i>$album</i>")
    fi

    tooltip=$(echo -e ".. $title $seek\n.: $artist$tooltip_album")

    jq -n -c --arg TEXT "$text" --arg TOOLTIP "$tooltip" \
      '{
          text: $TEXT,
          tooltip: $TOOLTIP,
          # class: $CLASS
        }'
  fi
}

update_metadata

if [[ "$1" == "--check" ]]; then
  exit $(check_if_active)
elif [[ "$1" == "--play-pause" ]]; then
  playerctl play-pause
elif [[ "$1" == "--next" ]]; then
  playerctl next
else
  render
fi
