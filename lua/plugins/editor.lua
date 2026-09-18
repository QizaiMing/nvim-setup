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

  -- Integrated terminal, toggled with F12 (primary -- Ctrl+` and Ctrl+; are
  -- "Ctrl + punctuation" combos that a lot of terminal emulators, including
  -- this user's Windows Terminal setup, can't encode as a distinct keypress
  -- at all, so both are kept only as a bonus for terminals that do support
  -- them). Only normal-mode entries go through lazy's `keys` loader here --
  -- mapping the same key in both "n" and "t" mode through lazy's replay
  -- mechanism causes a double-fire (opens, then immediately closes again).
  -- The terminal-mode side of these mappings is set plainly in
  -- keymaps.lua, since by the time you're inside a terminal buffer the
  -- plugin is already loaded.
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- `cmd` guarantees :ToggleTerm exists and loads the plugin even if a
    -- keybinding below never reaches Neovim.
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<F12>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { [[<C-`>]], "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<C-;>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      -- Back to the original small strip along the bottom. For a full
      -- height+width terminal, use F11 (lua/config/keymaps.lua) to maximize
      -- whichever window is focused -- works on this terminal OR a file,
      -- and toggles back to the normal layout on a second press. Keeping
      -- this default small/horizontal rather than baking "big" into the
      -- terminal itself means both sizes stay available at once.
      size = 15,
      direction = "horizontal",
      open_mapping = false, -- we set the mapping above so it's discoverable via which-key
      shading_factor = 2,
    },
  },
}
