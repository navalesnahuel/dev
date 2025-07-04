return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup({
				layouts = {
					{
						elements = { "scopes", "breakpoints", "stacks" },
						size = 40,
						position = "left",
					},
					{
						elements = { "console" },
						size = 10,
						position = "bottom",
					},
				},
				controls = {
					enabled = true,
					element = "console",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "↓",
						step_over = "→",
						step_out = "↑",
						run_last = "↻",
						terminate = "■",
					},
				},
			})

			require("nvim-dap-virtual-text").setup({
				enabled = true,
				display_callback = function(variable)
					local name = string.lower(variable.name)
					if name:match("secret") or name:match("password") or name:match("token") then
						return " [HIDDEN]"
					end
					if #variable.value > 30 then
						return " " .. string.sub(variable.value, 1, 30) .. "..."
					end
					return " " .. variable.value
				end,
			})

			require("mason").setup()
			require("mason-nvim-dap").setup({
				automatic_setup = true,
				ensure_installed = { "delve", "debugpy" },
			})

			require("dap-go").setup()

			local function find_python()
				local paths = {
					vim.fn.getcwd() .. "/.venv/bin/python",
					vim.fn.expand("~/.venv/bin/python"),
					"/usr/bin/python3",
				}

				for _, path in ipairs(paths) do
					if vim.fn.executable(path) == 1 then
						return path
					end
				end
				return "python3"
			end

			require("dap-python").setup(find_python())

			-- KEYBINDS estilo VSCode
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start / Continue Debug" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<F6>", function()
				dap.terminate()
				dapui.close()
			end, { desc = "Stop Debug" })

			vim.keymap.set("n", "<F4>", dapui.toggle, { desc = "Toggle DAP UI" })
			vim.keymap.set("n", "<leader>?", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "Inspect Variable" })

			vim.keymap.set("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug Go Test" })

			vim.keymap.set("n", "<leader>dp", function()
				require("dap-python").test_method()
			end, { desc = "Debug Python Test" })

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				print("Debug started.")
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
				print("Debug terminated.")
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
				print("Debug exited.")
			end

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "x", texthl = "DiagnosticSignHint" })

			vim.api.nvim_create_user_command("DebugHelp", function()
				local help = {
					"DEBUG CHEAT SHEET",
					"",
					"F2     Toggle breakpoint",
					"F5     Start / Continue",
					"F6     Stop",
					"F9     Toggle breakpoint",
					"F10    Step over",
					"F11    Step into",
					"F12    Step out",
					"<F4>   Toggle DAP UI",
					"<leader>?  Inspect variable",
					"<leader>dt Debug Go test",
					"<leader>dp Debug Python test",
				}

				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, help)

				local width = 50
				local height = #help
				local opts = {
					relative = "editor",
					width = width,
					height = height,
					col = (vim.o.columns - width) / 2,
					row = (vim.o.lines - height) / 2,
					anchor = "NW",
					style = "minimal",
					border = "rounded",
					title = " Debug Help ",
					title_pos = "center",
				}

				vim.api.nvim_open_win(buf, true, opts)
				vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf })
			end, { desc = "Show debug help" })

			local help_shown = false
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "go", "python" },
				callback = function()
					if not help_shown then
						help_shown = true
						vim.defer_fn(function()
							print("Run :DebugHelp to see all debug keys.")
						end, 1000)
					end
				end,
			})

			print("DAP setup ready. Press F5 to start debugging.")
		end,
	},
}
