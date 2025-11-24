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
	-- {
	-- 	"nvim-neo-tree/neo-tree.nvim",
	-- 	branch = "v3.x",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- 	config = function()
	-- 		vim.api.nvim_set_keymap("n", "<C-e>", ":Neotree toggle<CR>", {
	-- 			noremap = true,
	-- 			silent = true,
	-- 			desc = "Open File Explorer",
	-- 		})
	-- 	end,
	-- },
	{
		"vyfor/cord.nvim",
		build = ":Cord update",
		event = "VeryLazy",
		config = function()
			require("cord").setup({
				usercmds = true,
				log_level = "info",
				timer = {
					interval = 1500,
					reset_on_idle = false,
					reset_on_change = false,
				},
				editor = {
					image = nil,
					client_id = "365525338924646402",
					tooltip = "The One True Text Editor",
				},
				display = {
					show_time = true,
					show_repository = true,
					show_cursor_position = false,
					swap_fields = false,
					swap_icons = false,
					workspace_blacklist = {},
					theme = "default",
				},
				lsp = {
					show_problem_count = false,
					severity = 1,
					scope = "workspace",
				},
				idle = {
					enable = true,
					show_status = true,
					timeout = 300000,
					disable_on_focus = true,
					text = "Idle",
					tooltip = "💤",
				},
				text = {
					viewing = "My life <3",
					editing = "My life <3",
					file_browser = "Browsing files in {}",
					plugin_manager = "Managing plugins in {}",
					lsp_manager = "Configuring LSP in {}",
					vcs = "Committing changes in {}",
					workspace = "In {}",
				},
			})
		end,
	},
}
