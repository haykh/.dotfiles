return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				python = { "black" },
				fortran = { "fprettify" },
				awk = { "awk" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				fprettify = {
          -- stylua: ignore
					prepend_args = {
						"-i", "2", 
            "-w", "4",
						"--whitespace-assignment", "true",
						"--enable-decl",
						"--whitespace-decl", "true",
						"--whitespace-relational", "true",
						"--whitespace-logical", "true",
						"--whitespace-plusminus", "true",
						"--whitespace-multdiv", "true",
						"--whitespace-print", "true",
						"--whitespace-type", "true",
						"--whitespace-intrinsics", "true",
						"--enable-replacements",
						"-l", "1000",
					},
				},
			},
		},
	},
}
