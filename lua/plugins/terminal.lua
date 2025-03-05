print("Loading terminal config")

return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")

		-- Setup ToggleTerm
		toggleterm.setup({
			open_mapping = [[<C-t>]], -- Open floating terminal with Ctrl + t
			direction = "float", -- Use a floating terminal
			shade_terminals = {}, -- Dim background
			start_in_insert = true, -- Start in insert mode
		})
	end,
}
