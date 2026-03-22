-- Keymaps for the NewEraNeovim theme/environment library.
-- All keymaps live under <leader>t (Toggle) and <leader>ta (Appearance).

return {
	{
		dir = ".",
		name = "theme-keymaps",
		lazy = false,
		config = function()
			local lib = require("lib")
			local map = vim.keymap.set

			-- == Theme ==
			map("n", "<leader>tac", lib.theme.pick, { desc = "[C]olorscheme picker" })
			map("n", "<leader>tab", lib.visual.toggle_background, { desc = "[B]ackground dark/light" })

			-- == Transparency ==
			map("n", "<leader>tat", lib.transparency.toggle, { desc = "[T]ransparency toggle" })

			-- == Highlights ==
			map("n", "<leader>tai", function()
				lib.hl.italic_comments(true)
			end, { desc = "[I]talic comments on" })
			map("n", "<leader>taI", function()
				lib.hl.italic_comments(false)
			end, { desc = "Italic comments off" })

			-- == Cursor ==
			map("n", "<leader>tl", lib.cursor.toggle_cursorline, { desc = "Cursor[l]ine toggle" })
			map("n", "<leader>tC", lib.cursor.toggle_cursorcolumn, { desc = "[C]ursorcolumn toggle" })

			-- == Numbers ==
			map("n", "<leader>tn", lib.numbers.toggle, { desc = "Line [n]umbers toggle" })
			map("n", "<leader>tr", lib.numbers.toggle_relative, { desc = "[R]elative numbers toggle" })
			map("n", "<leader>tg", lib.numbers.toggle_signcolumn, { desc = "Si[g]ncolumn toggle" })

			-- == Statusline ==
			map("n", "<leader>ts", lib.statusline.toggle, { desc = "[S]tatusline toggle" })

			-- == Visual ==
			map("n", "<leader>tw", lib.visual.toggle_wrap, { desc = "[W]rap toggle" })
			map("n", "<leader>ti", lib.visual.toggle_listchars, { desc = "L[i]stchars toggle" })
			map("n", "<leader>tp", lib.visual.toggle_spell, { desc = "S[p]ell toggle" })
			map("n", "<leader>tc", lib.visual.toggle_colorcolumn, { desc = "[c]olorcolumn toggle" })
			map("n", "<leader>te", lib.visual.toggle_conceal, { desc = "Conc[e]al toggle" })
		end,
	},
}
