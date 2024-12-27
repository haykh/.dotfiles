{ ... }:

{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      local config = wezterm.config_builder()

      config.color_scheme = 'Brogrammer'
      config.font = wezterm.font 'MonaspiceKr Nerd Font'

      config.enable_wayland = true
      config.front_end = "WebGpu"
      config.webgpu_power_preference = 'HighPerformance'

      config.keys = {
        {
          key = 'Enter',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        {
          key = 'Enter',
          mods = 'CTRL|SHIFT|ALT',
          action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        {
          key = '{',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.ActivatePaneDirection 'Prev',
        },
        {
          key = '}',
          mods = 'CTRL|SHIFT',
          action = wezterm.action.ActivatePaneDirection 'Next',
        },
      }

      return config
    '';
  };
}
