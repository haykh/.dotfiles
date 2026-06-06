{
  pkgs,
  config,
  lib,
  ...
}:

let
  # Full path — swayidle runs as a systemd user service with a minimal PATH,
  # and a failed lock-before-sleep would suspend unlocked.
  lock = "${lib.getExe config.programs.noctalia-shell.package} ipc call lockScreen lock";
in
{

  services.swayidle = {
    enable = true;

    events = {
      before-sleep = lock;
    };

    timeouts = [
      {
        timeout = 300;
        command = lock;
      }
      {
        timeout = 600;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

}
