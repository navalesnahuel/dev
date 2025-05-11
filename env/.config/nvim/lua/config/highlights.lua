local function apply_custom_highlights()
	vim.api.nvim_set_hl(0, "@comment", { fg = "#2ea542", italic = true })
	vim.api.nvim_set_hl(0, "@comment.documentation", { fg = "#2ea542", italic = true })

	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "None" })

	vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "None", bold = true })
	vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "None", bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = "None", bg = "None" })
	vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "None", bold = true })
end

-- Cuando se carga un colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("custom_highlights_all", { clear = true }),
	pattern = "*",
	callback = apply_custom_highlights,
})

-- Cuando se atacha un LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("custom_highlights_lsp", { clear = true }),
	callback = function()
		vim.schedule(apply_custom_highlights) -- aseguras que sea después del LSP
	end,
})

-- Cuando entrás a un buffer (por si algo se aplica ahí)
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("custom_highlights_buf", { clear = true }),
	callback = function()
		vim.schedule(apply_custom_highlights)
	end,
})

-- keymap para toggle entre gruvbox y everforest
vim.keymap.set("n", "<leader>ut", function()
	local current = vim.g.colors_name
	if current == "gruvbox-material" then
		vim.cmd("colorscheme everforest")
	else
		vim.cmd("colorscheme gruvbox-material")
	end
end, { desc = "Toggle between gruvbox-material and everforest" })
