{
  pkgs,
  config,
  lib,
  ...
}:

let
  lock = "${lib.getExe config.programs.noctalia.package} msg session lock";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  # The Lua config wraps the argument as hl.dispatch(<arg>), so it must be a
  # dispatcher expression; a bare "on" string would mean toggle.
  dpms = action: "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";
in
{

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # Avoid the "red screen" double-lock if noctalia is already locked.
        lock_cmd = "pidof noctalia || ${lock}";
        before_sleep_cmd = lock;
        after_sleep_cmd = dpms "on";

        # Respect idle inhibitors (e.g. fullscreen browser video).
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };

      listener = [
        {
          timeout = 300;
          on-timeout = lock;
        }
        {
          timeout = 600;
          on-timeout = dpms "off";
          on-resume = dpms "on";
        }
      ];
    };
  };

}
