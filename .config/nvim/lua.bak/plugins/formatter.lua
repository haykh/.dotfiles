function if_defined(plugin, value, default)
  default = default or {}
	if vim.fn.executable(plugin) == 1 then
		return value
	else
		return default
	end
end

return {
	{
    "mhartington/formatter.nvim",
    version = "*",
		opts = {
			filetype = {
				cpp = {
					function()
						return if_defined("clang-format", {
							exe = "clang-format",
							args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
							stdin = true,
							cwd = vim.fn.expand("%:p:h"),
						})
					end,
				},
				python = {
					function()
						return if_defined("black", {
							exe = "black",
							args = { "-" },
							stdin = 1,
						})
					end,
				},
				fortran = {
					function()
						return if_defined("fprettify", {
							exe = "fprettify",
							args = {
								"-i 2",
								"-w 4",
								"--whitespace-assignment true",
								"--enable-decl --whitespace-decl true",
								"--whitespace-relational true",
								"--whitespace-logical true",
								"--whitespace-plusminus true",
								"--whitespace-multdiv true",
								"--whitespace-print true",
								"--whitespace-type true",
								"--whitespace-intrinsics true",
								"--enable-replacements",
								"-l 1000",
							},
							stdin = 1,
						})
					end,
				},
				go = {
					function()
						return if_defined("gofmt", {
							exe = "gofmt",
							args = { "-e", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						})
					end,
				},
				rust = {
					function()
						return if_defined("rustfmt", {
							exe = "rustfmt",
							args = { "--emit=stdout" },
							stdin = true,
						})
					end,
				},
				lua = {
					function()
						return if_defined("stylua", {
							exe = "stylua",
							args = { "-" },
							stdin = true,
						})
					end,
				},
			},
		},
    ft = { "lua" },
		config = function()
			vim.api.nvim_create_augroup("__formatter__", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
		end,
	},
}
