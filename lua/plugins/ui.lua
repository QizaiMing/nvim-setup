-- Shared by the Space+b+d keymap AND bufferline's close_command /
-- right_mouse_command below (clicking a tab's x icon, or right-clicking it,
-- go through bufferline's own close path, not the keymap -- both needed the
-- same fix). Plain :bdelete can fall back to showing nvim-tree's own buffer
-- in whatever window displayed the closed buffer, even with other real
-- files still open (confirmed by testing). This switches every window
-- showing the closed buffer to another real, listed buffer first.
local function close_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local listed = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= bufnr
  end, vim.api.nvim_list_bufs())

  if #listed > 0 then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == bufnr then
        vim.api.nvim_win_call(win, function()
          vim.cmd("bnext")
        end)
      end
    end
  end
  vim.cmd("bdelete " .. bufnr)
end

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
      { "<leader>bd", function() close_buffer() end, desc = "Close buffer" },
    },
    opts = {
      options = {
        -- Same fix as Space+b+d, for closing a tab by clicking its x icon
        -- or right-clicking it -- those go through bufferline's own close
        -- path, not the keymap above, and had the identical bug.
        close_command = function(bufnr) close_buffer(bufnr) end,
        right_mouse_command = function(bufnr) close_buffer(bufnr) end,
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
