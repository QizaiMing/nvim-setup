return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  cmd = "Telescope",
  -- <leader>-prefixed maps are the reliable ones (work in every terminal over
  -- SSH). The Ctrl+Shift combos are added as a bonus for terminals that
  -- distinguish Ctrl+Shift from Ctrl (Windows Terminal, Kitty, WezTerm...).
  keys = {
    { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search in files" },
    { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Search in files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find open buffer" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>fp", "<cmd>Telescope commands<cr>", desc = "Command palette" },
    { "<C-S-p>", "<cmd>Telescope commands<cr>", desc = "Command palette" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
  },
  opts = {
    defaults = {
      prompt_prefix = "  ",
      selection_caret = " ",
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
    },
  },
}
