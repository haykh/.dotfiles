return {
	{ "zbirenbaum/copilot-cmp" },
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
					accept = "<c-right>",
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
}
