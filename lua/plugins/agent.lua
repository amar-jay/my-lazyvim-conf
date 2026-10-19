return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false },
      cli = { mux = { enabled = true, backend = "tmux" } },
    },
    keys = {
      { "<leader>aa", function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
        mode = { "n", "x" }, desc = "Toggle Codex (Sidekick)" },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}", filter = { name = "codex" } }) end,
        desc = "Send file to Codex" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}", filter = { name = "codex" } }) end,
        mode = "x", desc = "Send selection to Codex" },
      { "<leader>ae", function() require("sidekick.cli").send({ msg = "Explain and fix {diagnostics}", filter = { name = "codex" } }) end,
        desc = "Send diagnostics to Codex" },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    opts = {},
    keys = {
      { "<leader>ar", "<cmd>DiffviewOpen<cr>", desc = "Review agent changes" },
      { "<leader>aR", "<cmd>DiffviewClose<cr>", desc = "Close change review" },
      { "<leader>ah", "<cmd>DiffviewFileHistory %<cr>", desc = "Current file history" },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    optional = true,
    keys = {
      { "<leader>aa", false, mode = { "n", "x" } },
      { "<leader>ac", function() require("CopilotChat").toggle() end,
        mode = { "n", "x" }, desc = "Toggle Copilot Chat" },
    },
  },
}
