return {
	{ "LazyVim/LazyVim" },
	{ "folke/lazy.nvim" },
	-- disabled
	{ "folke/tokyonight.nvim", enabled = false },
	{ "catppuccin/nvim", enabled = false },
	{ "folke/todo-comments.nvim", enabled = false },
	{ "rafamadriz/friendly-snippets", enabled = false },
	{ "echasnovski/mini.pairs", enabled = false },
	{ "echasnovski/mini.ai", enabled = false },
	{
		"williamboman/mason.nvim",
		enabled = function()
			return not (os.getenv("NIXOS") or os.getenv("NIX_PATH") or os.getenv("NIX_PROFILES"))
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		enabled = function()
			return not (os.getenv("NIXOS") or os.getenv("NIX_PATH") or os.getenv("NIX_PROFILES"))
		end,
	},
}
