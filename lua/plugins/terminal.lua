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
			shade_terminals = true, -- Dim background
			start_in_insert = true, -- Start in insert mode
		})

		-- Terminal Keybinds
		local keymap = vim.api.nvim_set_keymap
		local opts = { noremap = true, silent = true }

		-- Toggle floating terminal
		keymap("n", "<C-t>", ":ToggleTerm<CR>", opts)

		-- Terminal in horizontal or vertical split
		keymap("n", "<leader>th", ":split | terminal<CR>", opts)
		keymap("n", "<leader>tv", ":vsplit | terminal<CR>", opts)

		-- Register with which-key.nvim
		local wk = require("which-key")
		wk.register({
			["<C-t>"] = { ":ToggleTerm<CR>", "Open Terminal" },
			["<leader>th"] = { ":split | terminal<CR>", "Terminal in Horizontal Split" },
			["<leader>tv"] = { ":vsplit | terminal<CR>", "Terminal in Vertical Split" },
		})
	end,
}
