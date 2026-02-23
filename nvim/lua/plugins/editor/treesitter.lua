return {
	{
	    'nvim-treesitter/nvim-treesitter',
	    lazy = false,
	    build = ':TSUpdate',
	    config = function()
		local ts = require('nvim-treesitter')

		ts.install({
		    "c", "lua", "vim", "vimdoc", "query",
		    "markdown", "markdown_inline",
		    "go", "gomod", "gotmpl", "gowork", "rust",
		})
		vim.api.nvim_create_autocmd('FileType', {
		    callback = function(event)
			local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(event.buf))
			if ok and stats and stats.size > 100 * 1024 then return end
			pcall(vim.treesitter.start, event.buf)
		    end,
		})
	    end,
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
}
