{
  lib,
  pkgs,
  osConfig,
  ...
}:

# Tools shared by every Wayland desktop (Hyprland, niri). Active when either
# is enabled on the host.

let
  desktops = osConfig.my.desktops;
in
{

  config = lib.mkIf (desktops.hyprland.enable || desktops.niri.enable) {

    home.packages = with pkgs; [
      # screenshots (grim capture + slurp region + satty annotate)
      grim
      slurp
      satty

      # clipboard
      wl-clipboard
      cliphist

      # color picker
      hyprpicker

      # tray applets
      networkmanagerapplet
      blueman

      # audio mixer
      pavucontrol

      # media key control
      playerctl
    ];

    # Ensure the screenshot save folder exists (satty --output-filename target).
    home.file."Pictures/Screenshots/.keep".text = "";

  };

}
