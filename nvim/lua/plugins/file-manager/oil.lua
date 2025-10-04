return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		user_default_keymaps = true,
	},

	dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
