-- Generic keymaps that don't belong to a specific plugin.
-- Plugin-specific keymaps (Telescope, NvimTree, Comment, etc.) live in their
-- own spec files under lua/plugins/ so lazy.nvim can lazy-load on keypress.
local map = vim.keymap.set

-- Save like VS Code.
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr>", { desc = "Save file" })

-- Ported from the VS Code Vim extension config (vim.insertModeKeyBindings).
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Move lines up/down like Alt+Up/Down in VS Code.
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Indent/outdent selection without losing it, like Tab/Shift-Tab in VS Code.
map("v", "<Tab>", ">gv", { desc = "Indent selection" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent selection" })

-- Window navigation with Ctrl+hjkl.
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search highlight with Esc, like clicking away in VS Code's search box.
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Keep selection after re-indent.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Escape terminal insert mode with a single Esc, like clicking out of
-- VS Code's integrated terminal.
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Close the terminal panel from inside it with the same key that opened it
-- (Ctrl+` / Ctrl+;), like VS Code's toggle behavior. Plain maps, not part of
-- lazy.nvim's `keys` loader -- see lua/plugins/editor.lua for why.
map("t", [[<C-`>]], [[<C-\><C-n><cmd>ToggleTerm<cr>]], { desc = "Toggle terminal" })
map("t", "<C-;>", [[<C-\><C-n><cmd>ToggleTerm<cr>]], { desc = "Toggle terminal" })

-- Split navigation for resizing, like dragging VS Code's split gutters.
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
