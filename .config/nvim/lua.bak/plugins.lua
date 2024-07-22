return {
	{
		"uga-rosa/ccc.nvim",
		version = ">=2.0.0",
		lazy = false,
		config = function()
			require("ccc").setup({
				highlighter = {
					auto_enable = true,
				},
			})
		end,
		-- config = function()
		--   local ColorInput = require("ccc.input")
		--   local convert = require("ccc.utils.convert")
		--
		--   local RgbHslCmykInput = setmetatable({
		--     name = "RGB/HSL/CMYK",
		--     max = { 1, 1, 1, 360, 1, 1, 1, 1, 1, 1 },
		--     min = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
		--     delta = { 1 / 255, 1 / 255, 1 / 255, 1, 0.01, 0.01, 0.005, 0.005, 0.005, 0.005 },
		--     bar_name = { "R", "G", "B", "H", "S", "L", "C", "M", "Y", "K" },
		--   }, { __index = ColorInput })
		--
		--   function RgbHslCmykInput.format(n, i)
		--     if i <= 3 then
		--       -- RGB
		--       n = n * 255
		--     elseif i == 5 or i == 6 then
		--       -- S or L of HSL
		--       n = n * 100
		--     elseif i >= 7 then
		--       -- CMYK
		--       return ("%5.1f%%"):format(math.floor(n * 200) / 2)
		--     end
		--     return ("%6d"):format(n)
		--   end
		--
		--   function RgbHslCmykInput.from_rgb(RGB)
		--     local HSL = convert.rgb2hsl(RGB)
		--     local CMYK = convert.rgb2cmyk(RGB)
		--     local R, G, B = unpack(RGB)
		--     local H, S, L = unpack(HSL)
		--     local C, M, Y, K = unpack(CMYK)
		--     return { R, G, B, H, S, L, C, M, Y, K }
		--   end
		--
		--   function RgbHslCmykInput.to_rgb(value)
		--     return { value[1], value[2], value[3] }
		--   end
		--
		--   function RgbHslCmykInput:_set_rgb(RGB)
		--     self.value[1] = RGB[1]
		--     self.value[2] = RGB[2]
		--     self.value[3] = RGB[3]
		--   end
		--
		--   function RgbHslCmykInput:_set_hsl(HSL)
		--     self.value[4] = HSL[1]
		--     self.value[5] = HSL[2]
		--     self.value[6] = HSL[3]
		--   end
		--
		--   function RgbHslCmykInput:_set_cmyk(CMYK)
		--     self.value[7] = CMYK[1]
		--     self.value[8] = CMYK[2]
		--     self.value[9] = CMYK[3]
		--     self.value[10] = CMYK[4]
		--   end
		--
		--   function RgbHslCmykInput:callback(index, new_value)
		--     self.value[index] = new_value
		--     local v = self.value
		--     if index <= 3 then
		--       local RGB = { v[1], v[2], v[3] }
		--       local HSL = convert.rgb2hsl(RGB)
		--       local CMYK = convert.rgb2cmyk(RGB)
		--       self:_set_hsl(HSL)
		--       self:_set_cmyk(CMYK)
		--     elseif index <= 6 then
		--       local HSL = { v[4], v[5], v[6] }
		--       local RGB = convert.hsl2rgb(HSL)
		--       local CMYK = convert.rgb2cmyk(RGB)
		--       self:_set_rgb(RGB)
		--       self:_set_cmyk(CMYK)
		--     else
		--       local CMYK = { v[7], v[8], v[9], v[10] }
		--       local RGB = convert.cmyk2rgb(CMYK)
		--       local HSL = convert.rgb2hsl(RGB)
		--       self:_set_rgb(RGB)
		--       self:_set_hsl(HSL)
		--     end
		--   end
		--
		--   require("ccc").setup({
		--     inputs = {
		--       RgbHslCmykInput,
		--     },
		--   })
		-- end,
	},
	-- {
	--   "norcalli/nvim-colorizer.lua",
	--   config = function()
	--     require("colorizer").setup({
	--       "python",
	--       css = {
	--         css = true;
	--       },
	--       "html",
	--       "toml",
	--       "vue",
	--       "jsonc",
	--       "markdown",
	--       "scss",
	--       "less",
	--       "javascript",
	--     })
	--   end,
	-- },
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
		config = function()
			require("telescope").load_extension("emoji")
			require("telescope").load_extension("file_browser")

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
		end,
	},
}
