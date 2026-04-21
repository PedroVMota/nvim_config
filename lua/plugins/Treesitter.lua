return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		-- New API: no more setup(), parsers are installed directly
		require("nvim-treesitter").install({
			"bash", "c", "cpp", "diff", "go", "gomod", "gosum",
			"hcl", "html", "lua", "luadoc", "markdown",
			"markdown_inline", "query", "rust", "terraform",
			"vim", "vimdoc", "yaml",
		}):wait()

		-- Highlighting is enabled per-filetype via native Neovim API
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("newera-treesitter", { clear = true }),
			callback = function(ev)
				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
}
