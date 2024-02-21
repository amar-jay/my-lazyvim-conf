require("common.set")
local keymaps = require("common.keymap")


require("ace.utils.prepend").set_global_keys(keymaps.keys)


require("common.lazy")


if vim.loader then
  vim.loader.enable()
end

_G._debug = function(...)
  require("ace.utils.debug").dump(...)
end

vim.print = _G._debug

