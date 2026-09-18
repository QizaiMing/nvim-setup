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

  -- Killing a terminal's shell job isn't a "lose my edits" risk the way
  -- discarding unsaved file changes is -- always force through both that
  -- and Vim's separate "job still running, will be killed" refusal (E89),
  -- confirmed by testing that a terminal buffer hits it without this.
  if vim.bo[bufnr].buftype == "terminal" then
    force = true
  end

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
  -- vim.b.is_main_terminal (set by open_full_terminal below) singles out
  -- specifically the <leader>tt full-window terminal, so :q works on it
  -- the same way it does on a file. Deliberately NOT extended to every
  -- buftype=="terminal" buffer -- that would also catch F12's small
  -- toggleterm strip, which is meant to hide/resume on toggle, not have
  -- its session killed by a stray :q. Anything else (file tree, Neogit,
  -- quickfix, ...) still falls back to plain :q/:q!, where window-close
  -- is the right thing.
  if vim.bo.buftype == "" or vim.b.is_main_terminal then
    M.close_buffer(nil, bang)
  else
    vim.cmd(bang and "q!" or "q")
  end
end

-- Opens a full-size terminal *in place of* the current window's buffer --
-- exactly like opening a file -- rather than as a split, so it takes the
-- whole screen and shows up in bufferline as a tab alongside real files.
-- Switch away from it with the usual buffer navigation (Shift+L/H,
-- Ctrl+Tab, clicking its tab, Ctrl+H/J/K/L to another split) and close it
-- with Space+b+d/:q, same as any other buffer -- no special-casing needed
-- there, confirmed by testing that a running terminal job doesn't block a
-- plain :bdelete.
--
-- Reuses the same terminal buffer on repeat presses instead of piling up a
-- new one every time, by tagging it with a buffer-local marker.
function M.open_full_terminal()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.b[buf].is_main_terminal then
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end

  -- Don't clobber the file tree's own window with a terminal.
  if vim.bo.filetype == "NvimTree" then
    vim.cmd("wincmd p")
  end

  vim.cmd("terminal")
  vim.b.is_main_terminal = true
end

return M
