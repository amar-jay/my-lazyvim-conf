--[[
Lua LSP configuation, and git config to LSP
--]]
local clang_config = {
  keys = {
    { "gs", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
  },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(
      "Makefile",
      --      "CMakeLists.txt",
      "configure.ac",
      "configure.in",
      "config.h.in",
      "meson.build",
      "meson_options.txt",
      "build.ninja"
    )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
      fname
    ) or require("lspconfig.util").find_git_ancestor(fname)
  end,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--compile-commands-dir=./build",
    "--fallback-style=llvm",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}

---@type lspconfig.options
local servers = {
  gopls = {},
  pyright = {},
  ["rust-analyzer"] = {},
  tsserver = {
    root_dir = function(...)
      return require("lspconfig.util").root_pattern(".git")(...)
    end,
    single_file_support = false,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "literal",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },
  clangd = clang_config,
  shfmt = {},
  shellcheck = {},
  codelldb = {},
  lua_check = {
    -- enabled = false,
    single_file_support = true,
    settings = {
      Lua = {
        completion = {
          workspaceWord = true,
          callSnippet = "Both",
        },
        misc = {
          parameters = {
            -- "--log-level=trace",
          },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
        doc = {
          privateName = { "^_" },
        },
        type = {
          castNumberToInteger = true,
        },
        diagnostics = {
          disable = { "incomplete-signature-doc", "trailing-space" },
          -- enable = false,
          groupSeverity = {
            strong = "Warning",
            strict = "Warning",
          },
          groupFileStatus = {
            ["ambiguity"] = "Opened",
            ["await"] = "Opened",
            ["codestyle"] = "None",
            ["duplicate"] = "Opened",
            ["global"] = "Opened",
            ["luadoc"] = "Opened",
            ["redefined"] = "Opened",
            ["strict"] = "Opened",
            ["strong"] = "Opened",
            ["type-check"] = "Opened",
            ["unbalanced"] = "Opened",
            ["unused"] = "Opened",
          },
          unusedLocalExclude = { "_*" },
        },
        format = {
          enable = false,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            continuation_indent_size = "2",
          },
        },
      },
    },
  },
  tailwindcss = {
    root_dir = function(...)
      return require("lspconfig.util").root_pattern(".git")(...)
    end,
  },
}

--[[
        {
        "clangd",
        "clang-format",
--        "cmakelang",
--        "cmakelint",
       "codelldb",
        "css-lsp",
        "stylua",
        "selene",
        "luacheck",
        "shellcheck",
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
--]]
return {
  -- tools
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css-lsp",
        "eslint-lsp",
        "pyright",
        "prettier",
        "clangd",
        "gopls",
        "html-lsp",
        "json-lsp",
        "rust-analyzer",
        "taplo",
        "tailwindcss-language-server",
        "typescript-language-server",
        "lua-language-server",
      })
    end,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    opts = {
      inlay_hints = {
        inline = false,
      },
    }

  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = servers,
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },

  },
}
