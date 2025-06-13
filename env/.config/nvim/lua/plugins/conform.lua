return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	config = function()
		require("conform").setup({
			-- Usar format_on_save en lugar de autocmd manual
			format_on_save = {
				lsp_format = false,
				async = false,
				timeout_ms = 300,
			},
			formatters_by_ft = {
				-- python = { "isort", "black" },
				lua = { "stylua" },
				sh = { "shfmt" },
				javascript = { "prettierd" },
				typescript = { "prettierd" }, -- Agregado TypeScript
				javascriptreact = { "prettierd" }, -- Agregado JSX
				typescriptreact = { "prettierd" }, -- Agregado TSX
				go = { "goimports", "gofmt" },
				svelte = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
			},
			formatters = {
				prettierd = {
					prepend_args = {
						"--tab-width=4",
						"--use-tabs=false",
					},
				},
			},
		})
	end,
}
