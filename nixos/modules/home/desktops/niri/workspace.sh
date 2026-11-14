# niri-ws focus N | move N | down | up
#
# Workspace navigation that never lands on the scratchpad "stash" workspace
# (./scratch.sh), which is a real niri workspace:
#
#   focus N   go to your Nth workspace on this monitor, not counting the stash
#             (past the last one: the empty workspace niri keeps at the bottom)
#   move N    same, taking the focused window along
#   down/up   focus the window below/above; at the edge of the column, the next
#             workspace below/above, skipping the stash
#
# Touchpad swipes, SUPER+middle-drag and the overview can still reach it; the
# scratchpad script copes with that (see its header).
#
# NIRI_SCRATCH_STASH overrides the stash name.

stash=${NIRI_SCRATCH_STASH:-stash}
cmd=$1

# Index (niri's idx) of every workspace on the focused monitor except the
# stash, top to bottom.
own_workspaces() {
  niri msg --json workspaces | jq --arg n "$stash" '
    (.[] | select(.is_focused) | .output) as $o
    | [ .[] | select(.output == $o and .name != $n) ] | sort_by(.idx) | map(.idx)'
}

# The idx of your Nth workspace, clamped to the last one.
nth() {
  own_workspaces | jq --argjson n "$1" '.[([$n, length] | min) - 1]'
}

case $cmd in
focus)
  niri msg action focus-workspace "$(nth "$2")"
  ;;
move)
  niri msg action move-window-to-workspace "$(nth "$2")"
  ;;
down | up)
  before=$(niri msg --json focused-window | jq '.id // null')
  niri msg action "focus-window-$cmd"
  after=$(niri msg --json focused-window | jq '.id // null')
  if [[ $before == "$after" ]]; then
    # At the edge of the column: on to the neighbouring workspace.
    current=$(niri msg --json workspaces | jq '.[] | select(.is_focused) | .idx')
    if [[ $cmd == down ]]; then
      target=$(own_workspaces | jq --argjson c "$current" 'map(select(. > $c)) | first // empty')
    else
      target=$(own_workspaces | jq --argjson c "$current" 'map(select(. < $c)) | last // empty')
    fi
    if [[ -n $target ]]; then
      niri msg action focus-workspace "$target"
    fi
  fi
  ;;
*)
  echo "usage: niri-ws focus N | move N | down | up" >&2
  exit 1
  ;;
esac
