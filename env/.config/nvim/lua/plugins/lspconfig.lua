return {
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },

        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport = true

            local function on_attach(client, bufnr)
                -- Keybindings for LSP features

                vim.api.nvim_buf_set_keymap(
                    bufnr,
                    "n",
                    "gD",                                               -- Change to gD for definition
                    "<Cmd>rightbelow vsplit<CR><Cmd>lua vim.lsp.buf.definition()<CR>", -- Open definition in a vertical split to the right
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

            -- Lua Server
            require("lspconfig").lua_ls.setup({
                on_attach = on_attach,
                filetypes = "lua",
            })

            require("lspconfig").pbls.setup({
                on_attach = on_attach,
                filetypes = "proto",
            })

            -- Go Server

            require("lspconfig").gopls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            nilness = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            })

            -- Python Server
            require("lspconfig").pyright.setup({
                on_attach = on_attach,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            useLibraryCodeForTypes = true,
                        },
                    },
                },
            })

            -- TypeScript Server
            require("lspconfig").ts_ls.setup({
                capabilities = capabilities,
                filetypes = {
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "html",
                },
                on_attach = on_attach,
            })

            -- HTML Server
            require("lspconfig").html.setup({
                capabilities = capabilities,
                filetypes = { "html" },
                on_attach = on_attach,
            })

            -- CSS Server
            require("lspconfig").cssls.setup({
                capabilities = capabilities,
                filetypes = { "css" },
                on_attach = on_attach,
            })

            -- Svelte Server
            require("lspconfig").svelte.setup({
                capabilities = capabilities,
                filetypes = { "svelte" },
                on_attach = on_attach,
            })

            -- TailwindCSS Server
            require("lspconfig").tailwindcss.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })

            -- Bash Server
            require("lspconfig").bashls.setup({ capabilities = capabilities, filetypes = { "bash", "sh" } })

            -- Docker Server
            require("lspconfig").dockerls.setup({
                capabilities = capabilities,
                filetypes = { "Dockerfile", "yml", "yaml" },
            })
            -- Yaml Server
            require("lspconfig").yamlls.setup({ capabilities = capabilities, filetypes = { "yaml", "yml" } })

            -- Emmet Server
            require("lspconfig").emmet_language_server.setup({
                capabilities = capabilities,
                filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue", "jsx", "tsx" },
                on_attach = on_attach,
            })

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
