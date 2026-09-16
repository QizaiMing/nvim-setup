-- Neovim itself already ships prebuilt parsers for lua/vim/vimdoc/query/c/markdown*
-- (see :checkhealth or $VIMRUNTIME/parser); installing our own copies of those
-- via nvim-treesitter shadows the bundled ones and can fail to load on Windows.
-- Only install languages Neovim doesn't already bundle.
local ensure_installed = {
  "bash", "diff", "dockerfile", "go", "html", "css",
  "javascript", "typescript", "tsx", "json", "yaml",
  "python", "rust", "regex",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").install(ensure_installed)

    -- The "main" branch of nvim-treesitter only ships install/update
    -- tooling; highlighting and indent are opted into per-buffer.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        if vim.tbl_contains(ensure_installed, lang) and pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
