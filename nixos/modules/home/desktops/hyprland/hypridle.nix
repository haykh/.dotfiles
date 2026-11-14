{
  config,
  osConfig,
  lib,
  ...
}:

let
  lock = "${lib.getExe config.programs.noctalia.package} msg session lock";
  # The running compositor's hyprctl (the flake's Hyprland), not nixpkgs'
  # older pkgs.hyprland.
  hyprctl = "${osConfig.programs.hyprland.package}/bin/hyprctl";
  # The Lua config wraps the argument as hl.dispatch(<arg>), so it must be a
  # dispatcher expression; a bare "on" string would mean toggle.
  dpms = action: "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"${action}\" })'";
  # kickVRR() (hyprland.nix) recovers frame pacing that goes stale after a
  # DPMS off/on cycle.
  screenOn = "${dpms "on"}; ${hyprctl} eval 'kickVRR()'";
in
{

  config = lib.mkIf osConfig.my.desktops.hyprland.enable {

    services.hypridle = {
      enable = true;

      settings = {
        general = {
          # Avoid the "red screen" double-lock if noctalia is already locked.
          lock_cmd = "pidof noctalia || ${lock}";
          before_sleep_cmd = lock;
          after_sleep_cmd = screenOn;

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
            on-resume = screenOn;
          }
        ];
      };
    };

  };

}
