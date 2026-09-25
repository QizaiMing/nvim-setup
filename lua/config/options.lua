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
local undodir = vim.fn.stdpath("state") .. "/undo"
-- Vim reads 'undodir' but never creates it -- on a fresh clone (no prior
-- Neovim state on this machine) it doesn't exist yet, so undofile writes
-- silently do nothing at all until something else happens to create it
-- (confirmed by testing: undofile stayed unwritten after :write, no error
-- shown). Persistent undo across sessions is the whole point of the
-- option, so make sure the directory is actually there.
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.undodir = undodir

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
--
-- Appended (not a full replacement string) on purpose: a hardcoded copy of
-- Neovim's own default previously broke with "E546: Illegal mode" on a
-- different machine's Neovim version/build -- the default's exact mode
-- groupings aren't guaranteed stable across versions. A later entry for
-- the same mode overrides an earlier one, so this only touches "t" and
-- leaves everything else exactly as that Neovim's own default set it,
-- regardless of version.
--
-- Wrapped in pcall: even just appending "t:ver25" alone (no longer a
-- hardcoded default copy) *still* hit "E546: Illegal mode" on another
-- machine's Neovim build -- likely an older/minimal build where 't' isn't
-- a recognized guicursor mode at all. This is a cosmetic nicety, not core
-- functionality; it should never be able to break Neovim from starting.
-- Worst case without it: terminal mode keeps Neovim's own default cursor
-- shape for that build instead of a thin bar.
pcall(function() opt.guicursor:append("t:ver25") end)

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
