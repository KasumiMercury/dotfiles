return {
	-- {
	-- 	'github/copilot.vim',
	-- 	lazy = false,
	-- },
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					gitcommit = true,
					['*'] = function()
						local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
						local disable_patterns = { 'env', 'conf', 'local', 'private' }
						return vim.iter(disable_patterns):all(function(pattern)
							return not string.match(fname, pattern)
						end)
					end,
				},
			})
		end,
	},
	{
		'zbirenbaum/copilot-cmp',
		after = { "copilot.lua" },
		config = function()
			require('copilot_cmp').setup()
		end
	},
}

