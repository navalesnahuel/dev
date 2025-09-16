require("config.highlights")
require("config.options")
require("config.lazy")
require("config.keymaps")

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = "*",
	command = "checktime",
})

vim.cmd("colorscheme rose-pine")

-- require("theme.jaguar").setup({
-- 	-- Customize the theme
-- 	styles = {
-- 		bold = true,
-- 		italic = false,
-- 	},
-- 	-- Enable/disable features
-- 	dim_inactive_windows = true,
-- 	extend_background_behind_borders = true,
-- })
--
-- -- Load the jaguar theme
-- require("theme.jaguar").colorscheme()
