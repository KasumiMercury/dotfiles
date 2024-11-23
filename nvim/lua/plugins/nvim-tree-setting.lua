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

-- pass to setup along with your other options
require('nvim-tree').setup {
	on_attach = my_on_attach,
}

vim.api.nvim_create_user_command('ex', function() vim.cmd.nvimtreetoggle() end, {})
vim.keymap.set('n', '<leader>e', ':nvimtreefocus<cr>')
