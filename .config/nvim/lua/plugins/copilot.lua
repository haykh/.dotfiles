return {
	{ "zbirenbaum/copilot-cmp" },
	{
		"zbirenbaum/copilot.lua",
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		lazy = false,
		priority = 1000,
		build = ":Copilot auth",
		opts = {
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 25,
				keymap = {
					accept = "<c-right>",
				},
			},
			server_opts_overrides = {
				settings = {
					telemetry = {
						telemetryLevel = "off",
					},
				},
			},
		},
	},
}
