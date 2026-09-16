return {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 1000, -- load before everything else so no flash of default colors
  config = function()
    require("dracula").setup({
      transparent_bg = false,
      italic_comment = true,
      show_end_of_buffer = false,
    })
    vim.cmd.colorscheme("dracula")
  end,
}
