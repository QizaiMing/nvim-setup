local M = {}

-- Shared by the Space+b+d keymap, bufferline's close_command /
-- right_mouse_command (clicking a tab's x icon, or right-clicking it), and
-- the smart :q override below -- all three need the exact same fix. Plain
-- :bdelete can fall back to showing nvim-tree's own buffer in whatever
-- window displayed the closed buffer, even with other real files still
-- open (confirmed by testing). This switches every window showing the
-- closed buffer to another real, listed buffer first.
---@param bufnr integer? defaults to the current buffer
---@param force boolean? use bdelete! (discard unsaved changes) instead of bdelete
function M.close_buffer(bufnr, force)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check this BEFORE switching any window away from bufnr below. Bailing
  -- out after an already-failed bdelete left the window(s) already moved
  -- to a different file, hiding the one with unsaved changes that still
  -- needs attention (confirmed by testing) -- refuse cleanly upfront
  -- instead, leaving the layout untouched, same as vanilla Vim's :q does.
  if not force and vim.bo[bufnr].modified then
    vim.notify("No write since last change (add ! to override)", vim.log.levels.ERROR)
    return
  end

  local listed = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and b ~= bufnr
  end, vim.api.nvim_list_bufs())

  if #listed > 0 then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      -- Switching a buffer in one window can trigger autocmds (ours or a
      -- plugin's) that close ANOTHER window before this loop reaches it
      -- (confirmed by a real "Invalid window id" crash here) -- always
      -- recheck validity right before touching a window from a snapshot list.
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
        vim.api.nvim_win_call(win, function()
          vim.cmd("bnext")
        end)
      end
    end
  end
  vim.cmd("bdelete" .. (force and "! " or " ") .. bufnr)
end

-- Backs the :SmartQuit command that the `:q`/`:quit` cnoreabbrev in
-- keymaps.lua renames to (see there for why it's a two-step rename+command
-- rather than the abbreviation doing the work directly -- Vim's abbreviation
-- matching treats `!` as a separate trigger character, so a "q!" abbreviation
-- never actually fires; "q" always expands first and silently drops the
-- bang). On a normal file buffer, redirects to close_buffer so :q behaves
-- exactly like Space+b+d (close the file, keep the window/tree/terminal
-- layout intact) instead of Vim's native "close this window" behavior.
-- Falls back to plain :q/:q! anywhere that window-close is actually the
-- right thing (the file tree, terminal, Neogit, quickfix, ...). :qa/:qa!
-- are untouched by all of this and still fully quit Neovim -- that's now
-- the way to actually exit.
---@param bang boolean true if invoked as :SmartQuit! (i.e. the user typed :q!)
function M.smart_quit(bang)
  if vim.bo.buftype == "" then
    M.close_buffer(nil, bang)
  else
    vim.cmd(bang and "q!" or "q")
  end
end

local maximized = false

-- Backs the F11 keymap in keymaps.lua. Maximizes whichever window is
-- currently focused to fill the whole screen (both height and width), or
-- restores equal split sizes if already maximized. Works on any window --
-- a file split or the terminal -- so the terminal can stay its normal
-- small strip by default while still having a full height+width option on
-- demand, without needing two different terminal instances/sizes.
function M.toggle_maximize()
  if maximized then
    vim.cmd("wincmd =")
  else
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
  end
  maximized = not maximized
end

return M
