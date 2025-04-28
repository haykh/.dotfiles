return {
	{
		"ibhagwan/fzf-lua",
		opts = {
			grep = {
				rg_opts = "--sort-files --hidden --column --line-number --no-heading "
					.. "--color=always --smart-case -g '!{.git,node_modules,legacy,extern,build}/*'",
			},
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"snacks.nvim",
		opts = function(_, opts)
			local ignored = {
				"tmp",
				"temp",
				"extern",
				"legacy",
				"build",
				"node_modules",
				".git",
				".venv",
				"venv",
				".cache",
			}
			return vim.tbl_deep_extend("force", opts or {}, {
				bigfile = { enabled = false },
				scroll = { enabled = false },
				indent = { enabled = true },
				dim = { enabled = true },
				picker = {
					ignored = true,
					hidden = true,
					sources = {
						explorer = {
							exclude = ignored,
						},
						files = {
							exclude = ignored,
						},
						grep = {
							exclude = ignored,
						},
					},
				},
				dashboard = { enabled = false },
			})
		end,
		keys = {
			{
				"<leader><leader>",
				function()
					require("snacks").explorer()
				end,
				desc = "File Explorer",
			},
		},
	},
}
