return {
	-- Treesitter Playground
	{
		"nvim-treesitter/playground",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},

	-- Vim be good
	{ "ThePrimeagen/vim-be-good" },

	-- LuaSnip + Friendly Snippets
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		event = "InsertEnter",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- Which Key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			win = {
				border = "none", -- Sin bordes
				padding = { 1, 1 }, -- Padding mínimo (Vertical, Horizontal)
			},
			layout = {
				height = { min = 1 }, -- Permitir altura mínima de 1 línea
				width = { min = 10 }, -- Ancho mínimo pequeño
				spacing = 1, -- Espacio mínimo entre columnas
				align = "left", -- Alineación del texto
			},
			icons = {
				breadcrumb = "»", -- Icono separador de niveles
				separator = "➜", -- Icono separador entre tecla y descripción
				group = "", -- Sin icono para grupos (más minimalista)
			},
			plugins = {
				marks = false, -- No mostrar marcadores automáticamente
				registers = false, -- No mostrar registros automáticamente
				spelling = { enabled = false }, -- Desactiva sugerencias de spelling si aparecen
			},
			-- No establecemos 'preset', usamos defaults + nuestros ajustes.
		},
	},

	-- Venv Selector
	{
		"linux-cultist/venv-selector.nvim",
		cmd = "VenvSelect",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python", -- optional
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		lazy = true,
		branch = "regexp",
		config = function()
			require("venv-selector").setup({
				name = ".venv",
			})
		end,
		keys = {
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
		},
	},
}
