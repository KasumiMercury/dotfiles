require('lazy').setup({
	{ 'EdenEast/nightfox.nvim',           lazy = false },
	{ 'lambdalisue/fern.vim' },
	{ 'nvim-treesitter/nvim-treesitter',  build = ':TSUpdate' },

	{ 'neovim/nvim-lspconfig' },
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },

	{ 'hrsh7th/nvim-cmp' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/cmp-buffer' },

	{ 'L3MON4D3/LuaSnip' },
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
	}
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
	local api = require 'nvim-tree.api'

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	-- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
	-- vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

-- pass to setup along with your other options
require('nvim-tree').setup {
	on_attach = my_on_attach,
}

vim.api.nvim_create_user_command('Ex', function() vim.cmd.NvimTreeToggle() end, {})
vim.keymap.set('n', '<Leader>e', ':NvimTreeFocus<CR>')

capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ctx)
		local set = vim.keymap.set
		set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { buffer = true })
		set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = true })
		set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = true })
		set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { buffer = true })
		set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { buffer = true })
		set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { buffer = true })
		set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { buffer = true })
		set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
			{ buffer = true })
		set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { buffer = true })
		set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { buffer = true })
		set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = true })
		set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { buffer = true })
		set('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { buffer = true })
		set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { buffer = true })
		set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { buffer = true })
		set('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', { buffer = true })
		set('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', { buffer = true })
	end,
})

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-lspconfig').setup_handlers {
	function(server_name)
		require('lspconfig')[server_name].setup {}
	end
}

vim.opt.completeopt = 'menu,menuone,noselect'

local cmp = require 'cmp'
cmp.setup({
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
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
