return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			grep = {
				rg_opts = "--sort-files --hidden --column --line-number --no-heading "
					.. "--color=always --smart-case -g '!{.git,node_modules,legacy,extern,build}/*'",
			},
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"snacks.nvim",
		opts = {
			bigfile = { enabled = false },
			scroll = { enabled = false },
			indent = { enabled = true },
			dim = { enabled = true },
		},
		keys = {
			{
				"<leader><leader>",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
		},
	},
}
