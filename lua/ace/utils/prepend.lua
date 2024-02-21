local M = {}
--#region prependKeys (from lua/ace/utils/prepend.lua)
---@param table table<string, string>
---@param prefix string
---@return table<string, string>
local function prependKeys(table, prefix)
  ---@type table<string, string>
  local result = {}
  for k, v in pairs(table) do
    result[prefix .. k] = v
  end
  return result
end



--- check for duplicate keymaps, then set global keys
---@param keymap table<string, table<string,string>>
function M.set_global_keys(keymap)
  assert(type(keymap) == "table", "Parameter must be a table")

  -- Iterate over each key and value pair in the input table
  for key1, subtable1 in pairs(keymap) do
    -- Check if the value associated with the key is a table
    --       assert(type(subtable1) == "table", "subtable isn't a table")
    if type(subtable1) == "table" then
      -- Iterate over each key and value pair in the subtable
      for key2, subtable2 in pairs(keymap) do
        -- Check if the value associated with the key is a table
        if type(subtable2) == "table" then
          -- Only compare subtables if they are different
          if key1 ~= key2 then
            -- Iterate over each key and value pair in the first subtable
            for subkey1, value1 in pairs(subtable1) do
              -- Iterate over each key and value pair in the second subtable
              for subkey2, value2 in pairs(subtable2) do
                -- Check if the values are equal
                if value1 == value2 then
                  -- Throw an error with information about the duplicate values
                  print(string.format("%s.%s.%s and %s.%s.%s have equal values of \"%s\"",
                    "keymap", key1, subkey1, "keymap", key2, subkey2, tostring(value1)))
                end
              end
            end
          end
        end
      end
    end
  end

  --- setting global keys
  --  _G.keys = keymap.keys
end

M.prependKeys = prependKeys

return M
