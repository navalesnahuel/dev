vim.keymap.set("n", "J", "gj") -- J moves down visually

-- Remap q: to <NOP> to disable the command history buffer
vim.api.nvim_set_keymap("n", "q:", "<NOP>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Remap < y > para mantener el modo visual
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

-- keymap para toggle entre gruvbox y everforest
vim.keymap.set("n", "<leader>ut", function()
	local current = vim.g.colors_name
	if current == "gruvbox-material" then
		vim.cmd("set background=light")
		vim.cmd("colorscheme everforest")
	else
		vim.cmd("set background=dark")
		vim.cmd("colorscheme gruvbox-material")
	end
end, { desc = "Toggle between gruvbox-material and everforest" })
