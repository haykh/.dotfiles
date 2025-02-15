return {
	-- lsp
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = false,
				signs = true,
			},
			setup = {
				autostart = true,
			},
			servers = {
				-- nasm
				asm_lsp = {},
				-- fortran
				fortls = {},
				-- cpp & cmake
				clangd = { autostart = false },
				neocmake = {},
				-- glsl
				glslls = {
					cmd = { "glslls", "--target-env", "opengl4.5", "--stdin" },
				},
				-- python
				pyright = {},
				-- js, ts, html, css
				ts_ls = {},
				cssls = {},
				emmet_ls = {},
				html = {},
				-- toml, json, yaml
				taplo = {},
				jsonls = {},
				yamlls = {},
				-- markdown
				markdown_oxide = {},
				-- go
				gopls = {},
				-- rust
				rust_analyzer = {},
				-- lua
				lua_ls = {},
				-- awk, bash, powershell
				awk_ls = {},
				bashls = {},
				powershell_es = {},
				-- hyprlang
				hyprls = {},
				-- nix
				nil_ls = {},
				-- docker
				docker_compose_language_service = {},
				dockerls = {},
				-- tex
				texlab = {},
			},
		},
		setup = {
			eslint = function()
				-- automatically fix linting errors on save (but otherwise do not format the document)
				vim.cmd([[
          autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
        ]])
			end,
		},
	},
	-- formatter
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				fortran = { "fprettify" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				cmake = { "cmake_format" },
				glsl = { "clang-format" },
				python = { "black" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				toml = { "taplo" },
				json = { "eslint_d" },
				yaml = { "prettierd" },
				-- markdown = { "mdformat" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				lua = { "stylua" },
				awk = { "awk" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				nix = { "nixfmt" },
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
	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"css",
				"diff",
				"html",
				"glsl",
				"hyprlang",
				"javascript",
				"json",
				"jsonc",
				"jq",
				"go",
				"gotmpl",
				"lua",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"regex",
				"toml",
				"javascript",
				"vim",
				"vimdoc",
				"xml",
				"cmake",
				"yaml",
				"nix",
			},
		},
		config = function(_, opts)
			vim.filetype.add({
				extension = { rasi = "rasi" },
				pattern = {
					[".*/waybar/config"] = "jsonc",
					[".*/kitty/.*.conf"] = "bash",
					[".*/hypr/.*%.conf"] = "hyprlang",
					[".*/mako/config"] = "dosini",
					[".*.vert"] = "glsl",
					[".*.frag"] = "glsl",
					[".*/layouts/404.html"] = "gotmpl",
					[".*/layouts/_default/.*.html"] = "gotmpl",
					[".*/layouts/partials/.*.html"] = "gotmpl",
					[".*/layouts/shortcodes/.*.html"] = "gotmpl",
				},
			})
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	-- comments
	{
		"folke/ts-comments.nvim",
		opts = {
			lang = {
				rasi = "// %s",
			},
		},
	},
	-- additional languages
	{ "elkowar/yuck.vim" },
}
