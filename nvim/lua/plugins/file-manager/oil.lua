return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		user_default_keymaps = true,
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, bufnr)
				local m = name:match("^%.")
				return m ~= nil
			end,
			is_always_hidden = function(name)
				return false
			end,
		}
	},

	dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
