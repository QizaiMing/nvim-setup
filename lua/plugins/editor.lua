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

  -- Integrated terminal, toggled with Ctrl+` (VS Code default) or Ctrl+;
  -- (this user's remapped VS Code binding, from keybindings.json).
  -- Only normal-mode entries go through lazy's `keys` loader here -- mapping
  -- the same key in both "n" and "t" mode through lazy's replay mechanism
  -- causes a double-fire (opens, then immediately closes again). The
  -- terminal-mode side of these mappings is set plainly in keymaps.lua,
  -- since by the time you're inside a terminal buffer the plugin is
  -- already loaded.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- `cmd` guarantees :ToggleTerm exists and loads the plugin even if a
    -- keybinding below never reaches Neovim (e.g. a terminal emulator that
    -- doesn't pass a given Ctrl combo through as a distinct keypress).
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { [[<C-`>]], "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
      { "<C-;>", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle terminal" },
    },
    opts = {
      size = 15,
      open_mapping = false, -- we set the mapping above so it's discoverable via which-key
      shading_factor = 2,
      direction = "horizontal",
    },
  },
}
