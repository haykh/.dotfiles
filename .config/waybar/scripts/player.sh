#!/bin/sh

if [[ "$1" == "--update" ]]; then
  active_player=$(playerctl -l | head -n 1)
  if [ -z "$active_player" ]; then
    echo "" > /tmp/player_active
    echo "" > /tmp/player_metadata
    echo "" > /tmp/player_status
    echo "" > /tmp/player_seek
    exit 1
  fi
  echo $active_player > /tmp/player_active

  if [[ "$2" == "metadata" ]]; then
    qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata > /tmp/player_metadata
    can_seek=$(qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.CanSeek)
    if [ "$can_seek" = "true" ]; then
      length=$(cat /tmp/player_metadata | grep -oP 'length: \K.*$')
      length=$(interpret_time "$length")
      position=$(qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Position)
      position=$(interpret_time "$position")
      seek="$position / $length"
    else
      seek=""
    fi
    echo $seek > /tmp/player_seek
  else 
    qdbus org.mpris.MediaPlayer2.${active_player} /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus > /tmp/player_status 2> /tmp/player_status
  fi
  exit 0
else
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
      return
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

  active_player=$(cat /tmp/player_active)

  if [ -z "$active_player" ]; then
    exit 1
  else
    metadata=$(cat /tmp/player_metadata)
    status=$(cat /tmp/player_status)
    seek=$(cat /tmp/player_seek)

    title=$(echo "$metadata" | grep -oP 'title: \K.*$')
    artist=$(echo "$metadata" | grep -oP 'artist: \K.*$')
    album=$(echo "$metadata" | grep -oP 'album: \K.*$')

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
  exit 0
fi
