{
  lib,
  pkgs,
  osConfig,
  ...
}:

# Hyprland desktop (home side). Active only when the host enables
# my.desktops.hyprland (modules/system/desktop/hyprland.nix); the rest of the
# time it stays in the tree, inert, so switching back is a one-line change.

let
  # Wraps hyprland-share-picker: a selection made within the last 20s is
  # returned without prompting (see xdph.conf below). Cancelled picks
  # (no [SELECTION] line) are not cached.
  sharePicker = pkgs.writeShellScript "share-picker-cached" ''
    cache="''${XDG_RUNTIME_DIR:-/tmp}/xdph-last-selection"
    if [ -f "$cache" ] && [ $(( $(date +%s) - $(stat -c %Y "$cache") )) -lt 20 ]; then
      cat "$cache"
      exit 0
    fi
    out=$(${osConfig.programs.hyprland.portalPackage}/bin/hyprland-share-picker "$@")
    status=$?
    case "$out" in
      *"[SELECTION]"*) printf '%s\n' "$out" > "$cache" ;;
    esac
    printf '%s\n' "$out"
    exit $status
  '';
in
{

  imports = [
    ./hyprland.nix
    ./hypridle.nix
    ./minimize.nix
  ];

  config = lib.mkIf osConfig.my.desktops.hyprland.enable {

    # Electron/Chromium screen share (Slack, etc.) opens several portal sessions
    # per share. Sessions that carry a restore token skip the picker, which
    # xdph's picker only hands out when its "allow restore token" box is ticked,
    # so tick it by default. Slack's own source picker still opens ~3 fresh
    # sessions without a token per share, so the picker is also wrapped to reuse
    # the last selection for a few seconds instead of prompting again.
    # xdph still reads hyprlang, independent of Hyprland's Lua config.
    xdg.configFile."hypr/xdph.conf".text = ''
      screencopy {
        allow_token_by_default = true
        custom_picker_binary = ${sharePicker}
      }
    '';

  };

}
