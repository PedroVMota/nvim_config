return {
	{

		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		lazy = false, -- or `event = "VeryLazy"` to lazy-load
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
}
