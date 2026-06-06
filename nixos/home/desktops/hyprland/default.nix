{ pkgs, ... }:

{

  imports = [
    ./hyprland.nix
    # ./hyprlock.nix  # Noctalia provides the lockscreen (lockScreen IPC).
    ./noctalia.nix
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
