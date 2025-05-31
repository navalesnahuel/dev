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
		"sainnhe/everforest",
		priority = 1000,
		config = function()
			vim.g.everforest_isable_italic_comment = 0
			vim.g.everforest_enable_italic = 0
			vim.g.everforest_enable_bold = 0

			vim.g.everforest_better_performance = 1

			vim.g.everforest_diagnostic_virtual_text = "colored"
			vim.g.everforest_diagnostic_text_highlight = 1
			vim.g.everforest_diagnostic_line_highlight = 1

			vim.g.everforest_background = "hard"
			vim.g.everforest_foreground = "hard"

			vim.g.everforest_menu_selection_background = "blue"
			vim.g.everforest_visual = "blue background"
			vim.g.everforest_ui_contrast = "high"

			vim.g.everforest_floating_window_style = "bright"
			vim.g.everforest_transparent_background = 1

			-- vim.g.everforest_colors_override = { fg0 = { "#ebdbb2", "233" } }
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				styles = {
					bold = false,
					italic = false,
					transparency = true,
				},
			})
		end,
	},
}
