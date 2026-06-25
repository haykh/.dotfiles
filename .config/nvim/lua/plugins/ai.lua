return {
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		},
	},
	{
		"kkrampis/codex.nvim",
		lazy = true,
		cmd = { "Codex", "CodexToggle" },
		keys = {
			{ "<leader>oc", "<cmd>CodexToggle<cr>", desc = "Toggle Codex" },
		},
		opts = {
			width = 0.3,
			panel = true,
		},
	},
}
