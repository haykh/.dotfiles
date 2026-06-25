{ ... }:

{

  # Aggregates every system (NixOS) module. `global.nix` is the always-on base
  # shared by all hosts; the rest declare `my.*` enable options (default off)
  # and are toggled per host. Importing a disabled module emits no config, so
  # this is safe to import everywhere.
  imports = [
    ./global.nix
    ./locale.nix
    ./kvm.nix
    ./desktop/hyprland.nix
    ./desktop/plasma.nix
  ];

}
