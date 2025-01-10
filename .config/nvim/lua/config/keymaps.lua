vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
vim.keymap.set("n", "<leader>ccp", "<cmd>CccPick<cr>", { desc = "color picker" })
vim.keymap.set("n", "<leader>cmb", "<cmd>CMakeBuild<cr>", { desc = "build project" })
vim.keymap.set("n", "<leader>cmr", "<cmd>CMakeRun<cr>", { desc = "run project" })
vim.keymap.set("n", "<leader>cmc", "<cmd>CMakeCloseRunner<cr>", { desc = "close runner buffer" })
vim.keymap.set("n", "<leader>cmg", "<cmd>CMakeGenerate<cr>", { desc = "regenerate project" })
vim.keymap.set(
	"n",
	"<leader>ld",
	"<cmd>lua vim.diagnostic.open_float()<cr>",
	{ desc = "show lsp message in floating window" }
)
