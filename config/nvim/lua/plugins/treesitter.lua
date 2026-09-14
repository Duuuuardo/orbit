return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"astro",
				"c",
				"cmake",
				"cpp",
				"c_sharp",
				"css",
				"fish",
				"gitignore",
				"go",
				"graphql",
				"http",
				"java",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"php",
				"python",
				"rust",
				"scss",
				"sql",
				"svelte",
				"typescript",
				"tsx",
				"vim",
				"yaml",
			},

			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		},
		config = function(_, opts)
			local configs = require("nvim-treesitter.configs")
			configs.setup(opts)

			local add = vim.treesitter.language.add or vim.treesitter.language.register
			add("markdown", "mdx")
		end,
	},
}