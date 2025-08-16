-- LSP設定

-- LSPアタッチ時のキーマッピング
vim.api.nvim_create_autocmd('lspattach', {
	callback = function(ctx)
		local set = vim.keymap.set
		set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { buffer = true })
		set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { buffer = true })
		set('n', 'td', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { buffer = true })
		set('n', 'gt', '<C-t>')
		set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { buffer = true })
		set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { buffer = true })
		set('n', '<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { buffer = true })
		set('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', { buffer = true })
		set('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', { buffer = true })
		set('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
			{ buffer = true })
		set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', { buffer = true })
		set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', { buffer = true })
		set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { buffer = true })
		set('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', { buffer = true })
		set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', { buffer = true })
		set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', { buffer = true })
		set('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', { buffer = true })
		set('n', '<Space>fo', '<cmd>lua vim.lsp.buf.format()<cr>', { buffer = true })
	end,
})

-- require('mason-lspconfig').setup_handlers {
-- 	function(server_name)
-- 		require('lspconfig')[server_name].setup {}
-- 	end
-- }
-- require("mason-lspconfig").setup_handlers({
-- 	function(server_name)
-- 		vim.lsp.enable({server_name})
-- 	end
-- })
