{ cfg, ... }:

{

  # Generic home-manager modules, safe to import on every host: each declares a
  # `my.*.enable` option (default off) and emits nothing until a host opts in.
  #
  # Desktops (modules/home/desktops/*) and vicinae (modules/home/vicinae.nix)
  # pull in external flake modules, so they are imported explicitly by the hosts
  # that use them rather than here.
  imports = [
    ./programs
    ./configs
    ./services
  ];

  # Shared base, identical across hosts.
  home.username = cfg.user;
  home.homeDirectory = cfg.home;
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  xdg.mimeApps.enable = true;

}
