return {
	"folke/zen-mode.nvim",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	config = function()
		local keymap = vim.keymap.set

		keymap("n", "<C-z>", "<cmd>:ZenMode<CR>", {
			noremap = true,
			silent = true,
			desc = "Focus mode!",
		})
	end,
}
