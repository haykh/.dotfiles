{ pkgs, ... }:

{

  imports = [
    ./hyprland.nix
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

    # audio mixer
    pavucontrol

    # media key control
    playerctl
  ];

}
