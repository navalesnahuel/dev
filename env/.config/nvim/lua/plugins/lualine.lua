return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- Para íconos
	event = "VeryLazy",
	config = function()
		require("mini.icons").setup()
		MiniIcons.mock_nvim_web_devicons()

		-- Define un tema personalizado basado en gruvbox-material pero con fondo transparente
		local custom_theme = function()
			local colors = {
				bg = "NONE", -- Fondo transparente
				fg = "#a0a0a0",
				yellow = "#d8a657",
				cyan = "#7daea3",
				green = "#a9b665",
				orange = "#e78a4e",
				violet = "#d3869b",
				magenta = "#c14a4a",
				blue = "#7daea3",
				red = "#ea6962",
			}

			return {
				normal = {
					a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
				insert = {
					a = { fg = colors.blue, bg = colors.bg, gui = "bold" },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
				visual = {
					a = { fg = colors.yellow, bg = colors.bg, gui = "bold" },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
				replace = {
					a = { fg = colors.red, bg = colors.bg, gui = "bold" },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
				command = {
					a = { fg = colors.green, bg = colors.bg, gui = "bold" },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
				inactive = {
					a = { fg = colors.fg, bg = colors.bg },
					b = { fg = colors.fg, bg = colors.bg },
					c = { fg = colors.fg, bg = colors.bg },
				},
			}
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = custom_theme(), -- Usa el tema personalizado con fondo transparente
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				globalstatus = true,
				disabled_filetypes = {
					statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
				},
				always_divide_middle = true,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { { "mode", padding = 0 } },
				lualine_b = {
					{
						"filename",
						path = 0, -- Just the filename
						shorting_target = 40, -- Shortens path to leave 40 spaces in the window
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
							unnamed = "No Name", -- Text to show for unnamed buffers.
							newfile = "New", -- Text to show for newly created file before first write
							padding = { left = 1, right = 1 },
						},
					},
				},

				lualine_x = {
					{ "branch", icon = "", padding = { left = 1, right = 1 } },
					{
						"diff",
						symbols = { added = "+", modified = "~", removed = "-" },
						padding = { left = 1, right = 1 },
					},
				},
				lualine_c = { { "diagnostics", padding = { left = 1, right = 1 } } },
				lualine_y = { { "filetype", padding = 0 } },
				lualine_z = {},
			},
			inactive_sections = {
				lualine_c = { "filename" },
			},
			tabline = {},
			winbar = {},
			extensions = { "lazy" },
		})

		-- Asegúrate de que la barra de estado no tenga fondos ni líneas adicionales
		vim.cmd([[
			hi StatusLine ctermbg=NONE guibg=NONE cterm=NONE gui=NONE
			hi StatusLineNC ctermbg=NONE guibg=NONE cterm=NONE gui=NONE
		]])

		-- Opcional: reducir espacio vertical
		vim.opt.cmdheight = 0
	end,
}
