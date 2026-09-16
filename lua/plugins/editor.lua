return {
  -- Ctrl+/ to toggle comments, like VS Code.
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<C-_>", mode = { "n" }, function() require("Comment.api").toggle.linewise.current() end, desc = "Toggle comment" },
      { "<C-_>", mode = { "v" }, "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", desc = "Toggle comment" },
    },
    opts = {},
  },

  -- Auto-close brackets/quotes, like VS Code's default editor behavior.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Popup showing available keybindings, like VS Code's command hints.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Integrated terminal, toggled with Ctrl+`, like VS Code.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { [[<C-`>]], "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
      { [[<C-`>]], "<cmd>ToggleTerm direction=horizontal<cr>", mode = "t", desc = "Toggle terminal" },
    },
    opts = {
      size = 15,
      open_mapping = false, -- we set the mapping above so it's discoverable via which-key
      shading_factor = 2,
      direction = "horizontal",
    },
  },
}
