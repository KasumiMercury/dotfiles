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
		set('n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', { buffer = true })
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

require 'nvim-treesitter.configs'.setup {

	-- A list of parser names, or "all" (the listed parsers MUST always be installed)

	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go", "gomod", "gotmpl", "gowork", "rust" },

	-- Install parsers synchronously (only applied to `ensure_installed`)

	sync_install = false,

	-- Automatically install missing parsers when entering buffer

	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally

	auto_install = true,

	-- List of parsers to ignore installing (or "all")

	ignore_install = { "javascript" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)

	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {

		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to

		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is

		-- the name of the parser)

		-- list of language that will be disabled

		disable = { "c", "rust" },

		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files

		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB

			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))

			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.

		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).

		-- Using this option may slow down your editor, and you may see some duplicate highlights.

		-- Instead of true it can also be a list of languages

		additional_vim_regex_highlighting = false,

	},

}

vim.cmd('colorscheme nightfox')
