return {
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"b0o/SchemaStore.nvim",
			"folke/neodev.nvim",
		},

		config = function()
			require("neodev").setup({})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local lspconfig = require("lspconfig")

			local function on_attach(_, bufnr)
				vim.api.nvim_buf_set_keymap(
					bufnr,
					"n",
					"gD",
					"<Cmd>rightbelow vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>",
					{ noremap = true, silent = true }
				)

				vim.api.nvim_buf_set_keymap(
					bufnr,
					"n",
					"gd",
					"<Cmd>lua vim.lsp.buf.hover()<CR>",
					{ noremap = true, silent = true }
				)
			end

			local servers = {
				gopls = {
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							templateExtensions = { "gohtml", "gotmpl", "tmpl" },
						},
					},
				},
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				bashls = true,
				pbls = true,
				svelte = true,
				cssls = true,
				html = {
					filetypes = { "html", "templ", "gohtml", "gotmpl" },
					settings = {
						html = {
							format = {
								templating = true,
								wrapLineLength = 120,
								unformatted = "wbr",
								contentUnformatted = "pre,code,textarea",
								indentInnerHtml = false,
								preserveNewLines = true,
								indentHandlebars = false,
								endWithNewline = false,
								extraLiners = "head,body,/html",
								wrapAttributes = "auto",
							},
							hover = {
								documentation = true,
								references = true,
							},
						},
					},
				},
				tsserver = {
					settings = {
						typescript = { suggest = { enabled = false } },
						javascript = { suggest = { enabled = false } },
						init_options = {
							preferences = {
								disableSuggestions = true,
							},
							maxTsServerMemory = 4096,
							tsserver = {
								watchOptions = {
									watchFile = "off",
								},
							},
						},
					},
				},
				templ = {
					filetypes = { "templ", "gohtml", "gotmpl" },
				},

				tailwindcss = {
					filetypes = { "html", "templ", "gohtml", "gotmpl", "css", "scss", "javascript", "typescript" },
					settings = {
						tailwindcss = {
							experimental = {
								classregex = {
									"class[:]?\\s*[\"']([^\"']*)[\"']",
									"hx-[\\w-]*\\s*[\"']([^\"']*)[\"']",
									"{{.*?class.*?[\"']([^\"']*)[\"'].*?}}",
								},
							},
							includelanguages = {
								templ = "html",
								gohtml = "html",
								gotmpl = "html",
							},
						},
					},
				},

				htmx = {
					filetypes = { "html", "templ", "gohtml", "gotmpl" },
				},
				-- emmet_language_server = true,
				lua_ls = {
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = { enable = false },
						},
					},
				},
				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			}

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, config)

				lspconfig[name].setup(config)
			end

			vim.lsp.handlers["textDocument/semanticTokens/full"] = function() end
			vim.diagnostic.config({
				virtual_text = { prefix = "" },
				signs = false,
				underline = false,
				update_in_insert = false,
				float = {
					border = "single",
					source = "always",
				},
			})
		end,
	},
}
