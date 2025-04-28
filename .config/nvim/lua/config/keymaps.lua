vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
vim.keymap.set("n", "<leader>ccp", "<cmd>CccPick<cr>", { desc = "color picker" })
vim.keymap.set(
	"n",
	"<leader>ll",
	"<cmd>lua vim.diagnostic.open_float()<cr>",
	{ desc = "show lsp message in floating window" }
)
vim.keymap.set("n", "<leader>le", "<cmd>LspStart<cr>", { desc = "enable lsp diagnostics" })
vim.keymap.set("n", "<leader>ld", "<cmd>LspStop<cr>", { desc = "disable lsp diagnostics" })
