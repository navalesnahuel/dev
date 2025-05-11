return {
	"glepnir/lspsaga.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local map = vim.keymap.set
		local lspsaga = require("lspsaga")

		lspsaga.setup({
			ui = {
				border = "single",
				code_action = "",
				colors = {},
				expand = "",
				collapse = "",
				kind = {},
				winblend = 0, -- no transparency
				title = false, -- remove header titles
			},
			symbol_in_winbar = { enable = false },
			lightbulb = { enable = false },
			outline = { win_position = "right", layout = "normal" },
			code_action = {
				show_server_name = false,
				extend_gitsigns = false,
				keys = {
					quit = "q",
					exec = "<CR>",
				},
			},
			diagnostic = {
				show_code_action = false,
				show_layout = "float",
				text_hl_follow = false,
				max_width = 60,
				max_height = 10,
				keys = {
					quit = "q",
				},
			},

			hover = {
				max_width = 60,
			},
		})

		-- Keymaps
		local opts = { noremap = true, silent = true }

		map("n", "<leader>sR", "<cmd>Lspsaga rename<CR>", { desc = "Rename Symbol", silent = true })
		map("n", "<leader>xx", "<cmd>Lspsaga show_buf_diagnostics<CR>", { desc = "Buffer Diagnostics", unpack(opts) })
		map(
			"n",
			"<leader>xX",
			"<cmd>Lspsaga show_workspace_diagnostics<CR>",
			{ desc = "Workspace Diagnostics", unpack(opts) }
		)
		map("n", "<leader>xn", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic", unpack(opts) })
		map("n", "<leader>xN", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic", unpack(opts) })

		map("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "Outline", unpack(opts) })
		map("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", { desc = "LSP Finder", unpack(opts) })
	end,
}
