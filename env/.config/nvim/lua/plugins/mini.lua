return {
	{
		"echasnovski/mini.nvim",

		config = function()
			-- Configuración de mini.pairs
			require("mini.pairs").setup({
				modes = { insert = true, command = true, terminal = false },
				-- Skip autopair when the next character is one of these
				skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
				-- Skip autopair when the cursor is inside these treesitter nodes
				skip_ts = { "string" },
				-- Skip autopair when the next character is a closing pair
				-- and there are more closing pairs than opening pairs
				skip_unbalanced = true,
				-- Better deal with markdown code blocks
				markdown = true,
			})

			-- Configuración de mini.ai
			local ai = require("mini.ai")
			ai.setup({
				n_lines = 500, -- Número máximo de líneas que se procesarán
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- Bloques de código
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- Funciones
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- Clases
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- Etiquetas HTML/XML
					d = { "%f[%d]%d+" }, -- Dígitos
					e = { -- Palabras con distinción de mayúsculas
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					u = ai.gen_spec.function_call(), -- Uso de funciones
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- Llamadas a funciones sin el punto
				},
			})

			require("mini.surround").setup({
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding
					replace = "sr", -- Replace surrounding
				},
			})
			require("mini.move").setup()
		end,
	},
}
