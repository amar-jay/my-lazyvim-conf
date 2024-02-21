return {
{
  "nvim-cmp",
  lazy='true',
  dependencies = { "hrsh7th/cmp-emoji", "p00f/clangd_extensions.nvim" },
  opts = function(_, opts)
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
  end
},
}
