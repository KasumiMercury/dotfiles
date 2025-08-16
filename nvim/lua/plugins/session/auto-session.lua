return {
	'rmagatti/auto-session',
	lazy = false,
	dependencies = {
		'nvim-telescope/telescope.nvim',
	},
	config = function()
		require('auto-session').setup({
			post_cwd_changed_cmds = {
				function()
					require('lualine').refresh()
				end
			}
		})
	end
}