return {
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		config = function()
			require('copilot').setup({
				suggestion = {
					enabled = false,
				},
				panel = {
					enabled = false,
				},
				copilot_node_command = 'node',
			})
		end
	},
	{
		'zbirenbaum/copilot-cmp',
		after = { "copilot.lua" },
		config = function()
			require('copilot_cmp').setup()
		end
	},
}