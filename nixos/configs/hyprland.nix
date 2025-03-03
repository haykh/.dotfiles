{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
      ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
