local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_domain = 'WSL:Arch'
config.color_scheme = 'Brogrammer'
config.font = wezterm.font 'MonaspiceKr Nerd Font'
config.window_background_opacity = 0.8
config.win32_system_backdrop = 'Acrylic'

-- config.leader = { key = 'LeftShift', mods = 'CTRL', timeout_milliseconds = 500 }
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
