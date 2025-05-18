return {
	"hrsh7th/nvim-cmp",
	lazy = false,
	priority = 100,
	event = "InsertEnter",
	dependencies = {
		"onsails/lspkind.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		lspkind.init({})

		-- Load snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "buffer" },
			}),

			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-y>"] = cmp.mapping.confirm({
					select = true,
					behavior = cmp.ConfirmBehavior.Insert,
				}),
				["<C-n>"] = cmp.mapping.select_next_item({
					behavior = cmp.ConfirmBehavior.Insert,
				}),
				["<C-p>"] = cmp.mapping.select_prev_item({
					behavior = cmp.ConfirmBehavior.Insert,
				}),
			}),

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			-- window = {
			-- 	completion = cmp.config.window.bordered(),
			-- 	documentation = cmp.config.window.bordered(),
			-- },
		})

		cmp.setup.filetype({ "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
		})
	end,
}
