vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
vim.keymap.set("n", "<leader>cc", "<cmd>CccPick<cr>", { desc = "color picker" })
