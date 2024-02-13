local keymap = vim.keymap
local M = {}

local opts = { noremap = true, silent = true }
local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, _opts)
    _opts = vim.tbl_extend("force",
      outer_opts,
      _opts or {}
    )
    keymap.set(op, lhs, rhs, _opts)
  end
end


M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

-- Other keymaps
keymap.set('n', '<leader>vim', ':tabedit ~/.config/nvim<Return>')
keymap.set('n', '<leader>nvim', ':tabedit ~/.config/nvim<Return>')
keymap.set('n', '<leader>tmux', ':tabedit ~/.config/tmux/<Return>')

-- Keymaps for tabs
keymap.set('n', 'te', ':tabedit ')
keymap.set('n', 'te<Return>', ':tabnew<Return> ')
keymap.set('n', '<S-Tab>', ':tabprev<Return>')
keymap.set('n', '<Tab>', ':tabnext<Return>')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>p", '"0p')
keymap.set("n", "<Leader>P", '"0P')
keymap.set("v", "<Leader>p", '"0p')
keymap.set("n", "<Leader>c", '"_c')
keymap.set("n", "<Leader>C", '"_C')
keymap.set("v", "<Leader>c", '"_c')
keymap.set("v", "<Leader>C", '"_C')
keymap.set("n", "<Leader>d", '"_d')
keymap.set("n", "<Leader>D", '"_D')
keymap.set("v", "<Leader>d", '"_d')
keymap.set("v", "<Leader>D", '"_D')

-- Keymaps for split
keymap.set('n', '<leader>|', ':vsplit<Return>')
keymap.set('n', '<leader>_', ':split<Return>')
--[[
keymap.set('n', '<leader><Space>', '<C-W>w')
keymap.set('n', '<leader><up>', '<C-w>k')
keymap.set('n', '<leader><down>', '<C-w>j')
keymap.set('n', '<leader><left>', '<C-w>h')
keymap.set('n', '<leader><right>', '<C-w>l')
]]

-- resize window
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')

-- Keymaps for Git
keymap.set("n", "<leader>gs", vim.cmd.Git);


-- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- replace hex with HSL
keymap.set("n", "<leader>r", function()
	-- Get the current line number
	local line_number = vim.api.nvim_win_get_cursor(0)[1]

	-- Get the line content
	local line_content = vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, false)[1]

	-- Find hex code patterns and replace them
	for hex in line_content:gmatch("#[0-9a-fA-F]+") do
		local hsl = require("lua.common.hsl-hex").hexToHSL(hex)
		line_content = line_content:gsub(hex, hsl)
	end

	-- Set the line content back
	vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, false, { line_content })
end)


-- Toggle Hints
keymap.set("n", "<leader>i", function()
  	vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled())
--	require("craftzdog.lsp").toggleInlayHints()
end)



-- keymaps for treesitter context
M.ts_context = function(_setup)
  M.nnoremap("<leader>cf", function() _setup(true) end)
  M.nnoremap("<leader>cp", function() _setup(false) end)
end

M.telescope = {
  buffers = "<leader>v",
  diagnostics = "<leader>h",
  file_browser = "<leader>B", -- has previewer
  file_browser_less = "<leader>b", -- no previewer
  find_files = "<leader>ff", -- more or less similar to browse_files
  fuzzy_find = "<leader>/", -- what is the dffce b/n find_files and fuzzy_find?
  grep_string = "<leader>gs",
  help_tags = "<leader>gt",
  old_files = "<leader>?",
  resume = "<leader>r",
  live_grep = "<leader>rg",
}

-- keymaps for lsp
--M.ts_context = M.ts_context

return M
