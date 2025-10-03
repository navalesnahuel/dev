return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_isable_italic_comment = 0
			vim.g.gruvbox_material_enable_italic = 0
			vim.g.gruvbox_material_enable_bold = 0

			vim.g.gruvbox_material_better_performance = 1

			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_line_highlight = 1

			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_foreground = "mix"

			vim.g.gruvbox_material_menu_selection_background = "blue"
			vim.g.gruvbox_material_visual = "blue background"
			vim.g.gruvbox_material_ui_contrast = "high"

			vim.g.gruvbox_material_floating_window_style = "bright"
			vim.g.gruvbox_material_transparent_background = 1

			vim.g.gruvbox_material_colors_override = { fg0 = { "#ebdbb2", "233" } }
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		name = "kanagawa",
		config = function()
			require("kanagawa").setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = false },
				functionStyle = {},
				keywordStyle = { italic = false },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = true,
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true,
				colors = {
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				overrides = function(colors)
					return {}
				end,
				theme = "dragon",
				background = { -- map the value of 'background' option to a theme
					dark = "dragon", -- try "dragon" !
					light = "lotus",
				},
			})
		end,
	},

	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_isable_italic_comment = 0
			vim.g.sonokai_enable_italic = 0
			vim.g.sonokai_enable_bold = 0

			vim.g.sonokai_better_performance = 1

			vim.g.sonokai_diagnostic_virtual_text = "colored"
			vim.g.sonokai_diagnostic_text_highlight = 1
			vim.g.sonokai_diagnostic_line_highlight = 1

			vim.g.sonokai_background = "hard"
			vim.g.sonokai_foreground = "mix"

			vim.g.sonokai_menu_selection_background = "blue"
			vim.g.sonokai_visual = "blue background"
			vim.g.sonokai_ui_contrast = "high"

			vim.g.sonokai_floating_window_style = "bright"
			vim.g.sonokai_transparent_background = 1
			vim.g.sonokai_style = "shusia"
		end,
	},

	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- auto, main, moon, or dawn
				dark_variant = "moon", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				styles = {
					italic = false,
					transparency = true,
				},
			})
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				extend_background_behind_borders = true,
				dim_inactive_windows = false,
				style = "moon",
				transparent = true,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
					functions = { bold = false },
				},
			})
		end,
	},
}
