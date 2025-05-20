return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go", -- Go debugger
			"rcarriga/nvim-dap-ui", -- UI para dap
			"theHamsta/nvim-dap-virtual-text", -- Variables inline
			"nvim-neotest/nvim-nio", -- no necesariamente dap, pero lo tienes
			"williamboman/mason.nvim", -- Instalador de herramientas (incluye dap adapters)
			"jay-babu/mason-nvim-dap.nvim", -- Integración mason <-> nvim-dap
			"mfussenegger/nvim-dap-python", -- Adaptador python
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()
			require("mason").setup()
			require("mason-nvim-dap").setup({
				automatic_setup = true,
				handlers = {},
			})

			require("nvim-dap-virtual-text").setup({
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			-- Configuración para Python con nvim-dap-python
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python") -- Cambia por tu path a debugpy si es otro

			-- Configuración manual para JavaScript/TypeScript con Node.js
			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
			}
			dap.configurations.javascript = {
				{
					type = "node2",
					request = "launch",
					name = "Launch Node",
					program = "${file}",
					cwd = vim.loop.cwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
			}
			dap.configurations.typescript = dap.configurations.javascript

			-- Mapeos de teclas (igual que antes)
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)
			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			vim.keymap.set("n", "<F1>", dap.continue)
			vim.keymap.set("n", "<F2>", dap.step_into)
			vim.keymap.set("n", "<F3>", dap.step_over)
			vim.keymap.set("n", "<F5>", dap.step_out)
			vim.keymap.set("n", "<F6>", dap.step_back)
			vim.keymap.set("n", "<F12>", dap.restart)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
