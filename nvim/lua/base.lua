vim.scriptencodeing = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.wo.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = "\\ "

-- for auto-session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local keymap = vim.keymap

keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
keymap.set('n', 'sh', '<C-w>h')
keymap.set('n', 'sk', '<C-w>k')
keymap.set('n', 'sj', '<C-w>j')
keymap.set('n', 'sl', '<C-w>l')

keymap.set('i', 'jk', '<Esc>')
keymap.set('n', '<F1>', ':edit $MYVIMRC<CR>')

local digraphs = vim.cmd.digraphs

-- カッコ
digraphs("j(", 65288) -- （
digraphs("j)", 65289) -- ）
digraphs("j[", 12300) -- 「
digraphs("j]", 12301) -- 」
digraphs("j{", 12302) -- 『
digraphs("j}", 12303) -- 』
digraphs("j<", 12304) -- 【
digraphs("j>", 12305) -- 】

-- 句読点
digraphs("j,", 65292) -- ，
digraphs("j.", 65294) -- ．
digraphs("j!", 65281) -- ！
digraphs("j?", 65311) -- ？
digraphs("j:", 65306) -- ：

-- 数字
digraphs("j0", 65296) -- ０
digraphs("j1", 65297) -- １
digraphs("j2", 65298) -- ２
digraphs("j3", 65299) -- ３
digraphs("j4", 65300) -- ４
digraphs("j5", 65301) -- ５
digraphs("j6", 65302) -- ６
digraphs("j7", 65303) -- ７
digraphs("j8", 65304) -- ８
digraphs("j9", 65305) -- ９

-- その他の記号
digraphs("j~", 12316) -- 〜
digraphs("j/", 12539) -- ・
digraphs("js", 12288) -- 　
