return {
	{
		"LazyVim/LazyVim",
		keys = {
			{
				"<c-`>",
				function()
					LazyVim.terminal()
				end,
				mode = "n",
				desc = "toggle terminal",
			},
			{
				"<c-`>",
				"<cmd>close<cr>",
				mode = "t",
				desc = "toggle terminal",
			},
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
	{
		"akinsho/bufferline.nvim",
		keys = {
			{
				"<leader>bs",
				"<cmd>BufferLinePick<cr>",
				desc = "pick buffer",
			},
			{
				"<leader>bD",
				"<Cmd>BufferLineGroupClose ungrouped<CR>",
				desc = "delete non-pinned buffers",
			},
		},
		opts = {
			options = {
				always_show_bufferline = true,
				groups = {
					items = {
						require("bufferline.groups").builtin.pinned:with({ icon = "" }),
					},
				},
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	-- custom plugins
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"petertriho/nvim-scrollbar",
		lazy = false,
		opts = {
			handle = {
				text = " ",
			},
			marks = {
				Search = { text = { ">", ">" } },
				Error = { text = { "-", "=" } },
				Warn = { text = { "-", "=" } },
				Info = { text = { "-", "=" } },
				Hint = { text = { "-", "=" } },
				Misc = { text = { "-", "=" } },
			},
		},
	},
}
