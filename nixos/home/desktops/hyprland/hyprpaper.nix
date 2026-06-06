{ cfg, ... }:

{

  # hyprpaper 0.8.4 has a broken parser for `wallpaper = monitor,path` lines —
  # nothing in the config gets bound to outputs. So we only `preload` here and
  # let hyprland.nix `exec-once` push the wallpaper to every active monitor
  # via `hyprctl hyprpaper wallpaper` after the compositor is up.
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = [ cfg.gtktheme.wallpaper ];
    };
  };

}
