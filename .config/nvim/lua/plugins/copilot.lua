return {
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		cmd = "Copilot",
		build = ":Copilot auth",
		event = "LspAttach",
		opts = {
			suggestion = { enabled = true, auto_trigger = false },
			panel = { enabled = true },
			filetypes = {
				markdown = true,
				lua = true,
				help = true,
			},
		},
	},
}
