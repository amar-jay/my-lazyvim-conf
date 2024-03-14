local status, keymap = pcall(require, "common.keymap")
if not status then
  error("Error loading common.keymap")
end

require("ace.utils.prepend").set_global_keys(keymap.keys)
-- error with type completion, so reinitialize the keys, as _keys variable
local _keys = keymap.keys

return {
  "telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
---    "common.keymap"
  },
  keys = {
    {
      _keys.telescope.find_all_files,
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    {
      _keys.telescope.find_files,
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          no_ignore = false,
          hidden = true,
        })
      end,
      desc = "Lists files in your current working directory, respects .gitignore",
    },

    {
      _keys.telescope.buffers,
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers()
      end,
      desc = "Lists open buffers",
    },

    {
      _keys.telescope.resume,
      function()
        local builtin = require("telescope.builtin")
        builtin.resume()
      end,
      desc = "Resume the previous telescope picker",
    },

    {
      _keys.telescope.diagnostics,
      function()
        local builtin = require("telescope.builtin")
        builtin.diagnostics()
      end,
      desc = "Lists Diagnostics for all open buffers or a specific buffer",
    },

    {
      _keys.telescope.file_browser,
      function()
        local telescope = require("telescope")

        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end

        telescope.extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end,
      desc = "Open File Browser with the path of the current buffer",
    },

    {
      _keys.telescope.live_grep,
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          additional_args = { "--hidden" },
        })
      end,
      desc =
      "Search for a string in your current working directory and get results live as you type, respects .gitignore",
    },
    {
      _keys.telescope.treesitter,
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
    {
      _keys.telescope.help_tag,
      function()
        local builtin = require("telescope.builtin")
        builtin.help_tags()
      end,
      desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions = require("telescope").extensions.file_browser.actions

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      --[[
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      --]]
      mappings = {
        n = {
          ["q"] = actions.close
        },
      },
    })
    opts.pickers = {
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    opts.extensions = {
      file_browser = {
        theme = "dropdown",
        -- disables netrw and use telescope-file-browser in its place
        hijack_netrw = true,
        mappings = {
          ["i"] = {
            ["<C-w>"] = function() vim.cmd('normal vbd') end,
          },

          -- your custom insert mode mappings
          ["n"] = {
            -- your custom normal mode mappings
            [_keys.telescope.browser_create] = fb_actions.create,
            [_keys.telescope.browser_gotoparent] = fb_actions.goto_parent_dir,
            [_keys.telescope.browser_shell] = function()
              vim.cmd('startinsert')
            end

            -- your custom normal mode mappings
            --[[
            ["c"] = fb_actions.create,
            ["h"] = fb_actions.goto_parent_dir,
            ["/"] = function()
              vim.cmd("startinsert")
            end,
            ["<C-u>"] = function(prompt_bufnr)
              for _ = 1, 10 do
                actions.move_selection_previous(prompt_bufnr)
              end
            end,
            ["<C-d>"] = function(prompt_bufnr)
              for _ = 1, 10 do
                actions.move_selection_next(prompt_bufnr)
              end
            end,
            ["<PageUp>"] = actions.preview_scrolling_up,
            ["<PageDown>"] = actions.preview_scrolling_down,
            --]]
          },
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
  end,
}
