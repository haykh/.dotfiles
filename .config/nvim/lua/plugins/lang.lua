return {
	-- lsp
	{
		"neovim/nvim-lspconfig",
		opts = {
			diagnostics = {
				underline = true,
				signs = true,
			},
			-- let pyrefly own hover/types; ruff stays lint+format only
			setup = {
				ruff = function()
					Snacks.util.lsp.on({ name = "ruff" }, function(_, client)
						client.server_capabilities.hoverProvider = false
					end)
				end,
			},
			servers = {
				-- nasm
				asm_lsp = {},
				-- fortran
				fortls = {},
				-- cpp & cmake
				clangd = { autostart = false },
				neocmake = { autostart = false },
				-- glsl
				glsl_analyzer = {},
				glslls = { mason = false },
				-- python
				ruff = {},
				pyrefly = {},
				-- js, ts, html, css
				svelte = {},
				ts_ls = {},
				eslint = {},
				cssls = {},
				emmet_ls = {},
				html = {},
				-- toml, json, yaml
				taplo = {},
				jsonls = {},
				yamlls = {},
				-- tombi = {},
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
				nixd = {},
				-- docker
				docker_compose_language_service = {},
				dockerls = {},
				-- tex
				texlab = {},
				-- racket
				racket_langserver = {},
				-- kotlin
				kotlin_language_server = {},
				-- xml (AndroidManifest.xml, res/*.xml)
				lemminx = {},
			},
		},
	},
	-- formatter
	{
		"stevearc/conform.nvim",
		opts = {
			-- ktlint is a JVM tool: ~2.4s cold start per format. Raise the ceiling
			-- so format-on-save doesn't abort. This is a MAX wait, not a fixed one —
			-- fast formatters (stylua, ruff, …) still return in ms. Deep-merges with
			-- LazyVim's default, keeping lsp_format = "fallback".
			default_format_opts = { timeout_ms = 5000 },
			formatters_by_ft = {
				fortran = { "fprettify" },
				cpp = { "clang-format" },
				c = { "clang-format" },
				cmake = { "cmake_format" },
				glsl = { "clang-format" },
				python = { "ruff_organize_imports", "ruff_format" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				toml = { "taplo" },
				json = { "eslint_d" },
				yaml = { "prettier" },
				-- markdown = { "mdformat" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				lua = { "stylua" },
				awk = { "awk" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				nix = { "nixfmt" },
				asm = { "asmfmt" },
				kotlin = { "ktlint" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				stylua = {
					mason = false,
				},
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
				"cmake",
				"diff",
				"html",
				"glsl",
				"hyprlang",
				"javascript",
				"typescript",
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
				"svelte",
				"toml",
				"javascript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"nix",
				"racket",
				"kotlin",
			},
		},
	},
	-- comments
	{
		"folke/ts-comments.nvim",
	},
	-- additional languages
}
