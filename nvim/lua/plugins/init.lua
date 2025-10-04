require('lazy').setup({
	-- テーマ
	require('plugins.ui.theme'),
	
	-- UI系プラグイン
	require('plugins.ui.lualine'),
	require('plugins.ui.bufferline'),
	require('plugins.ui.todo-comments'),
	require('plugins.ui.render-markdown'),
	
	-- エディタ機能
	require('plugins.editor.treesitter'),
	require('plugins.editor.flash'),
	require('plugins.editor.nvim-surround'),
	require('plugins.editor.indent-blankline'),
	require('plugins.editor.autopairs'),
	require('plugins.editor.quicker'),
	
	-- ファイル管理
	require('plugins.file-manager.oil'),
	require('plugins.file-manager.smart-open'),
	require('plugins.file-manager.telescope'),
	
	-- 補完・LSP
	require('plugins.completion.mason'),
	require('plugins.completion.nvim-cmp'),
	require('plugins.completion.copilot'),
	
	-- ターミナル
	require('plugins.terminal.toggleterm'),
	
	-- セッション管理
	require('plugins.session.auto-session'),
})

vim.opt.termguicolors = true

-- smart-open keymap
vim.keymap.set("n", "<leader>ao", function()
	require("telescope").extensions.smart_open.smart_open()
end, { noremap = true, silent = true })

-- oil keymap
vim.keymap.set("n", "<Bslash><Bslash>", function()
	require("oil").toggle_float()
end, { noremap = true, silent = true })

require('ibl').setup()
