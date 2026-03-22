return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Install parsers (only if tree-sitter CLI is available)
		if vim.fn.executable("tree-sitter") == 1 then
			ts.install({
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
		else
			vim.notify(
				"tree-sitter CLI not found. Run install.sh or: npm install -g tree-sitter-cli",
				vim.log.levels.WARN,
				{ title = "NewEraNeovim" }
			)
		end

		-- Enable treesitter highlight for all filetypes
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("newera-treesitter", { clear = true }),
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
