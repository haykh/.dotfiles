{ ... }:

# Every desktop's home side. Each one is inert unless the host enables it on
# the system side (my.desktops.<name>.enable in hosts/*/default.nix), so
# switching desktops is a change to that one option.
{

  imports = [
    ./common.nix
    ./noctalia.nix
    ./hyprland
    ./niri
  ];

}
