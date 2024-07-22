vim.api.nvim_create_autocmd("Filetype", {
	pattern = {
		"css",
		"scss",
		"sass",
		"less",
		"html",
		"python",
		"javascript",
		"markdown",
		"jsonc",
		"json",
		"yaml",
		"toml",
		"lua",
		"typescript",
	},
	command = "CccHighlighterEnable",
})
