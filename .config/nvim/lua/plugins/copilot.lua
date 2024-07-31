return {
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		priority = 1000,
		build = ":Copilot auth",
		opts = {
			panel = { enabled = false },
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 25,
				keymap = {
					accept = "<m-tab>",
					accept_word = "<c-tab>",
					accept_line = "<s-tab>",
					next = "<m-]>",
					prev = "<m-[>",
					dismiss = "<s-tab>",
				},
			},
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim" },
		},
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ai",
				function()
					local input = vim.fn.input("help!")
					if input ~= "" then
						require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
					end
				end,
				desc = "quick ask in copilot chat",
			},
			{
				"<leader>aa",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "toggle copilot chat",
				mode = { "n", "v" },
			},
			{
				"<leader>ax",
				function()
					return require("CopilotChat").reset()
				end,
				desc = "clean copilot chat",
				mode = { "n", "v" },
			},
		},
		opts = {
			show_help = false,
			auto_insert_mode = true,
			window = {
				layout = "float",
				width = 0.6,
				height = 0.7,
				relative = "editor",
				border = "rounded",
				row = 0,
				col = 1000,
				title = "copilot chat",
				footer = nil,
				zindex = 1,
			},
			question_header = " @" .. (vim.env.USER or "usr") .. " ",
			answer_header = " overlord",
			selection = function(source)
				local select = require("CopilotChat.select")
				return select.visual(source) or select.buffer(source)
			end,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local colors = {
				[""] = LazyVim.ui.fg("Special"),
				["Normal"] = LazyVim.ui.fg("Special"),
				["Warning"] = LazyVim.ui.fg("DiagnosticError"),
				["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
			}
			table.insert(opts.sections.lualine_x, 2, {
				function()
					local icon = LazyVim.config.icons.kinds.Copilot
					local status = require("copilot.api").status.data
					return icon .. (status.message or "")
				end,
				cond = function()
					if not package.loaded["copilot"] then
						return
					end
					local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
					if not ok then
						return false
					end
					return ok and #clients > 0
				end,
				color = function()
					if not package.loaded["copilot"] then
						return
					end
					local status = require("copilot.api").status.data
					return colors[status.status] or colors[""]
				end,
			})
		end,
	},
}
