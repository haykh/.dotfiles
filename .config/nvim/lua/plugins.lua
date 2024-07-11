return {
	"github/copilot.vim",
	"vim-airline/vim-airline",
	{
		"vim-airline/vim-airline-themes",
		config = function()
			vim.g.airline_powerline_fonts = 1
			vim.g.airline_theme = "github_dark_default"
		end,
	},
	"tpope/vim-markdown",
	"cespare/vim-toml",
	"tikhomirov/vim-glsl",
	{
		-- colorizer
		"chrisbra/Colorizer",
		config = function()
			vim.g.colorizer_auto_filetype = "python,css,html,vue,markdown,scss,less,javascript"
		end,
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			vim.api.nvim_exec(
				[[
    augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.rs,*.cpp,*.c,*.hpp,*.h,*.py,*.F90,*.F08,*.F,*.go,*.lua,*.nasm,*.asm FormatWrite
    augroup END
    ]],
				true
			)
			function if_defined(plugin, value, default)
				default = default or {}
				if vim.fn.executable(plugin) == 1 then
					return value
				else
					return default
				end
			end
			require("formatter").setup({
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
			})
		end,
	},
	{
		-- color scheme
		"projekt0n/github-nvim-theme",
		config = function()
			vim.cmd("colo github_dark_default")
		end,
	},
	"nvim-tree/nvim-web-devicons",
	"tpope/vim-surround",
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			require("scrollbar.handlers.gitsigns").setup()
		end,
	},
	{
		-- file tree viewer
		"nvim-tree/nvim-tree.lua",
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			-- set nvim-tree.filters.git_ignored
		end,
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader><Leader>", "<Cmd>NvimTreeToggle<CR>", {
				noremap = true,
				silent = true,
			})
			require("nvim-tree").setup({
				filters = {
					git_ignored = false,
				},
			})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = { "lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.barbar_auto_setup = false
			vim.api.nvim_set_keymap("n", "<Leader>[", "<Cmd>BufferPrevious<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>]", "<Cmd>BufferNext<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>{", "<Cmd>BufferMovePrevious<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>}", "<Cmd>BufferMoveNext<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>c", "<Cmd>BufferClose<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>p", "<Cmd>BufferPin<CR>", {
				noremap = true,
				silent = true,
			})
		end,
		opts = {
			icons = {
				pinned = {
					button = "",
					filename = true,
				},
			},
		},
	},
	{
		-- floaterm
		"voldikss/vim-floaterm",
		init = function()
			vim.g.floaterm_position = "bottomright"
			vim.g.floaterm_height = 0.99
			vim.g.floaterm_width = 0.35
			vim.g.floaterm_shell = "zsh"
		end,
		config = function()
			vim.api.nvim_set_keymap("t", "<Leader>ff", "<C-\\><C-n><C-w>w", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("t", "<Leader>fn", "<C-\\><C-n>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("t", "jk", "<C-\\><C-n><C-w>w", {
				noremap = true,
				silent = true,
			})
			-- "tnoremap <Leader>f= <cmd>FloatermUpdate --height=0.95<cr>
			-- "tnoremap <Leader>f_ <cmd>FloatermUpdate --height=g:floaterm_height<cr>
			-- "tnoremap <Leader>f+ <cmd>FloatermUpdate --width=0.95<cr>
			-- "tnoremap <Leader>f- <cmd>FloatermUpdate --width=g:floaterm_width<cr>

			vim.api.nvim_set_keymap("n", "<Leader>ft", "<Cmd>FloatermNew<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>fq", "<Cmd>FloatermKill<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>fs", "<Cmd>FloatermToggle<CR>", {
				noremap = true,
				silent = true,
			})

			vim.api.nvim_set_keymap("t", "<Leader>ft", "<Cmd>FloatermNew<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("t", "<Leader>fq", "<Cmd>FloatermKill<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("t", "<Leader>fs", "<Cmd>FloatermToggle<CR>", {
				noremap = true,
				silent = true,
			})
		end,
	},
	{
		-- scrollbar
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup({
				handle = {
					text = " ",
				},
				marks = {
					Search = { text = { ">", ">" } },
					Error = { text = { "-", "=" } },
					Warn = { text = { "-", "=" } },
					Info = { text = { "-", "=" } },
					Hint = { text = { "-", "=" } },
					Misc = { text = { "-", "=" } },
				},
			})
		end,
	},
	{
		-- search highlighter
		"kevinhwang91/nvim-hlslens",
		config = function()
			local kopts = {
				noremap = true,
				silent = true,
			}
			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

			require("scrollbar.handlers.search").setup({
				override_lens = function(render, posList, nearest, idx, relIdx)
					local sfw = vim.v.searchforward == 1
					local indicator, text, chunks
					local absRelIdx = math.abs(relIdx)
					if absRelIdx > 1 then
						indicator = ("%d%s"):format(absRelIdx, sfw ~= (relIdx > 1) and "▲" or "▼")
					elseif absRelIdx == 1 then
						indicator = sfw ~= (relIdx == 1) and "▲" or "▼"
					else
						indicator = ""
					end

					local lnum, col = unpack(posList[idx])
					if nearest then
						local cnt = #posList
						if indicator ~= "" then
							text = ("[%s %d/%d]"):format(indicator, idx, cnt)
						else
							text = ("[%d/%d]"):format(idx, cnt)
						end
						chunks = { { " " }, { text, "HlSearchLensNear" } }
					else
						text = ("[%s %d]"):format(indicator, idx)
						chunks = { { " " }, { text, "HlSearchLens" } }
					end
					render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
				end,
			})
		end,
	},
	{
		-- comment toggler
		"numToStr/Comment.nvim",
		opts = {
			toggler = {
				line = "<Leader>c<Space>",
				block = "<Leader>C<Space>",
			},
			opleader = {
				line = "<Leader>c<Space>",
				block = "<Leader>C<Space>",
			},
		},
		lazy = false,
	},
	{ -- lsp
		"neovim/nvim-lspconfig",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>ld", "<Cmd>Telescope lsp_definitions<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>lt", "<Cmd>Telescope lsp_type_definitions<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>li", "<Cmd>Telescope lsp_implementations<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>ls", "<Cmd>Telescope lsp_document_symbols<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>lr", "<Cmd>Telescope lsp_references<CR>", {
				noremap = true,
				silent = true,
			})
			require("lspconfig").clangd.setup({
				cmd = { "clangd", "--offset-encoding=utf-16" },
				autostart = false,
			})
			require("lspconfig").gopls.setup({
				autostart = false,
			})
			require("lspconfig").pyright.setup({
				autostart = false,
			})
			require("lspconfig").rust_analyzer.setup({
				autostart = false,
			})
		end,
	},
	{
		-- treesitter lsp
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			vim.api.nvim_set_keymap("n", "<Leader>qq", "<Cmd>LspStop<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>qs", "<Cmd>LspStart<CR>", {
				noremap = true,
				silent = true,
			})
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
          "nix",
					"c",
					"cpp",
					"cmake",
					"glsl",
					"make",
					"python",
					"lua",
					"rust",
					"fortran",
					"go",
					"gomod",
					"javascript",
					"css",
					"html",
					"json",
					"yaml",
					"toml",
					"bash",
					"comment",
					"markdown",
					"markdown_inline",
					"nasm",
					"vimdoc",
				},
				highlight = {
					enable = true,
					disable = { "vimdoc" },
				},
			})
		end,
	},
	{
		-- rainbow delimiters for treesitter
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			})
		end,
	},
	{
		-- telescope with plugins
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		extensions = {
			file_browser = {
				theme = "ivy",
				hidden = true,
				grouped = true,
				sorting_strategy = "ascending",
				display_stat = false,
				respect_gitignore = true,
			},
			emoji = {
				action = function(emoji)
					vim.fn.setreg("", emoji.value)
				end,
			},
		},
		config = function()
			require("telescope").load_extension("emoji")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("gitmoji")

			vim.api.nvim_set_keymap("n", "<Leader>tf", "<Cmd>Telescope file_browser<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>tg", "<Cmd>Telescope live_grep<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>tr", "<Cmd>Telescope registers<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>th", "<Cmd>Telescope man_pages<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>te", "<Cmd>Telescope emoji theme=ivy<CR>", {
				noremap = true,
				silent = true,
			})
			vim.api.nvim_set_keymap("n", "<Leader>gm", "<Cmd>Telescope gitmoji<CR>", {
				noremap = true,
				silent = true,
			})
		end,
	},
	"olacin/telescope-gitmoji.nvim",
	"xiyaowong/telescope-emoji.nvim",
	"nvim-telescope/telescope-file-browser.nvim",
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			local animate = require("mini.animate")
			animate.setup({
				scroll = {
					timing = animate.gen_timing.quadratic({ duration = 50, unit = "total" }),
				},
				cursor = {
					timing = animate.gen_timing.quadratic({ duration = 50, unit = "total" }),
				},
				open = {
					enable = false,
				},
				close = {
					enable = false,
				},
			})
			require("mini.indentscope").setup({
				options = {
					try_as_border = true,
				},
				symbol = "┊",
			})
		end,
	},
}
