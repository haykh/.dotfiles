return {
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
}
