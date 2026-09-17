return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", gs.next_hunk, "Next git hunk")
        map("n", "[c", gs.prev_hunk, "Previous git hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
      end,
    },
  },

  -- Full Source Control panel, VS Code style: unstaged/staged/untracked
  -- file lists, per-file or per-hunk staging, inline diffs, commit -- all
  -- without needing any external tool beyond git itself.
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- nicer side-by-side diffs inside neogit
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git status (Source Control panel)" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Neogit push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Neogit pull<cr>", desc = "Git pull" },
    },
    opts = {},
  },
}
