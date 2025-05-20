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
}
