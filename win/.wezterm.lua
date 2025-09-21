local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.default_domain = "WSL:NixOS"

local my_ghcolors = wezterm.color.get_builtin_schemes()["GitHub Dark"]
my_ghcolors.ansi = {
	"#484F58",
	"#FF7B72",
	"#3FB950",
	"#D29922",
	"#58A6FF",
	"#BC8CFF",
	"#39C5CF",
	"#B1BAC4",
}
my_ghcolors.brights = {
	"#6E7681",
	"#FFA198",
	"#56D364",
	"#E3B341",
	"#79C0FF",
	"#D2A8FF",
	"#56D4DD",
	"#FFFFFF",
}
my_ghcolors.background = "#10161F"
my_ghcolors.foreground = "#FFFFFF"
config.color_schemes = {
	["ghdark"] = my_ghcolors,
}
config.color_scheme = "ghdark"

config.font = wezterm.font_with_fallback({
	{ family = "MonaspiceKr NF" },
	{ family = "Cascadia Code NF" },
})

config.webgpu_power_preference = "HighPerformance"
config.enable_wayland = true
config.warn_about_missing_glyphs = false

config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"

config.font_rules = {
	{
		intensity = "Normal",
		italic = true,
		font = wezterm.font({
			family = "MonaspiceRn NF",
			italic = false,
		}),
	},
}

config.keys = {
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Prev"),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Next"),
	},
}

return config
