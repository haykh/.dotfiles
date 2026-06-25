-- Force-kill LSP servers on exit so a non-compliant one can't orphan and eat CPU
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			client:stop(true) -- force = SIGKILL, don't wait for graceful shutdown
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"sh",
		"cfg",
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
		"dosini",
		"lua",
		"typescript",
		"rasi",
	},
	command = "CccHighlighterEnable",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "cpp", "h", "hpp" },
	callback = function()
		vim.keymap.set("n", "<leader>K", function()
			local word = vim.fn.expand("<cword>")
			local buf = vim.api.nvim_create_buf(false, true)
			local width = math.floor(vim.o.columns * 0.8)
			local height = math.floor(vim.o.lines * 0.8)
			vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = math.floor((vim.o.lines - height) / 2),
				col = math.floor((vim.o.columns - width) / 2),
				style = "minimal",
				border = "rounded",
			})
			vim.fn.jobstart("cppman " .. word, {
				term = true,
				env = {
					GROFF_NO_SGR = "1",
					LESS_TERMCAP_mb = "\27[1;31m",
					LESS_TERMCAP_md = "\27[1;36m",
					LESS_TERMCAP_me = "\27[0m",
					LESS_TERMCAP_se = "\27[0m",
					LESS_TERMCAP_so = "\27[1;44;33m",
					LESS_TERMCAP_ue = "\27[0m",
					LESS_TERMCAP_us = "\27[1;32m",
				},
			})
			vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
		end, { buffer = true })
	end,
})
