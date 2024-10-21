return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				glsl = { "clang-format" },
				python = { "black" },
				fortran = { "fprettify" },
				awk = { "awk" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				lua = { "stylua" },
				cmake = { "cmake_format" },
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
