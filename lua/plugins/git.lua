--[[
local ok, neogit = pcall(require, "neogit")
if not ok then
  return
end

local nmap = require("tj.keymap").nmap

neogit.setup {
  integrations = {
    diffview = true,
  },
}

nmap { "<space>vv", ":DiffviewOpen " }

nmap { "<leader>gs", neogit.open }
nmap {
  "<leader>gc",
  function()
    neogit.open { "commit" }
  end,
}
--]]
--
return {
  "dinhhuy258/git.nvim",
  event = "BufReadPre",
  opts = {
    keymaps = {
      -- Open blame window
      blame = "<Leader>gb",
      -- Open file/folder in git repository
      browse = "<Leader>go",
    },
  },
}
