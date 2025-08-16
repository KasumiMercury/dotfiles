return {
	{
		'mason-org/mason.nvim',
		build = ':MasonUpdate',
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		}
	},
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = {
			'mason-org/mason.nvim',
			'neovim/nvim-lspconfig',
		},
		opts = {
			automatic_installation = true,
		},
		config = function(_, opts)
			require('mason-lspconfig').setup(opts)
		end
	},
	{
		'neovim/nvim-lspconfig'
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require 'lsp_signature'.setup(opts)
		end
	},
}

