return {
	'MeanderingProgrammer/render-markdown.nvim',
	opts = {
		completions = { lsp = { enabled = true } },
	},
	dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
	ft = {"markdown"},
}
