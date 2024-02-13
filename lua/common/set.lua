-- basic vim configs --

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.nu = true
vim.opt.relativenumber = true -- show line number relative to cursor
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.errorbells = false
vim.opt.showcmd = true
vim.opt.backup = false -- No backup of files
vim.opt.cmdheight = 1  -- Give more space for displaying messages.
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.shell = "zsh"
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.wrap = false -- no wrap text
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.swapfile = false
vim.opt.path:append { '**' } -- In finding files, search into subfolders
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
--vim.opt.transparent = 0.7 -- NOT WORKING

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true -- case insensitive unless /C
vim.opt.smartcase = true

--vim.opt.isfname:append("@-@")

vim.opt.wildignore:append({ "*/node_modules/*" })
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 250

--vim.opt.colorcolumn = "800"
vim.g.mapleader = " " -- Set Leader


-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

--[[
  APIS
]]

vim.cmd([[au BufNewFile,BufRead *.astro setf astro]])
vim.cmd([[au BufNewFile,BufRead Podfile setf ruby]])

-- https://github.com/craftzdog/dotfiles-public/blob/master/.config/nvim/lua/plugins/lsp.lua
if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.cmdheight = 0
end

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

-- Disable the concealing in some file formats
-- The default conceallevel is 3 in LazyVim
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc", "markdown" },
  callback = function()
    vim.opt.conceallevel = 0
  end,
})


vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})
