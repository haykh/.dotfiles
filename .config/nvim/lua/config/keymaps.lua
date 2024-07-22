vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
