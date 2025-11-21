local nonnixos = function()
	return not (os.getenv("NIXOS") or os.getenv("NIX_PATH") or os.getenv("NIX_PROFILES"))
end

return {
	{ "LazyVim/LazyVim" },
	{ "folke/lazy.nvim" },
	-- disabled
	{ "folke/tokyonight.nvim", enabled = false },
	{ "catppuccin/nvim", enabled = false },
	{ "folke/todo-comments.nvim", enabled = false },
	{ "rafamadriz/friendly-snippets", enabled = false },
	{ "nvim-mini/mini.pairs", enabled = false },
	{ "nvim-mini/mini.ai", enabled = false },
	{ "mason-org/mason.nvim", version = "^1.0.0", enabled = nonnixos() },
	{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0", enabled = nonnixos() },
}
