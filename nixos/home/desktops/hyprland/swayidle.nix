{
  pkgs,
  config,
  lib,
  ...
}:

let
  lock = "${lib.getExe config.programs.noctalia.package} msg session lock";
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
