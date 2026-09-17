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

-- Neovim's default guicursor renders terminal-insert mode with a blinking
-- *block* cursor (same shape as normal/visual mode), even though it's a
-- distinct mode where you're actively typing to the shell -- easy to
-- mistake for still being in normal/visual mode at a glance. Give it the
-- same thin vertical bar as regular insert mode instead.
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:ver25"

if vim.fn.has("win32") == 1 then
  -- Prefer Git Bash as the default shell (:terminal, :!, toggleterm), to
  -- match this user's VS Code "terminal.integrated.defaultProfile.windows".
  -- Checked explicitly rather than relying on $SHELL, since that's only set
  -- when Neovim happens to be launched from inside a Git Bash window.
  local bash_candidates = {
    "C:\\Program Files\\Git\\bin\\bash.exe",
    "C:\\Program Files (x86)\\Git\\bin\\bash.exe",
  }
  local bash_path = nil
  for _, path in ipairs(bash_candidates) do
    if vim.fn.executable(path) == 1 then
      bash_path = path
      break
    end
  end
  if not bash_path and vim.fn.executable("bash") == 1 then
    local resolved = vim.fn.exepath("bash")
    -- Skip the WSL shim at System32\bash.exe -- that launches a WSL distro,
    -- not Git Bash.
    if not resolved:lower():find("system32") then
      bash_path = resolved
    end
  end

  if bash_path then
    -- 'shell' needs literal embedded quotes when the path has spaces --
    -- Neovim's own Windows default-detection does the same internally.
    opt.shell = '"' .. bash_path .. '"'
    -- Windows' default-option heuristics leave shellcmdflag set for cmd.exe
    -- (/s /c) unless 'shell' is recognized as POSIX at startup; set the
    -- bash-compatible flags explicitly.
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
