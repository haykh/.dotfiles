return {
	{ import = "lazyvim.plugins.extras.lang.cmake" },
	{
		"Civitasv/cmake-tools.nvim",
		opts = {
			cmake_virtual_text_support = false,
			cmake_build_directory = function()
				local osys = require("cmake-tools.osys")
				if osys.iswin32 then
					return "build\\${variant:buildType}"
				end
				return "build/${variant:buildType}"
			end,
		},
	},
}
