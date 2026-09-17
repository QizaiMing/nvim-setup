return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {},
  },

  -- Statusline styled after VS Code's bottom bar.
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dracula",
        component_separators = "",
        section_separators = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Top tab bar styled after VS Code's open-editor tabs.
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      -- VS Code's actual default for cycling editor tabs.
      { "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      {
        "<leader>bd",
        function()
          -- Plain :bdelete can fall back to whatever buffer this window
          -- happened to show before (which can be nvim-tree's own buffer,
          -- confirmed by testing), even with other real files still open.
          -- Switch to the next real listed buffer first so the window
          -- always lands on another open file, like VS Code closing a tab.
          local current = vim.api.nvim_get_current_buf()
          local listed = vim.tbl_filter(function(b)
            return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= current
          end, vim.api.nvim_list_bufs())
          if #listed > 0 then
            vim.cmd("bnext")
          end
          vim.cmd("bdelete " .. current)
        end,
        desc = "Close buffer",
      },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- Vertical indent guides, like VS Code's faint indent lines.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "VeryLazy",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },

  -- Smoother, VS Code-like UI for inputs/selects (rename prompt, code actions, etc.).
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
