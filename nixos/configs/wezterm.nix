{ ... }:

{

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require "wezterm"

      local config = wezterm.config_builder()

      config.color_scheme = "Google Dark (Gogh)"
      config.colors = {
        background = "#0d1117",
      }
      config.font = wezterm.font "MonaspiceKr Nerd Font"
      config.warn_about_missing_glyphs = false

      config.font_rules = {
        {
          intensity = "Bold",
          italic = true,
          font = wezterm.font {
            family = "MonaspiceRn Nerd Font",
            weight = "Bold",
          },
        },
        {
          italic = true,
          intensity = "Half",
          font = wezterm.font {
            family = "MonaspiceRn Nerd Font",
            weight = "Medium",
          },
        },
        {
          italic = true,
          intensity = "Normal",
          font = wezterm.font {
            family = "MonaspiceRn Nerd Font",
          },
        },
      }

      config.enable_wayland = true
      config.front_end = "WebGpu"
      config.webgpu_power_preference = "HighPerformance"

      config.keys = {
        {
          key = "Enter",
          mods = "CTRL|SHIFT",
          action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
        },
        {
          key = "Enter",
          mods = "CTRL|SHIFT|ALT",
          action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
        },
        {
          key = "{",
          mods = "CTRL|SHIFT",
          action = wezterm.action.ActivatePaneDirection "Prev",
        },
        {
          key = "}",
          mods = "CTRL|SHIFT",
          action = wezterm.action.ActivatePaneDirection "Next",
        },
      }

      return config
    '';
  };

}
