{ pkgs, cfg, ... }:

{

  systemd.user.services.thunar-shim = {
    Unit = {
      Description = "Thunar FileManager1 D-Bus Shim";
    };
    Service = {
      ExecStart = "${pkgs.nix}/bin/nix-shell -p python3 python3Packages.dbus-python python3Packages.pygobject3 gobject-introspection
        --run ${cfg.home}/.local/bin/thunar-shim.py";
      Restart = "always";
      RestartSec = 5;
      Environment = "DISPLAY=:0";
    };
    Install.WantedBy = [ "default.target" ];
  };

}
