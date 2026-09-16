-- Core editor options, tuned to feel like VS Code defaults.
local opt = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "

opt.termguicolors = true
opt.number = true
opt.relativenumber = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share system clipboard, like VS Code copy/paste
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitright = true
opt.splitbelow = true

opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.updatetime = 250
opt.timeoutlen = 400

opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12

opt.fillchars = { eob = " " } -- hide the ~ lines past EOF, like VS Code's empty gutter
opt.laststatus = 3 -- one global statusline

if vim.fn.has("win32") == 1 then
  if vim.o.shell:lower():find("bash%.exe") then
    -- Neovim inherits 'shell' from $SHELL when launched from Git Bash, but
    -- its Windows default-option heuristics leave shellcmdflag set for
    -- cmd.exe (/s /c) instead of bash (-c), which breaks :terminal and :!.
    opt.shellcmdflag = "-c"
    opt.shellxquote = ""
    opt.shellquote = ""
    opt.shellredir = ">%s 2>&1"
    opt.shellpipe = "2>&1 | tee %s"
  elseif vim.fn.executable("pwsh") == 1 then
    opt.shell = "pwsh"
    opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  end
end
