return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {},
		},
		config = function(_, opts)
			opts.ensure_installed = {}
			require("mason").setup(opts)
		end,
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },

			servers = {
				cssls = {
					mason = false,
				},
				tailwindcss = {
					mason = false,
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				ts_ls = {
					mason = false,
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {
					mason = false,
				},
				yamlls = {
					mason = false,
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					mason = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
				clangd = {
					mason = false,
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion=iwyu",
					},
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("compile_commands.json", "CMakeLists.txt", ".git")(fname)
							or require("lspconfig.util").find_git_ancestor(fname)
					end,
				},
				nixd = {
					mason = false,
					settings = {
						nixd = {
							formatting = {
								command = { "alejandra" },
							},
							nixpkgs = {
								expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}",
							},
						},
					},
				},
				omnisharp = {
					mason = false,
					enable_editorconfig_support = true,
					enable_roslyn_analyzers = false,
					enable_import_completion = true,
					analyze_open_documents_only = false,
				},
				phpactor = {
					mason = false,
					root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
				},
			},
			setup = {},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				["*"] = {
					keys = {
						{
							"gd",
							function()
								require("telescope.builtin").lsp_definitions({ reuse_win = false })
							end,
							desc = "Goto Definition",
							has = "definition",
						},
					},
				},
			},
		},
	},
}