vim.g.lazyvim_check_order = false
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"
vim.o.swapfile = false
vim.o.conceallevel = 0
vim.opt.cursorline = false
vim.opt.wrap = true
vim.opt.listchars = {
	tab = "> ",
	trail = " ",
}
vim.opt.path = vim.opt.path + "**"
vim.opt.wildignore = "*.git/*,*build/*,*out/*,*node_modules/*"
