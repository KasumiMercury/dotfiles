return {
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'l3mon4d3/luasnip',
			'saadparwaiz1/cmp_luasnip',
			'zbirenbaum/copilot-cmp',
		},
		config = function()
			vim.opt.completeopt = 'menu,menuone,noselect'

			local cmp = require 'cmp'
			local capabilities = require('cmp_nvim_lsp').default_capabilities()

			vim.lsp.config('*', {
				capabilities = capabilities,
			})

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
					{ name = 'copilot' },
				}, {
					{ name = 'buffer' },
				})
			})

			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end
	},
	{
		'hrsh7th/cmp-nvim-lsp'
	},
	{
		'hrsh7th/cmp-buffer'
	},
	{
		'l3mon4d3/luasnip'
	},
	{
		'saadparwaiz1/cmp_luasnip'
	},
}

