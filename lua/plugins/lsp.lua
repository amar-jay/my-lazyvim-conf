--[[
Lua LSP configuation, and git config to LSP
--]]
local verible_config = {
  cmd = { 'verible-verilog-ls', '--rules_config_search' },
  --cmd = { 'verible-verilog-ls' },
  root_dir = require('lspconfig.util').root_pattern('.git', 'verilator.f'),
  -- filetypes = { "verilog", "systemverilog" },
  -- capabilities = capabilities,
  --.find_git_ancestor(fname)
  format_on_save = true,
}
--[[--
veridian.setup {
    cmd = { 'veridian' },
    root_dir = function(fname)
        -- Resolve the absolute path of the file
        local abs_fname = lspconfutil.path.is_absolute(fname) and fname
            or lspconfutil.path.join(vim.loop.cwd(), fname)

        -- Determine the root directory based on known patterns
        return lspconfutil.root_pattern("veridian.yml", ".git")(abs_fname)
            or lspconfutil.path.dirname(abs_fname)
    end,
}
--]]

local veridian_config = {
  cmd = { 'veridian' },
  --capabilities = require("cmp_nvim_lsp").default_capabilities(),
--  filetypes = { "verilog", "systemverilog" },   -- Adjust as necessary
  root_dir = function(fname)
    -- Resolve the absolute path of the file
    local lspconfutil = require("lspconfig.util")
    local is_absolute = fname:sub(1, 1) == "/"
    local abs_fname = is_absolute and fname
        or lspconfutil.path.join(vim.loop.cwd(), fname)

    -- Determine the root directory based on known patterns
    return lspconfutil.root_pattern("veridian.yml", ".git", "verilator.f")(abs_fname)
        or lspconfutil.path.dirname(abs_fname)
  end,
}
local scala_config = {

      keys = {
        {
          "<leader>me",
          function()
            require("telescope").extensions.metals.commands()
          end,
          desc = "Metals commands",
        },
        {
          "<leader>mc",
          function()
            require("metals").compile_cascade()
          end,
          desc = "Metals compile cascade",
        },
        {
          "<leader>mh",
          function()
            require("metals").hover_worksheet()
          end,
          desc = "Metals hover worksheet",
        },
      },
      init_options = {
        statusBarProvider = "off",
      },
      settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      },
    }

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
 veridian = veridian_config,
 verible = verible_config,
  gopls = {},
  pyright = {},
  rust_analyzer = {},
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
  metals = scala_config,
  lua_ls = {
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
        "astro-language-server",
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

      metals = function(_, opts)
        local metals = require("metals")
        local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)
        metals_config.on_attach = LazyVim.has("nvim-dap") and metals.setup_dap or nil

        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "scala", "sbt" },
          callback = function()
            metals.initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group,
        })
        return true
      end,

      },
    },

  },
}
