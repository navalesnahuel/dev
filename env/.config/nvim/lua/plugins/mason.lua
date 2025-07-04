return {
	"williamboman/mason.nvim",
	version = "1.11.0",
	cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
	event = { "VeryLazy" },
	dependencies = {
		{
			"williamboman/mason-lspconfig.nvim",
			lazy = true,
			version = "1.32.0",
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			lazy = true,
		},
	},
	config = function()
		vim.defer_fn(function()
			local mason = require("mason")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			vim.defer_fn(function()
				local mason_lspconfig = require("mason-lspconfig")

				mason_lspconfig.setup({
					ensure_installed = {
						"ts_ls",
						"html",
						"jsonls",
						"yamlls",
						"cssls",
						"pbls",
						"tailwindcss",
						"gopls",
						"svelte",
						"bashls",
						"sqls",
						"lua_ls",
						"graphql",
						"prismals",
						"pyright",
					},
					automatic_installation = true,
				})

				vim.defer_fn(function()
					local mason_tool_installer = require("mason-tool-installer")

					mason_tool_installer.setup({
						ensure_installed = {
							"prettier",
							"prettierd",
							"stylua",
							"goimports",
							"isort",
							"black",
							"shfmt",
							"pylint",
							"eslint_d",
							"htmx-lsp",
							"eslint",
							"ruff",
							"golangci-lint",
							"gofumpt",
						},
					})
				end, 100)
			end, 50)
		end, 0)
	end,
}
