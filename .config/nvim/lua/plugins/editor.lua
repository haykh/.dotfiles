return {
	{ import = "lazyvim.plugins.extras.editor.aerial" },
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{
				"<leader><leader>",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
				end,
				desc = "open tree view",
			},
		},
		opts = {
			close_if_last_window = true,
			window = {
				mappings = {
					["P"] = { "toggle_preview", config = { use_float = true } },
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					-- hide_gitignored = false,
					-- hide_hidden = false,
				},
			},
		},
	},
	-- terminal
	{
		"akinsho/toggleterm.nvim",
		opts = {
			size = 20,
			open_mapping = [[<c-\>]],
			direction = "horizontal",
		},
	},
}
