vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
vim.keymap.set("n", "<leader>ccp", "<cmd>CccPick<cr>", { desc = "color picker" })
vim.keymap.set(
	"n",
	"<leader>ll",
	"<cmd>lua vim.diagnostic.open_float()<cr>",
	{ desc = "show lsp message in floating window" }
)

local filetype_to_lsp = {
	lua = "lua_ls",
	c = "clangd",
	cpp = "clangd",
	python = "basedpyright",
	go = "gopls",
}

vim.keymap.set("n", "<leader>le", function()
	local ft = vim.bo.filetype
	local lsp_name = filetype_to_lsp[ft]

	if not lsp_name then
		vim.notify("No LSP configured for filetype: " .. ft, vim.log.levels.WARN)
		return
	end

	-- Check if LSP is already attached to this buffer
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		if client.name == lsp_name then
			vim.notify("LSP " .. lsp_name .. " already running", vim.log.levels.INFO)
			return
		end
	end

	-- Start the LSP
	vim.cmd("LspStart " .. lsp_name)
end, { desc = "Start appropriate LSP" })

vim.keymap.set("n", "<leader>ld", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	local stopped_any = false
	for _, client in ipairs(clients) do
		if client.name ~= "copilot" then
			vim.lsp.stop_client(client.id)
			stopped_any = true
		end
	end

	if stopped_any then
		vim.notify("Stopped non-Copilot LSP clients", vim.log.levels.INFO)
	else
		vim.notify("No non-Copilot LSP clients running", vim.log.levels.INFO)
	end
end, { desc = "Stop all LSPs except Copilot" })
