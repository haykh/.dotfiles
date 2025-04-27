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

if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "win32yank-wsl",
		copy = {
			["+"] = "win32yank.exe -i --crlf",
			["*"] = "win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "win32yank.exe -o --lf",
			["*"] = "win32yank.exe -o --lf",
		},
		cache_enabled = 0,
	}
end
