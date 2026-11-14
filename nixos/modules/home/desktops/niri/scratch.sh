# niri-scratch NAME
#
# Quake-style scratchpads for niri, like Hyprland's special workspaces: one
# key per app slides it down over whatever you're doing, the same key slides
# it back up. Only one scratchpad shows at a time; bringing up another slides
# the current one away.
#
#   not running              -> launch it (window rules float it centered)
#   on the focused workspace -> slide it up and park it
#   anywhere else            -> slide it down onto the focused workspace
#
# niri can't hide a window in place (it keeps >= 75px of a floating window on
# screen, has no minimize and no hidden workspaces), so parked windows live on
# a named "stash" workspace. It is created on demand from the empty workspace
# niri keeps at the bottom of the focused monitor, kept last (by
# ./scratchd.sh), and dropped again (unnamed, so niri removes it) once empty.
# If you land on it and park a window from there, it becomes a normal
# workspace and a fresh stash is made.
#
# The slide mimics Hyprland's `slidefadevert` special-workspace animation:
# the motion is niri's window-movement animation (Hyprland's "overshot" curve,
# see animations {} in ./default.nix), and the fade is the scratchpads'
# `opacity 0.1` window rule, switched on as a window starts sliding away and
# off as it lands (niri can't animate it). ./scratchd.sh switches it off for
# new windows and shares the record of which windows are opaque.
#
# The scratchpads come from a JSON table (set up in ./default.nix):
#   { "<name>": { "app_id": <regex>, "title": <regex or "">, "cmd": [...] } }
# NIRI_SCRATCHPADS / NIRI_SCRATCH_STASH override the table / stash name.

name=$1
table=${NIRI_SCRATCHPADS:-$scratchpads_json}
stash=${NIRI_SCRATCH_STASH:-stash}
state=${XDG_RUNTIME_DIR:-/tmp}/niri-scratch/$(basename "${NIRI_SOCKET:-niri}")
mkdir -p "$state"
# niri's window-movement animation length (animations {} in ./default.nix),
# so a window finishes sliding up before it is parked.
slide=0.3
# How far into the slide-in the window turns opaque again. The curve covers
# most of the distance early, so this reads as fading in on the way down.
land=0.1

# Fade (opacity rule on) / unfade (rule off), tracked in $state.
fade() {
  if [[ -e $state/opaque-$1 ]]; then
    niri msg action toggle-window-rule-opacity --id "$1"
    rm -f "$state/opaque-$1"
  fi
}
unfade() {
  if [[ ! -e $state/opaque-$1 ]]; then
    niri msg action toggle-window-rule-opacity --id "$1"
    touch "$state/opaque-$1"
  fi
}

if ! jq -e --arg n "$name" 'has($n)' "$table" >/dev/null; then
  echo "niri-scratch: unknown scratchpad '$name'" >&2
  exit 1
fi

workspaces=$(niri msg --json workspaces)
focused_ws=$(jq '.[] | select(.is_focused) | .id' <<<"$workspaces")
focused_idx=$(jq '.[] | select(.is_focused) | .idx' <<<"$workspaces")
focused_output=$(jq -r '.[] | select(.is_focused) | .output' <<<"$workspaces")
stash_id=$(jq --arg n "$stash" '[.[] | select(.name == $n) | .id] | first // empty' <<<"$workspaces")

# Every open scratchpad window: [{id, name, ws, floating}]
scratch=$(niri msg --json windows | jq --slurpfile t "$table" '
  . as $wins
  | [ $t[0] | to_entries[] as $e
      | $wins[]
      | select((.app_id // "") | test($e.value.app_id))
      | select(($e.value.title // "") == "" or ((.title // "") | test($e.value.title)))
      | {id, name: $e.key, ws: .workspace_id, floating: .is_floating} ]')

# This scratchpad's window, preferring one on the focused workspace.
target=$(jq -c --arg n "$name" --argjson f "$focused_ws" '
  [ .[] | select(.name == $n) ] | (map(select(.ws == $f)) + .) | first // empty
' <<<"$scratch")
# Other scratchpads currently showing here.
mapfile -t others < <(jq -c --arg n "$name" --argjson f "$focused_ws" '
  .[] | select(.name != $n and .ws == $f)
' <<<"$scratch")

ensure_stash() {
  if [[ -n $stash_id && $stash_id == "$focused_ws" ]]; then
    # You're on the stash itself, so it's in use as a normal workspace now.
    niri msg action unset-workspace-name "$stash"
    stash_id=
  fi
  if [[ -z $stash_id ]]; then
    # Index references resolve on the focused monitor; its last workspace is
    # the empty one niri always keeps at the bottom.
    local last
    last=$(niri msg --json workspaces | jq --arg o "$focused_output" '[.[] | select(.output == $o) | .idx] | max')
    niri msg action set-workspace-name --workspace "$last" "$stash"
    stash_id=$(niri msg --json workspaces | jq --arg n "$stash" '.[] | select(.name == $n) | .id')
  fi
}

# hide '{"id":..,"floating":..}': fade, slide up off the top edge, then park.
hide() {
  local id floating
  id=$(jq '.id' <<<"$1")
  floating=$(jq '.floating' <<<"$1")
  fade "$id"
  if [[ $floating == true ]]; then
    niri msg action move-floating-window --id "$id" -y -10000
    sleep "$slide"
  fi
  niri msg action move-window-to-workspace --window-id "$id" --focus false "$stash"
}

# show '{"id":..,"floating":..}': bring it here (faded) from above the top
# edge, let it slide down to the center and turn opaque on the way.
show() {
  local id floating
  id=$(jq '.id' <<<"$1")
  floating=$(jq '.floating' <<<"$1")
  if [[ $floating == true ]]; then
    # Still on the stash (out of sight): start it above the top edge.
    niri msg action move-floating-window --id "$id" -y -10000
  fi
  niri msg action move-window-to-workspace --window-id "$id" --focus false "$focused_idx"
  niri msg action focus-window --id "$id"
  if [[ $floating == true ]]; then
    niri msg action center-window --id "$id"
    sleep "$land"
  fi
  unfade "$id"
}

hide_others() {
  if ((${#others[@]})); then
    ensure_stash
    for o in "${others[@]}"; do
      hide "$o" &
    done
  fi
}

if [[ -z $target ]]; then
  hide_others
  wait
  mapfile -t cmd < <(jq -r --arg n "$name" '.[$n].cmd[]' "$table")
  niri msg action spawn -- "${cmd[@]}"
elif [[ $(jq '.ws' <<<"$target") == "$focused_ws" ]]; then
  ensure_stash
  hide "$target"
else
  hide_others
  show "$target"
  wait
fi

# Drop an emptied stash. (Keeping it last is ./stash-keeper.sh's job.)
stash_id=$(niri msg --json workspaces | jq --arg n "$stash" '[.[] | select(.name == $n) | .id] | first // empty')
if [[ -n $stash_id ]]; then
  left=$(niri msg --json windows | jq --argjson s "$stash_id" '[.[] | select(.workspace_id == $s)] | length')
  if [[ $left == 0 ]]; then
    niri msg action unset-workspace-name "$stash"
  fi
fi
