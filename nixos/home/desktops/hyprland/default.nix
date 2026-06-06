{ pkgs, ... }:

{

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./dunst.nix
    ./waybar.nix
    ./swayidle.nix
  ];

  home.packages = with pkgs; [
    # screenshots
    grim
    slurp
    swappy

    # clipboard
    wl-clipboard
    cliphist

    # color picker
    hyprpicker

    # tray applets
    networkmanagerapplet
    blueman

    # audio mixer (waybar pulseaudio on-click)
    pavucontrol
  ];

}
