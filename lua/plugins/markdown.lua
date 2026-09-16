return {
  -- Renders markdown (headers, tables, checkboxes, code blocks, ...) nicely
  -- right in the buffer as you type -- no browser, works the same over SSH.
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown preview", ft = "markdown" },
  },
  opts = {},
}
