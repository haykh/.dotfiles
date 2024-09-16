function command_exists(cmd)
	local handle = io.popen("command -v " .. cmd)
	local result = handle:read("*a")
	handle:close()
	return result ~= ""
end

return {
	{
		"nvimdev/dashboard-nvim",
		lazy = false,
		priority = 1000,
		keys = {
			{
				"<leader>dd",
				"<cmd>Dashboard<cr>",
				desc = "open dashboard",
			},
		},
		opts = function()
			local cmd
			if command_exists("lolcrab") then
				cmd = "cat $1 | lolcrab -g warm -c 'rgba(249,36,243,1) 0%, rgba(28,144,253,1) 100%' -s 0.03"
			else
				cmd = "cat"
			end
			local fname = "$HOME/.config/nvim/lua/plugins/vimcheg.txt"

			local opts = {
				theme = "doom",
				hide = {
					statusline = false,
				},
				preview = {
					command = cmd,
					file_path = fname,
					file_width = 53,
					file_height = 11,
				},
				config = {
					center = {
						{
							action = "lua LazyVim.pick()()",
							desc = " find file",
							icon = " ",
							key = "f",
						},
						{
							action = "ene | startinsert",
							desc = " new",
							icon = " ",
							key = "n",
						},
						{
							action = 'lua LazyVim.pick("oldfiles")()',
							desc = " recent",
							icon = " ",
							key = "r",
						},
						{
							action = 'lua LazyVim.pick("live_grep")()',
							desc = " find",
							icon = " ",
							key = "g",
						},
						{
							action = "lua LazyVim.pick.config_files()()",
							desc = " config",
							icon = " ",
							key = "c",
						},
						{
							action = 'lua require("persistence").load()',
							desc = " restore",
							icon = " ",
							key = "s",
						},
						{
							action = "LazyExtras",
							desc = " lazy extras",
							icon = " ",
							key = "x",
						},
						{
							action = "Lazy",
							desc = " lazy",
							icon = "󰒲 ",
							key = "l",
						},
						{
							action = function()
								vim.api.nvim_input("<c-o>")
							end,
							desc = " return",
							icon = "󰌍 ",
							key = "q",
						},
						{
							action = function()
								vim.api.nvim_input("<cmd>qa<cr>")
							end,
							desc = " quit",
							icon = " ",
							key = "<s-q>",
						},
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return {
							"󰈸 nvim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
						}
					end,
				},
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			-- open dashboard after closing lazy
			if vim.o.filetype == "lazy" then
				vim.api.nvim_create_autocmd("WinClosed", {
					pattern = tostring(vim.api.nvim_get_current_win()),
					once = true,
					callback = function()
						vim.schedule(function()
							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
						end)
					end,
				})
			end

			return opts
		end,
	},
}
-- 			logo = string.rep("\n", 8) .. logo .. "\n\n"
-- 			vim.api.nvim_command("hi DashboardHeader guifg=#00ff00")
--
-- 			local opts = {
-- 				theme = "doom",
-- 				hide = {
-- 					statusline = false,
-- 				},
-- 				config = {
-- 					header = vim.split(logo, "\n"),
-- 					center = {
-- 						{
-- 							action = "lua LazyVim.pick()()",
-- 							desc = " find file",
-- 							icon = " ",
-- 							key = "f",
-- 						},
-- 						{
-- 							action = "ene | startinsert",
-- 							desc = " new",
-- 							icon = " ",
-- 							key = "n",
-- 						},
-- 						{
-- 							action = 'lua LazyVim.pick("oldfiles")()',
-- 							desc = " recent",
-- 							icon = " ",
-- 							key = "r",
-- 						},
-- 						{
-- 							action = 'lua LazyVim.pick("live_grep")()',
-- 							desc = " find",
-- 							icon = " ",
-- 							key = "g",
-- 						},
-- 						{
-- 							action = "lua LazyVim.pick.config_files()()",
-- 							desc = " config",
-- 							icon = " ",
-- 							key = "c",
-- 						},
-- 						{
-- 							action = 'lua require("persistence").load()',
-- 							desc = " restore",
-- 							icon = " ",
-- 							key = "s",
-- 						},
-- 						{
-- 							action = "LazyExtras",
-- 							desc = " lazy extras",
-- 							icon = " ",
-- 							key = "x",
-- 						},
-- 						{
-- 							action = "Lazy",
-- 							desc = " lazy",
-- 							icon = "󰒲 ",
-- 							key = "l",
-- 						},
-- 						{
-- 							action = function()
-- 								vim.api.nvim_input("<c-o>")
-- 							end,
-- 							desc = " return",
-- 							icon = "󰌍 ",
-- 							key = "q",
-- 						},
-- 						{
-- 							action = function()
-- 								vim.api.nvim_input("<cmd>qa<cr>")
-- 							end,
-- 							desc = " quit",
-- 							icon = " ",
-- 							key = "<s-q>",
-- 						},
-- 					},
-- 					footer = function()
-- 						local stats = require("lazy").stats()
-- 						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
-- 						return {
-- 							"󰈸 nvim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
-- 						}
-- 					end,
-- 				},
-- 			}
--
-- 			for _, button in ipairs(opts.config.center) do
-- 				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
-- 				button.key_format = "  %s"
-- 			end
--
-- 			-- open dashboard after closing lazy
-- 			if vim.o.filetype == "lazy" then
-- 				vim.api.nvim_create_autocmd("WinClosed", {
-- 					pattern = tostring(vim.api.nvim_get_current_win()),
-- 					once = true,
-- 					callback = function()
-- 						vim.schedule(function()
-- 							vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
-- 						end)
-- 					end,
-- 				})
-- 			end
--
-- 			return opts
-- 		end,
-- 	},
-- }
