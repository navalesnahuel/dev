local set = vim.keymap.set

-- Remap q: to <NOP> to disable the command history buffer
set("n", "q:", function() end, { noremap = true, silent = true })

-- Diagnostic pop up
set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Remap < y > para mantener el modo visual
set("v", "<", "<gv", { silent = true })
set("v", ">", ">gv", { silent = true })

-- Basic movement keybinds, these make navigating splits easy for me
set("n", "<c-j>", "<c-w><c-j>")
set("n", "<c-k>", "<c-w><c-k>")
set("n", "<c-l>", "<c-w><c-l>")
set("n", "<c-h>", "<c-w><c-h>")

-- Default diagnostic movement
set("n", "]d", vim.diagnostic.goto_next)
set("n", "[d", vim.diagnostic.goto_prev)

-- These mappings control the size of splits (height/width)
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-t>", "<C-W>+")
set("n", "<M-s>", "<C-W>-")
