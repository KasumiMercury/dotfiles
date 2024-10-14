vim.cmd.packadd 'vim-jetpack'
require('jetpack.packer').startup(function(use)
	use{'tani/vim-jetpack'}
	use{'EdenEast/nightfox.nvim',
	config=function()
		vim.cmd('colorscheme nightfox')
	end
	}
	use{'nvim-lua/plenary.nvim'}
	use{'nvim-telescope/telescope.nvim',
	tag='0.1.6',
	requires = {
		{'nvim-lua/plenary.nvim'}
	}
	}
	use{'nvim-telescope/telescope-frecency.nvim',
	config=function()
		require("telescope").load_extension "frecency"
	end
	}
	use{'nvim-lualine/lualine.nvim',
	config=function()
		require("lualine").setup()
	end
	}
	use{'nvim-tree/nvim-tree.lua',
	requires = {
		'nvim-tree/nvim-web-devicons'
	},
	config=function()
		require("nvim-tree").setup()
	end
	}
	use{'petertriho/nvim-scrollbar',
	config=function()
		require("scrollbar").setup()
	end
	}
	use{'kevinhwang91/nvim-hlslens',
	config=function()
		require("hlslens").setup()
		local kopts = {noremap = true, silent = true}
		vim.api.nvim_set_keymap('n', 'n',
			[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts)
		vim.api.nvim_set_keymap('n', 'N',
			[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts)
		vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		vim.api.nvim_set_keymap('n', '<Leader>l', '<Cmd>noh<CR>', kopts)
	end
	}
	use{'nvim-treesitter/nvim-treesitter',
	run = function()
		local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
		ts_update()
	end,
	config=function()
		require("nvim-treesitter.configs").setup{
			ensure_installed = {"c", "lua", "vim", "vimdoc", "query" },
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			}
		}
	end
	}
end)

