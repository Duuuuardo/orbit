return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			style = "night",
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "transparent",
				floats = "transparent",
			},
			on_highlights = function(hl, c)
				hl.Normal = { bg = "none" }
				hl.NormalFloat = { bg = "none" }
				hl.NormalNC = { bg = "none" }
				hl.SignColumn = { bg = "none" }
				hl.FoldColumn = { bg = "none" }
				hl.LineNr = { bg = "none" }
				hl.CursorLineNr = { bg = "none" }
			end,
		},
	},
}