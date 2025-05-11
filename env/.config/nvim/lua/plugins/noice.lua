return {
	"folke/noice.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		-- Disable most features
		cmdline = {
			enabled = true,
			view = "cmdline", -- Use traditional cmdline at bottom, not a popup
		},

		messages = {
			enabled = true,
			view = "mini", -- Use minimal message view
			view_error = "mini",
			view_warn = "mini",
		},

		-- Disable fancy popups, keep things minimal
		popupmenu = {
			enabled = true, -- Use Vim's native popupmenu instead
		},

		-- Disable notifications
		notify = {
			enabled = false,
		},

		-- Keep only essential LSP UI elements
		lsp = {
			-- Minimal overrides for functionality
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			-- Disable additional UI features
			hover = { enabled = true },
			signature = { enabled = false },
			message = { enabled = false },
			progress = { enabled = false },
		},

		-- Disable health checks to reduce startup messages
		health = {
			checker = false,
		},

		-- Disable most presets
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = false,
			inc_rename = false,
			lsp_doc_border = false,
		},
	},
}
