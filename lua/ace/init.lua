require("common.keymap")
require("common.set")
require("common.lazy")

if vim.loader then
	vim.loader.enable()
end

_G._debug = function(...)
	require("utils.debug").dump(...)
end

vim.print = _G._debug
