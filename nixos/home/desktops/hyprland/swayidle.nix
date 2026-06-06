{ pkgs, ... }:

{

  services.swayidle = {
    enable = true;

    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
    };

    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        timeout = 600;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

}
