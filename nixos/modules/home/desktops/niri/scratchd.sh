# niri-scratchd: background helper for the scratchpads (./scratch.sh), run as
# a systemd user service following niri's event stream.
#
# 1. Keeps the "stash" workspace behind every workspace you use, so niri's
#    workspace numbers (shown in the bar) match SUPER+<n> (./workspace.sh
#    skips the stash when counting). Whenever a workspace below the stash
#    holds windows or is the one you're on, the stash is moved after it.
#
# 2. Scratchpad windows have an `opacity 0.1` window rule: that's their look
#    while sliding away, so they're nearly invisible by the time niri stops
#    them (it keeps >= 75px of a floating window on screen). niri applies the
#    rule to every new such window, so the first time one is seen, the rule is
#    switched off for it (toggle-window-rule-opacity) to make it opaque.
#    Which windows have it switched off is tracked in a per-session state dir
#    shared with ./scratch.sh, as niri doesn't report it.
#
# NIRI_SCRATCHPADS / NIRI_SCRATCH_STASH override the table / stash name.

table=${NIRI_SCRATCHPADS:-$scratchpads_json}
stash=${NIRI_SCRATCH_STASH:-stash}
state=${XDG_RUNTIME_DIR:-/tmp}/niri-scratch/$(basename "${NIRI_SOCKET:-niri}")
mkdir -p "$state"

fix_stash() {
  local target
  target=$(niri msg --json workspaces | jq --arg n "$stash" '
    (map(select(.name == $n)) | first) as $s
    | if $s == null then empty else
        ([ .[] | select(.output == $s.output and (.active_window_id != null or .is_active)) | .idx ]
         | max) as $t
        | if $t != null and $t > $s.idx then $t else empty end
      end')
  if [[ -n $target ]]; then
    niri msg action move-workspace-to-index --reference "$stash" "$target"
  fi
}

# stdin: a JSON array of windows. Makes newly seen scratchpad windows opaque.
claim() {
  local id
  jq -r --slurpfile t "$table" '
    .[] | . as $w
    | select(any($t[0][]; . as $e
        | (($w.app_id // "") | test($e.app_id))
          and ($e.title == "" or (($w.title // "") | test($e.title)))))
    | .id' |
    while read -r id; do
      if [[ ! -e $state/seen-$id ]]; then
        touch "$state/seen-$id"
        niri msg action toggle-window-rule-opacity --id "$id"
        touch "$state/opaque-$id"
      fi
    done
}

# When a rebuild (re)starts this service, niri may not have picked up the new
# config.kdl yet (it polls every 500ms). A toggle before the opacity rule
# exists does nothing, and the record above would then be inverted, so give
# niri time to load it first.
sleep 1.5

fix_stash
niri msg --json event-stream | while read -r line; do
  case $line in
  '{"Workspace'*) fix_stash ;;
  '{"WindowsChanged"'*) jq '.WindowsChanged.windows' <<<"$line" | claim ;;
  '{"WindowOpenedOrChanged"'*) jq '[.WindowOpenedOrChanged.window]' <<<"$line" | claim ;;
  '{"WindowClosed"'*)
    id=$(jq '.WindowClosed.id' <<<"$line")
    rm -f "$state/seen-$id" "$state/opaque-$id"
    ;;
  esac
done
