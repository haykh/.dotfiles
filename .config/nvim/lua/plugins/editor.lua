return {
	{ import = "lazyvim.plugins.extras.editor.aerial" },
	{
		"stevearc/aerial.nvim",
		keys = {
			{ "<leader>ae", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"snacks.nvim",
		opts = {
			scroll = { enabled = false },
			indent = { enabled = true },
			dim = { enabled = true },
		},
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
