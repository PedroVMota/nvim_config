return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		local wk = require("which-key")
		local lib = require("lib")

		wk.setup({
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
		})

		-- Register groups and theme keymaps
		wk.add({
			-- Groups
			{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
			{ "<leader>d", group = "[D]ocument" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			{ "<leader>m", group = "[M]ason", mode = { "n" } },

			-- Toggle / Appearance group
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>ta", group = "[A]ppearance" },

			-- Appearance keymaps
			{ "<leader>tac", lib.theme.pick, desc = "Colorscheme picker" },
			{ "<leader>tab", lib.visual.toggle_background, desc = "Background dark/light" },
			{ "<leader>tat", lib.transparency.toggle, desc = "Transparency toggle" },
			{
				"<leader>tai",
				function()
					lib.hl.italic_comments(true)
				end,
				desc = "Italic comments on",
			},
			{
				"<leader>taI",
				function()
					lib.hl.italic_comments(false)
				end,
				desc = "Italic comments off",
			},

			-- Toggle keymaps
			{ "<leader>tl", lib.cursor.toggle_cursorline, desc = "Cursorline toggle" },
			{ "<leader>tC", lib.cursor.toggle_cursorcolumn, desc = "Cursorcolumn toggle" },
			{ "<leader>tn", lib.numbers.toggle, desc = "Line numbers toggle" },
			{ "<leader>tr", lib.numbers.toggle_relative, desc = "Relative numbers toggle" },
			{ "<leader>tg", lib.numbers.toggle_signcolumn, desc = "Signcolumn toggle" },
			{ "<leader>ts", lib.statusline.toggle, desc = "Statusline toggle" },
			{ "<leader>tw", lib.visual.toggle_wrap, desc = "Wrap toggle" },
			{ "<leader>ti", lib.visual.toggle_listchars, desc = "Listchars toggle" },
			{ "<leader>tp", lib.visual.toggle_spell, desc = "Spell toggle" },
			{ "<leader>tc", lib.visual.toggle_colorcolumn, desc = "Colorcolumn toggle" },
			{ "<leader>te", lib.visual.toggle_conceal, desc = "Conceal toggle" },
		})
	end,
}
