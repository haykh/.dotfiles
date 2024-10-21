return {
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_executor = {
				name = "toggleterm",
				default_opts = {
					toggleterm = {
						direction = "horizontal",
						close_on_exit = true,
					},
				},
			},
			cmake_runner = {
				name = "toggleterm",
				default_opts = {
					toggleterm = {
						direction = "horizontal",
						close_on_exit = true,
					},
				},
			},
			cmake_notifications = {
				runner = { enabled = false },
			},
			cmake_build_directory = function()
				local osys = require("cmake-tools.osys")
				if osys.iswin32 then
					return "build\\${variant:buildType}"
				end
				return "build/${variant:buildType}"
			end,
			cmake_virtual_text_support = false,
		},
	},
}
