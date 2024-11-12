return {
	-- lsp
	{ import = "lazyvim.plugins.extras.lang.clangd" },
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
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_executor = {
				name = "toggleterm",
				default_opts = {
					toggleterm = {
						direction = "horizontal",
						close_on_exit = false,
					},
				},
			},
			cmake_runner = {
				name = "toggleterm",
				default_opts = {
					toggleterm = {
						direction = "horizontal",
						close_on_exit = false,
					},
				},
			},
			cmake_notifications = {
				runner = { enabled = false },
			},
			cmake_build_directory = "build",
			cmake_virtual_text_support = false,
		},
	},
}
