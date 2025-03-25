return {
	"numToStr/Comment.nvim",
	lazy = false, -- or `event = "VeryLazy"` to lazy-load
	config = function()
		require("Comment").setup()
	end,
}
