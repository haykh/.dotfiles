return {
	-- colors
	{
		"projekt0n/github-nvim-theme",
		config = function()
			require("github-theme").setup({
				options = {
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic",
					},
				},
			})
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "github_dark_default",
		},
	},
	-- git
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	-- scrollbar
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
	-- tabs
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
				"<cmd>BufferLineGroupClose ungrouped<CR>",
				desc = "delete non-pinned buffers",
			},
			{
				"[B",
				"<cmd>BufferLineMovePrev<cr>",
				desc = "move buffer to the left",
			},
			{
				"]B",
				"<cmd>BufferLineMoveNext<cr>",
				desc = "move buffer to the right",
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
}
