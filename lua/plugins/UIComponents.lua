return {
	{ "nvim-tree/nvim-web-devicons" },
	-- bar tab
	--
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				-- Configure Tokyo Night to be transparent
				terminal_colors = true,
				styles = {
					-- Style to be applied to different syntax groups
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
				},
			})

			vim.cmd.colorscheme("tokyonight")

			-- Additional transparency settings if needed
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
			-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},
	{
		{
			"romgrk/barbar.nvim",
			dependencies = {
				"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
				"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
			},
			init = function()
				vim.g.barbar_auto_setup = false
			end,
			opts = {
				animation = true,
				auto_hide = false,
				tabpages = true,
				clickable = true,
				focus_on_close = "left",
				hide = { inactive = false }, -- Set to false to always show all buffers
				highlight_visible = true,
				icons = {
					buffer_index = false,
					buffer_number = false,
					button = "",
					filetype = {
						custom_colors = false,
						enabled = true,
					},
					separator = { left = "▎", right = "" },
					separator_at_end = true,
					modified = { button = "●" },
					pinned = { button = "", filename = true },
					preset = "default",
				},
			},
			version = "^1.0.0",
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					position = "left",
					width = 30,
					mappings = {
						["a"] = { "add", config = { show_path = "relative" } }, -- create file (append / for folder)
						["A"] = { "add_directory", config = { show_path = "relative" } }, -- create folder
						["d"] = "delete",
						["r"] = "rename",
						["m"] = { "move", config = { show_path = "relative" } },
						["c"] = { "copy", config = { show_path = "relative" } },
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
					},
				},
				filesystem = {
					follow_current_file = { enabled = true },
					hijack_netrw_behavior = "open_current",
				},
			})
			vim.keymap.set("n", "<leader>sft", ":Neotree toggle<CR>", {
				noremap = true,
				silent = true,
				desc = "[S]how [F]older [T]ree",
			})
		end,
	},
}
