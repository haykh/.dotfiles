return {
	{ import = "lazyvim.plugins.extras.editor.aerial" },
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
			bigfile = { enabled = false },
			scroll = { enabled = false },
			indent = { enabled = true },
			dim = { enabled = true },
		},
	},
	{ "3rd/image.nvim", opts = {} },
	{
		-- temporary fix for image.nvim
		"pynappo/neo-tree.nvim",
		branch = "1547-fix-image-nvim",
		-- "nvim-neo-tree/neo-tree.nvim",
		requires = {
			"3rd/image.nvim",
		},
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
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
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
