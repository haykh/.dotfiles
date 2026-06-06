{ inputs, ... }:

{

  imports = [ inputs.noctalia.homeModules.default ];

  # Noctalia — Quickshell-based bar/shell, replaces waybar. Autostarted from
  # Hyprland's exec-once (see hyprland.nix); the module's systemd integration
  # is deprecated upstream, so we don't enable it.
  #
  # Configure interactively via Noctalia's settings panel, or declaratively
  # here through `settings` / `colors` (written to ~/.config/noctalia/*.json).
  programs.noctalia-shell = {
    enable = true;

    # Declare plugin sources + enabled plugins. Noctalia auto-installs any
    # enabled-but-missing plugin into ~/.config/noctalia/plugins/ on startup
    # (needs network on first run). workspace-overview is toggled by Super+W
    # (see hyprland.nix).
    plugins = {
      version = 2;
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        workspace-overview = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        protonvpn = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };
  };

}
