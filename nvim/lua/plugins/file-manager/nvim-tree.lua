local function my_on_attach(bufnr)
	local api = require 'nvim-tree.api'

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	-- vim.keymap.set('n', '<c-t>', api.tree.change_root_to_parent,        opts('up'))
	-- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('help'))
end

return {
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		-- pass to setup along with your other options
		require('nvim-tree').setup {
			on_attach = my_on_attach,
		}

		-- コマンドとキーマッピング
		vim.api.nvim_create_user_command('Ex', function() vim.cmd.NvimTreeToggle() end, {})
		vim.keymap.set('n', '<leader>e', ':NvimTreeFocus<cr>')
	end
}