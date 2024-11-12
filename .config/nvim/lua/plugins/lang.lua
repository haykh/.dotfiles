return {
	-- lsp
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = false,
				signs = true,
			},
			setup = {
				autostart = true,
			},
		},
	},
	-- formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				glsl = { "clang-format" },
				python = { "black" },
				fortran = { "fprettify" },
				awk = { "awk" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				lua = { "stylua" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				fprettify = {
          -- stylua: ignore
					prepend_args = {
						"-i", "2",
            "-w", "4",
						"--whitespace-assignment", "true",
						"--enable-decl",
						"--whitespace-decl", "true",
						"--whitespace-relational", "true",
						"--whitespace-logical", "true",
						"--whitespace-plusminus", "true",
						"--whitespace-multdiv", "true",
						"--whitespace-print", "true",
						"--whitespace-type", "true",
						"--whitespace-intrinsics", "true",
						"--enable-replacements",
						"-l", "1000",
					},
				},
			},
		},
	},
	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"diff",
				"html",
				"glsl",
				"hyprlang",
				"javascript",
				"json",
				"jsonc",
				"jq",
				"lua",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"regex",
				"toml",
				"javascript",
				"vim",
				"vimdoc",
				"xml",
				"cmake",
				"yaml",
			},
		},
		config = function(_, opts)
			vim.filetype.add({
				extension = { rasi = "rasi" },
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/kitty/.*.conf"] = "bash",
					[".*/hypr/.*%.conf"] = "hyprlang",
					[".*/mako/config"] = "dosini",
					[".*.vert"] = "glsl",
					[".*.frag"] = "glsl",
				},
			})
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- comments
	{
		"folke/ts-comments.nvim",
		opts = {
			lang = {
				rasi = "// %s",
			},
		},
	},
	-- additional languages
	{
		"elkowar/yuck.vim",
	},
	{ import = "lazyvim.plugins.extras.lang.python" },
	{ import = "lazyvim.plugins.extras.lang.markdown" },
}
