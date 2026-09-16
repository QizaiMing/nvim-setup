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
  },
}
