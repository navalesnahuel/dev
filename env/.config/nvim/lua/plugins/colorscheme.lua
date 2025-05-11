return {
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_enable_italic = true
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_diagnostic_text_highlight = 1
			vim.g.gruvbox_material_diagnostic_line_highlight = 1
			vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
			vim.g.gruvbox_material_foreground = "original"
		end,
	},
	{
		"neanias/everforest-nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("everforest").setup({
				background = "soft",
				italics = true,
				disable_italic_comments = false,
				diagnostic_text_highlight = true,
				diagnostic_line_highlight = true,
				diagnostic_virtual_text = "colored",
			})
		end,
	},
}
