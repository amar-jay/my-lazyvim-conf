vim.treesitter.language.register("systemverilog", { "verilog", "systemverilog" })

-- Keep the language choices; let LazyVim configure the current Treesitter API.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro", "cmake", "cpp", "css", "cuda", "fish", "gitignore",
        "go", "graphql", "http", "lua", "rust", "scss", "sql",
        "svelte", "scala", "systemverilog",
      },
    },
  },
}
