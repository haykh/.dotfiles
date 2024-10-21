return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = false,
				signs = true,
			},
			setup = {
				autostart = true,
				clangd = function(_, opts)
					opts.capabilities.offsetEncoding = { "utf-16" }
				end,
			},
		},
	},
}
