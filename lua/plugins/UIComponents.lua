return {
	{ "nvim-tree/nvim-web-devicons" },
	-- bar tab
	--
	{
		"sainnhe/gruvbox-material",
		lazy = false, -- Load theme immediately
		priority = 1000, -- Load before other plugins
		config = function()
			-- Set up Gruvbox Material options before loading the colorscheme
			vim.g.gruvbox_material_background = "soft" -- Options: 'hard', 'medium', 'soft'
			vim.g.gruvbox_material_foreground = "material" -- Options: 'material', 'mix', 'original'
			vim.g.gruvbox_material_enable_italic = 1 -- Enable italic comments
			vim.g.gruvbox_material_enable_bold = 1 -- Enable bold
			vim.g.gruvbox_material_disable_italic_comment = 0 -- Keep italic comments
			vim.g.gruvbox_material_transparent_background = 0 -- Set to 1 for transparent background
			vim.g.gruvbox_material_visual = "reverse" -- Options: 'grey background', 'green background', 'blue background', 'red background', 'reverse'
			vim.g.gruvbox_material_menu_selection_background = "grey" -- Options: 'grey', 'red', 'orange', 'yellow', 'green', 'aqua', 'blue', 'purple'
			vim.g.gruvbox_material_sign_column_background = "none" -- Options: 'none', 'grey'
			vim.g.gruvbox_material_spell_foreground = "none" -- Options: 'none', 'colored'
			vim.g.gruvbox_material_ui_contrast = "low" -- Options: 'low', 'high'
			vim.g.gruvbox_material_float_style = "bright" -- Options: 'bright', 'dim'
			vim.g.gruvbox_material_statusline_style = "material" -- Options: 'default', 'mix', 'original'
			vim.g.gruvbox_material_better_performance = 1 -- Disable extra highlights for better performance

			-- Load the colorscheme
			vim.cmd.colorscheme("gruvbox-material")
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
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.api.nvim_set_keymap("n", "<C-e>", ":Neotree toggle<CR>", {
				noremap = true,
				silent = true,
				desc = "Open File Explorer",
			})
		end,
	},
}
