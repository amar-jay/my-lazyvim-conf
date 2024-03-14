local M = {}

M.keys = {}
-- These are custom telescope keymaps
M.keys.telescope = {
  buffers = "<leader>v",
  diagnostics = "<leader>d",
  file_browser = "<leader>b",      -- has previewer
  file_browser_less = "<leader>B", -- no previewer
  find_files = "<leader>ff",       -- this finds plugin files using find_files
  find_all_files = "<leader>ff",       -- this finds plugin files using find_files
  fuzzy_find = "///",              -- what is the dffce b/n find_files and fuzzy_find?
  old_files = "<leader>?",
  resume = "<leader>r",
  live_grep = "<leader>gl",
  browser_create = "n",
  browser_delete = "d",
  browser_rename = "r",
  browser_copy = "c",
  browser_gotoparent = "~",
  browser_shell = "/",
  treesitter = "<leader>t<Return>",
  help_tag = "<leader>h"

  -- help_tag
}

-- These are custom vim  (window, and vim plugin) keymaps
-- using _vim instead of `vim` since `vim` key is somehow causing some trouble
M.keys._vim = {
  vim_config = "<leader>Vim",
  tmux_config = "<leader>Tmux",
  tabedit = "te",
  tabnew = "te<Return>",
  tabprev = "<S-Tab>",
  tabnext = "<Tab>",
  selectall = "<C-a>",
  deleteword = "dw",
  vsplit = "<leader>|",
  hsplit = "<leader>_",
  resize_up = "<C-w><up>",
  resize_down = "<C-w><down>",
  resize_left = "<C-w><left>",
  resize_right = "<C-w><right>",
  git = "<C-G>",
  diagnostics = "<C-d>",
  hex_to_hsl = "<C-R>",
  togglehints = "<C-i>",
}

-- Basic Treesitter keys
M.keys.treesitter = {
  on = "<leader>t<up>",
  off = "<leader>t<down>",
}


local opts = { noremap = true, silent = true }
---@param op any
---@param outer_opts table?
---@return function
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, _opts)
    ---@type vim.opt.dictionary
    _opts = vim.tbl_extend("force",
      outer_opts,
      _opts or {}
    )
    vim.keymap.set(op, lhs, rhs, _opts)
  end
end


M.nmap = bind("n", opts)
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

-- Other keymaps
M.nnoremap(M.keys._vim.vim_config, ':tabedit ~/.config/nvim/<Return>')
M.nnoremap(M.keys._vim.tmux_config, ':tabedit ~/.config/tmux/<Return>')

-- Keymaps for tabs
M.nnoremap(M.keys._vim.tabedit, ':tabedit ')
M.nnoremap(M.keys._vim.tabnew, ':tabnew<Return> ')
M.nnoremap(M.keys._vim.tabprev, ':tabprev<Return>')
M.nnoremap(M.keys._vim.tabnext, ':tabnext<Return>')

-- Select all
M.nnoremap(M.keys._vim.selectall, "gg<S-v>G")

-- Delete a word backwards
M.nnoremap(M.keys._vim.deleteword, 'vb"_d')
--[[
-- Do things without affecting the registers
M.nnoremap("x", '"_x')
M.nnoremap("<Leader>p", '"0p')
M.nnoremap("<Leader>P", '"0P')
vim.keymap.set("v", "<Leader>p", '"0p')
M.nnoremap("<Leader>c", '"_c')
M.nnoremap("<Leader>C", '"_C')
vim.keymap.set("v", "<Leader>c", '"_c')
vim.keymap.set("v", "<Leader>C", '"_C')
M.nnoremap("<Leader>d", '"_d')
M.nnoremap("<Leader>D", '"_D')
vim.keymap.set("v", "<Leader>d", '"_d')
vim.keymap.set("v", "<Leader>D", '"_D')
--]]

-- Keymaps for split
M.nnoremap(M.keys._vim.vsplit, ':vsplit<Return>')
M.nnoremap(M.keys._vim.hsplit, ':split<Return>')
--[[
M.nnoremap('<leader><Space>', '<C-W>w')
M.nnoremap('<leader><up>', '<C-w>k')
M.nnoremap('<leader><down>', '<C-w>j')
M.nnoremap('<leader><left>', '<C-w>h')
M.nnoremap('<leader><right>', '<C-w>l')
]]

-- resize window
M.nnoremap(M.keys._vim.resize_up, '<C-w>+')
M.nnoremap(M.keys._vim.resize_down, '<C-w>-')
M.nnoremap(M.keys._vim.resize_left, '<C-w><')
M.nnoremap(M.keys._vim.resize_right, '<C-w>>')

-- Keymaps for Git
M.nnoremap(M.keys._vim.git, vim.cmd.Git);


-- Diagnostics
M.nnoremap(M.keys._vim.diagnostics, function()
  vim.diagnostic.goto_next()
end, opts)

-- replace hex with HSL
M.nnoremap(M.keys._vim.hex_to_hsl, function()
  -- Get the current line number
  local line_number = vim.api.nvim_win_get_cursor(0)[1]

  -- Get the line content
  local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

  -- Find hex code patterns and replace them
  for hex in line_content:gmatch("#[0-9a-fA-F]+") do
    ---@type number
    local hsl = require("lua.common.hsl-hex").hexToHSL(hex)
    line_content = line_content:gsub(hex, hsl)
  end

  -- Set the line content back
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end)


-- Toggle Hints
M.nnoremap(M.keys._vim.togglehints, function()
  vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
  --	require("craftzdog.lsp").toggleInlayHints()
end)



-- keymaps for treesitter context
---@param _setup function
local function ts_context(_setup)
  M.nnoremap(M.keys.treesitter.on, function() _setup(true) end)
  M.nnoremap(M.keys.treesitter.off, function() _setup(false) end)
end


-- keymaps for lsp
M.ts_context = ts_context

return M
