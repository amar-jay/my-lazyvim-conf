--[[--
return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    -- Function to read the verilator.f file
    local function read_verilator_flags()
      local flags_file = vim.fn.findfile("verilator.f", vim.fn.expand("%:p:h") .. ";")
      if flags_file ~= "" then
        local file = io.open(flags_file, "r")
        local flags = {}
        for line in file:lines() do
          -- Parse flags (assuming one flag per line)
          table.insert(flags, line)
        end
        file:close()
        return flags
      end
      return {}
    end

    -- Setup null-ls with Verilator
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.verilator.with({
          command = "verilator",  -- Ensure verilator is in PATH
          args = function(params)
            -- Read flags from verilator.f
            local flags = read_verilator_flags()
            -- Add the current file name and any additional flags
            return vim.list_extend({"--lint-only"}, flags, {params.bufname })
          end,
          format = "line",
        }),
      },
    })
  end,
}
----------------
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.verilator.with({
          command = "verilator",  -- Ensure verilator is in PATH
          args = function(params)
            return { "--lint-only", params.bufname }  -- Use the current file name
          end,
          format = "line",
        }),
      },
    })
  end,
--]]

return {
  "jose-elias-alvarez/null-ls.nvim",
}
--[[--
--]]
