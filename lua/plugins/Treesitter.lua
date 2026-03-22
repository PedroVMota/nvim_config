return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Install parsers
		require("nvim-treesitter").install({
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		})

		-- Enable treesitter highlight and indent for all filetypes
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("newera-treesitter", { clear = true }),
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
