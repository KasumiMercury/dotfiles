local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--for fzf
if vim.fn.has('win64') == 1 then
	local home = os.getenv("USERPROFILE")
	vim.g.sqlite_clib_path = home .. "/sqlite3/sqlite3.dll"
end

require 'base'
require 'plugin'

