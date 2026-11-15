vim.keymap.set("i", "jk", "<esc>", { noremap = true, silent = true, desc = "<esc>" })
vim.keymap.set({ "i", "n" }, "<leader>l", "<cmd>noh<cr><esc>", { desc = "escape and clear hlsearch" })
vim.keymap.set("n", "<leader>ccp", "<cmd>CccPick<cr>", { desc = "color picker" })
vim.keymap.set(
	"n",
	"<leader>ll",
	"<cmd>lua vim.diagnostic.open_float()<cr>",
	{ desc = "show lsp message in floating window" }
)

vim.keymap.set("n", "<leader>le", function()
	local ft = vim.bo.filetype

	-- clients still attached (a just-stopped client lingers until it exits)
	local running = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if not client:is_stopped() then
			running[client.name] = true
		end
	end

	-- every configured server for this filetype that isn't already attached
	local names = vim.iter(vim.lsp.get_configs({ enabled = true, filetype = ft }))
		:map(function(config)
			return config.name
		end)
		:filter(function(name)
			return name ~= "copilot" and not running[name]
		end)
		:totable()

	if #names == 0 then
		vim.notify(
			next(running) and "LSP already running" or ("No LSP configured for filetype: " .. ft),
			vim.log.levels.INFO
		)
		return
	end

	-- re-enabling re-fires the FileType hook, which starts the client from the full
	-- vim.lsp.config (real cmd, root_dir, settings) — unlike a bare vim.lsp.start()
	vim.lsp.enable(names)
	vim.notify("Started " .. table.concat(names, ", "), vim.log.levels.INFO)
end, { desc = "Start LSPs for this filetype" })

vim.keymap.set("n", "<leader>ld", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	local stopped_any = false
	for _, client in ipairs(clients) do
		if client.name ~= "copilot" then
			client:stop(true)
			stopped_any = true
		end
	end

	if stopped_any then
		vim.notify("Stopped non-Copilot LSP clients", vim.log.levels.INFO)
	else
		vim.notify("No non-Copilot LSP clients running", vim.log.levels.INFO)
	end
end, { desc = "Stop all LSPs except Copilot" })

vim.keymap.set("n", "<leader>rp", function()
	Snacks.terminal("python " .. vim.fn.expand("%") .. "; read", { win = { position = "bottom" } })
end, { desc = "Run Python file" })

vim.keymap.set("n", "<leader>rc", function()
	Snacks.terminal("cc " .. vim.fn.expand("%") .. " -o main && ./main; read", { win = { position = "bottom" } })
end, { desc = "Compile and run C code" })

vim.keymap.set("n", "<leader>cm", function()
	Snacks.terminal("cmake --build build -j16; read", { win = { position = "bottom" } })
end, { desc = "Compile with CMake" })

vim.keymap.set("n", "<leader>ce", function()
	Snacks.terminal("./run.sh; read", { win = { position = "bottom" } })
end, { desc = "Execute a script in run.sh" })
