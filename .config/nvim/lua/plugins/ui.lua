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
	-- scrollbar
	{
		"petertriho/nvim-scrollbar",
		branch = "refactor/v2",
		lazy = false,
		opts = {
			scrollbar = {
				thumb = {
					text = " ",
				},
			},
			providers = { gitsigns = true, search = true },
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
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			opts.sections.lualine_z = opts.sections.lualine_y
			opts.sections.lualine_y = opts.sections.lualine_x
			opts.sections.lualine_x = { "lsp_status" }
			return opts
		end,
	},
}
