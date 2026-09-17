-- Captured once at startup (this file is evaluated when lazy.nvim reads
-- plugin specs, before any navigation happens) -- NOT re-read live via
-- vim.fn.getcwd() inside the reset keymap below, because nvim-tree's own
-- root-changing actions (like `-`) also silently change Neovim's actual
-- working directory to match, so getcwd() drifts right along with the tree
-- and can't be used to find your way back.
local project_root = vim.fn.getcwd()

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle explorer" },
    { "<leader>e", "<cmd>NvimTreeFocus<cr>", desc = "Focus explorer" },
  },
  opts = {
    view = {
      width = 32,
      side = "right",
    },
    renderer = {
      group_empty = true,
      icons = {
        show = { git = true, folder = true, file = true, folder_arrow = true },
      },
    },
    filters = { dotfiles = false },
    git = { enable = true },
    actions = {
      open_file = { quit_on_open = false },
    },
    on_attach = function(bufnr)
      -- Keep every nvim-tree default keymap (a, d, r, x, c, p, H, -, ...)...
      require("nvim-tree.api").map.on_attach.default(bufnr)

      -- ...and add one nvim-tree doesn't ship: reset the tree root back to
      -- the project root. `-` (change_root_to_parent, nvim-tree's own "go up
      -- a folder" key) has no built-in undo -- closing/reopening the tree
      -- does NOT revert it either, it stays changed.
      vim.keymap.set("n", "gr", function()
        require("nvim-tree.core").get_explorer():change_dir(project_root)
      end, {
        desc = "nvim-tree: Reset root to project root",
        buffer = bufnr,
        noremap = true,
        silent = true,
        nowait = true,
      })
    end,
  },
}
