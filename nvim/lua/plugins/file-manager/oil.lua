return {
	'stevearc/oil.nvim',
	---@module 'oil'
	---@type oil.setupopts
	opts = {},

	cmd = 'Oil',
	keys = {
		{
			'<Bslash><Bslash>',
			function()
				require('oil').toggle_float()
			end,
			desc = 'Oil',
		},
	},

	-- optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
