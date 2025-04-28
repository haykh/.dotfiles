return {
	-- lsp
	{
		"neovim/nvim-lspconfig",
		opts = {
			setup = {
				clangd = function(_, opts)
					opts.capabilities.offsetEncoding = { "utf-16" }
				end,
			},
		},
	},
	-- formatting
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				cmake = { "cmake_format" },
			},
		},
	},
	-- cmake
	{
		"Civitasv/cmake-tools.nvim",
		opts = {},
	},
}
