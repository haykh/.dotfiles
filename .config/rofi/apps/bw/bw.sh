#!/usr/bin/env bash

TMP_DIR=$HOME/.config/tmp
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

theme_str() {
  printf "
    entry { 
      placeholder: \"%s\";
    }
    @import \"$SCRIPT_DIR/bw.rasi\"
  " "$1"
}

not_daemon() {
  if command -v dunstify &>/dev/null; then
    dunstify "$@"
  else
    notify-send "$@"
  fi
}

notify() {
  not_daemon -u normal -i bitwarden "$1" "$2"
}

alert() {
  not_daemon -u critical -i bitwarden "$1" "$2"
}

function bw_command() {
  PATH=$PATH:$1 BITWARDENCLI_APPDATA_DIR=$HOME/.bw/ NODE_OPTIONS="--no-deprecation" bw ${@:2}
}

NODE_NOT_FOUND_MSG="node not found in your path, please enter the directory to node bin
  e.g. $HOME/.nvm/versions/node/v22.4.1/bin"

BW_NOT_FOUND_MSG() {
  echo "bitwarden-cli not found in $1
please install with \`npm i -g @bitwarden/cli\`"
}

PASS_NOT_FOUND_MSG() {
  echo "session $1 not found in pass
please add the session to pass:
  \`\$ pass insert $1\`
or change the default session name above"
}

bw_search() {
  if ! command -v $(node_path)node &>/dev/null; then
    if [ ! -f $TMP_DIR/rofi_bw_node ]; then
      local node_path=$(
        rofi -dmenu \
          -p "" \
          -mesg "$NODE_NOT_FOUND_MSG" \
          -theme-str "$(theme_str "path to node")" -no-fixed-num-lines
      )
      if [ -z "$node_path" ] || ! command -v $node_path/node &>/dev/null; then
        alert "rofi bw" "wrong path provided"
        exit 1
      fi
      echo $node_path >$TMP_DIR/rofi_bw_node
      notify "rofi bw" "node path saved to $TMP_DIR/rofi_bw_node"
    else
      node_path=$(cat $TMP_DIR/rofi_bw_node)
    fi
  fi

  if ! command -v bw_command -v &>/dev/null; then
    alert "rofi bw" "$(BW_NOT_FOUND_MSG $node_path)"
    exit 1
  fi

  if [ ! -f $TMP_DIR/rofi_bw_session_name ]; then
    echo "bw_session" >$TMP_DIR/rofi_bw_session_name
  fi

  local bw_session_name=$(cat /$TMP_DIR/rofi_bw_session_name)

  if ! pass ls | grep -q $bw_session_name; then
    local new_session_name=$(
      rofi -dmenu \
        -i -p "" \
        -mesg "$(PASS_NOT_FOUND_MSG $bw_session_name)" \
        -theme-str "$(theme_str "session name")" -no-fixed-num-lines
    )

    if [ -z "$new_session_name" ]; then
      exit 1
    fi
    echo $new_session_name >$TMP_DIR/rofi_bw_session_name
    bw_session_name=$new_session_name
    notify "rofi bw" "name of bw session in pass has been saved to $TMP_DIR/rofi_bw_session_name"
  fi

  local prompt=$(rofi -i -p "" -dmenu -no-fixed-num-lines -theme-str "$(theme_str "search bitwarden")")
  if [ -z "$prompt" ]; then
    exit 1
  fi
  local items=$(bw_command $node_path --session=$(pass $bw_session_name) list items --search $prompt)
  local nitems=$(jq -r '. | length' <<<${items})
  if [[ $nitems -eq 1 ]]; then
    (jq -r '.[].login.username' <<<$items) | tr -d '\n' | wl-copy
    (jq -r '.[].login.password' <<<$items) | tr -d '\n' | wl-copy -p
    notify \
      "$(jq -r '.[].name' <<<$items)" \
      "$(jq -r '"  usr: " + .[].login.username' <<<$items)\n  password: \{clipboard\}"
  else
    local idx=$(
      echo $items |
        jq -r 'to_entries | .[] | .value.name + " -- " + .value.login.username' |
        rofi -i -p "" -dmenu -no-fixed-num-lines \
          -format i -theme-str "$(theme_str "pick the entry")"
    )
    if [ -z "$idx" ]; then
      exit 1
    fi
    if [[ $idx -ge $nitems ]]; then
      alert "bitwarden" "invalid index"
      exit 1
    fi
    (jq -r ".[$idx].login.username" <<<$items) | tr -d '\n' | wl-copy
    (jq -r ".[$idx].login.password" <<<$items) | tr -d '\n' | wl-copy -p
    notify \
      "$(jq -r ".[$idx]"' | .name' <<<$items)" \
      "$(jq -r ".[$idx]"' | "  usr: " + .login.username' <<<$items)\n  password: \{clipboard\}"
  fi
}

bw_search
