require('lazy').setup({
	{ 'edeneast/nightfox.nvim',           lazy = false },
	{ 'lambdalisue/fern.vim' },
	{ 'nvim-treesitter/nvim-treesitter',  build = ':TSUpdate' },

	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },

	{ 'l3mon4d3/luasnip' },
	{ 'saadparwaiz1/cmp_luasnip' },

	{
		'nvim-tree/nvim-tree.lua',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
	},

	require('plugins.lualine'),
	require('plugins.nvim-surround'),
	require('plugins.indent-blankline'),

	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{
		'joosepalviste/nvim-ts-context-commentstring',
	},
	{
		'numtostr/comment.nvim',
		config = function()

		require('Comment').setup {
			pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
		}
	end,
	},
	{
	  'stevearc/oil.nvim',
	  ---@module 'oil'
	  ---@type oil.setupopts
	  opts = {},
	  -- optional dependencies
	  dependencies = { { "echasnovski/mini.icons", opts = {} } },
	  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	}
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwplugin = 1
vim.opt.termguicolors = true

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

-- vim.api.nvim_create_user_command('ex', function() vim.cmd.nvimtreetoggle() end, {})
vim.keymap.set('n', '<leader>e', ':nvimtreefocus<cr>')

capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('lspattach', {
	callback = function(ctx)
		local set = vim.keymap.set
		set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', { buffer = true })
		set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = true })
		set('n', 'k', '<cmd>lua vim.lsp.buf.hover()<cr>', { buffer = true })
		set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = true })
		set('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { buffer = true })
		set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', { buffer = true })
		set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', { buffer = true })
		set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
			{ buffer = true })
		set('n', '<space>d', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { buffer = true })
		set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { buffer = true })
		set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = true })
		set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { buffer = true })
		set('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', { buffer = true })
		set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', { buffer = true })
		set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', { buffer = true })
		set('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', { buffer = true })
		set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<cr>', { buffer = true })
	end,
})

require('mason').setup()
require('mason-lspconfig').setup()
-- require('mason-lspconfig').setup_handlers {
-- 	function(server_name)
-- 		require('lspconfig')[server_name].setup {}
-- 	end
-- }

vim.opt.completeopt = 'menu,menuone,noselect'

local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<c-p>'] = cmp.mapping.select_prev_item(),
		['<c-n>'] = cmp.mapping.select_next_item(),
		['<c-d>'] = cmp.mapping.scroll_docs(-4),
		['<c-f>'] = cmp.mapping.scroll_docs(4),
		['<c-space>'] = cmp.mapping.complete(),
		['<c-e>'] = cmp.mapping.close(),
		['<cr>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	})
})

require('ibl').setup()

vim.cmd('colorscheme nightfox')


