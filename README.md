# nvim-config

Personal Neovim config styled after VS Code + Dracula: same dark palette, a
file explorer sidebar, tabs across the top, a status bar, fuzzy find, git
gutter signs, LSP-backed autocomplete/diagnostics, and familiar keybindings.

Everything is plain Lua under `lua/`, managed by [lazy.nvim](https://github.com/folke/lazy.nvim),
which bootstraps itself — there is nothing to install by hand beyond Neovim
and git.

## Install on any machine (including a fresh SSH server)

Requirements: Neovim >= 0.10 (built for 0.11), `git`, and for the full
experience `curl` or `wget`, a C compiler (`gcc`/`clang` — needed to build
Treesitter parsers), `unzip` (needed by Mason to install language
servers), and **Node.js + npm** — all but one of the configured language
servers (`lua_ls` is the exception) are npm packages under the hood, so
without Node.js Mason silently fails to install almost every one of them.
On Debian/Ubuntu:

```sh
sudo apt update && sudo apt install -y neovim git curl gcc unzip ripgrep nodejs npm
```

Then clone this repo directly into Neovim's config directory:

```sh
# Linux / macOS
git clone https://github.com/<your-user>/nvim-config.git ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/<your-user>/nvim-config.git $env:LOCALAPPDATA\nvim
```

On Windows, also install `ripgrep` (needed for `Space f g` / project-wide
search — Telescope's `live_grep` shells out to it, and unlike Linux it
isn't bundled with anything else here):

```powershell
winget install BurntSushi.ripgrep.MSVC
```

then restart your terminal so it picks up the updated `PATH`.

Launch `nvim`. On first start, lazy.nvim clones itself and installs every
plugin automatically (you'll see a progress window), then Mason installs the
language servers listed in `lua/plugins/lsp.lua` in the background. Restart
Neovim once that finishes. Every subsequent `nvim` launch is instant.

No admin/root privileges are required — everything installs under
`~/.local/share/nvim` (or `%LOCALAPPDATA%\nvim-data` on Windows).

### Icons over SSH

File/git icons use Nerd Font glyphs. The server doesn't need any font
installed — only the **terminal emulator you're SSHing from** needs a Nerd
Font selected (e.g. "FiraCode Nerd Font", "JetBrainsMono Nerd Font"). Grab
one from [nerdfonts.com](https://www.nerdfonts.com/) if you don't already
have one set as your terminal's font.

## What's included

| Area | Plugin |
|---|---|
| Theme | `Mofiqul/dracula.nvim` |
| Statusline | `nvim-lualine/lualine.nvim` |
| Tabs | `akinsho/bufferline.nvim` |
| File explorer | `nvim-tree/nvim-tree.lua` |
| Fuzzy finder | `nvim-telescope/telescope.nvim` |
| Syntax highlighting | `nvim-treesitter/nvim-treesitter` |
| LSP | `neovim/nvim-lspconfig` + `mason.nvim` |
| Autocomplete | `hrsh7th/nvim-cmp` |
| Git gutter | `lewis6991/gitsigns.nvim` |
| Git Source Control panel | `NeogitOrg/neogit` + `sindrets/diffview.nvim` |
| Comment toggling | `numToStr/Comment.nvim` |
| Integrated terminal | `akinsho/toggleterm.nvim` |
| Keybinding hints | `folke/which-key.nvim` |
| Markdown preview | `MeanderingProgrammer/render-markdown.nvim` |

## Day-to-day workflow

Leader key is `<Space>`. Press `Space` and wait a moment in normal mode —
which-key pops up a menu of everything available from there, so you don't
need to memorize the `Space` combos below.

Notation: `C` = Ctrl, `S` = Shift, `A` = Alt. `` Ctrl+` `` is written as
that backtick character, not the letter.

### Opening and finding files (global search)

| Keys | Action |
|---|---|
| `Ctrl+P` | Find files by name (fuzzy) |
| `Space f g` | **Search text across the whole project** (live grep) |
| `Ctrl+Shift+F` | Same as above, on terminals that pass Shift through (Windows Terminal, Kitty, WezTerm — not all SSH terminals do) |
| `Space f b` | Switch to another open buffer |
| `Space f p` | Command palette (`:Telescope commands`) |
| `Space f h` | Search help docs |
| `Space f d` | List diagnostics (errors/warnings) across open buffers |

Inside any Telescope search window: keep typing to filter, `Ctrl+J`/`Ctrl+K`
(or arrows) to move the selection, `Enter` to open, `Ctrl+V` to open in a
vertical split, `Ctrl+X` for a horizontal split, `Esc` to cancel.

### Searching inside the current file

This is plain Vim, no plugin needed:

| Keys | Action |
|---|---|
| `/pattern` then `Enter` | Search forward for `pattern` |
| `?pattern` then `Enter` | Search backward |
| `n` / `N` | Jump to next / previous match |
| `*` / `#` | Search for the word under the cursor, forward / backward |
| `Esc` | Clear the search highlight |
| `:%s/old/new/g` | Replace all `old` with `new` in the file |
| `:%s/old/new/gc` | Same, but confirm each replacement (`y`/`n`/`a`) |

### File explorer (sidebar)

Docked on the right (configurable in `lua/plugins/explorer.lua`'s
`view.side`, set to `"left"` for Vim/VS Code's more common default).

| Keys | Action |
|---|---|
| `Ctrl+B` | Toggle the file tree open/closed |
| `Space e` | Open the tree and focus it |
| `Enter` (on a file, inside the tree) | Open it |
| `Enter` (on a folder, inside the tree) | Expand/collapse it |
| `a` | Create a new file/folder (end the name with `/` for a folder) |
| `d` | Delete the entry under the cursor |
| `r` | Rename |
| `x` / `c` / `p` | Cut / copy / paste |
| `H` | Toggle showing dotfiles |
| `-` | Go up a directory — changes the tree's root to the parent folder |
| `gr` | **Reset the tree root back to the project root** — undoes any number of `-` presses in one go. nvim-tree has no built-in way to do this (closing/reopening the tree does *not* revert it), added in `lua/plugins/explorer.lua` |
| `g?` | Full nvim-tree keymap help, while focused in the tree |
| `Ctrl+H` (while focused in the tree) | Jump back to the editor, without opening/closing anything |

**Switching focus in general**: `Ctrl+H/J/K/L` moves focus to the
left/down/up/right split from *any* window — the editor, the file tree, or
(see below) the terminal. It's the one navigation shortcut that works
everywhere, so if you're ever unsure how to get back to editing, that's it.

### Terminal

| Keys | Action |
|---|---|
| `F12` | Open the integrated terminal / close it again — the reliable one, works in every terminal emulator. Opens as a small strip along the bottom, same as VS Code's default |
| `Space t t` | **Open a full-size terminal instead** — takes over the whole window exactly like opening a file, and shows up as a tab in the top bufferline right alongside real files. Switch to/from it with the same buffer navigation as any file (`Shift+L/H`, `Ctrl+Tab`, click its tab, `Ctrl+H/J/K/L`); close it with `Space b d` or `:q` like any other buffer. Reuses the same terminal on repeat presses rather than piling up new ones. Complements `F12`'s small strip rather than replacing it — both stay available |
| Focusing the terminal (opening it, or `Ctrl+H/J/K/L`-ing into it) | Always drops you straight into insert mode, ready to type — like VS Code's terminal. The cursor also switches to a thin bar (same as regular insert mode) instead of Neovim's default blinking block for terminal mode, which otherwise looks a lot like normal/visual mode at a glance |
| `` Ctrl+` `` or `Ctrl+;` | Same as `F12`, as a bonus — but "Ctrl + punctuation" combos aren't encoded as distinct keypresses by every terminal emulator (confirmed not to work in this user's Windows Terminal setup), so `F12` is the one to rely on. `F11` was tried for a maximize toggle but removed — Windows Terminal (like most terminal emulators/OSes) owns F11 as its own fullscreen key and never passes it through to Neovim at all |
| Terminal shell | Git Bash (matches this user's VS Code default terminal profile), regardless of what shell launched Neovim itself |
| `Ctrl+H/J/K/L` (while inside the terminal, even mid-command) | **Jump straight to the file tree / editor / another split in one keypress** — no need to press Esc first |
| `jk` (while inside the terminal) | Leave terminal-insert mode without closing the panel or changing focus — lets you scroll/copy with normal Vim motions, then `i` or `a` to go back to typing shell commands. Will also fire if you type that literal substring fast into a command (rare, but recoverable — just press `i` again) |
| `Esc` (while inside the terminal) | **Passes straight through** to whatever's running in the terminal — deliberately *not* intercepted, since Claude Code, vim, REPLs, etc. use Esc themselves (cancel, leave insert mode...) and swallowing it here means it never reaches them. Use `jk` above to leave terminal mode instead |

### Git

**Source Control panel** (VS Code equivalent — see all modified, added, and
deleted files before staging/committing):

| Keys | Action |
|---|---|
| `Space g g` | **Open the Source Control panel** (Neogit's status view) |
| `Space g c` | Open the commit panel directly |
| `Space g p` / `Space g l` | Push / pull |

Inside the panel: `s` stages the file or hunk under the cursor (works on a
whole section too — put the cursor on "Unstaged changes" and press `s` to
stage everything), `u` unstages, `x` discards changes, `<Tab>` expands a
file to show its diff inline, `c` opens the commit prompt, `p`/`P` opens the
push/pull menu, `?` shows the full help, `q` closes the panel. Diffs render
through `diffview.nvim` for a clean side-by-side view.

**Inline hunk markers** (as you edit, no panel needed):

| Keys | Action |
|---|---|
| `]c` / `[c` | Jump to the next / previous changed hunk in the current file |
| `Space h p` | Preview the diff for the hunk under the cursor, in a popup |
| `Space h s` | Stage the hunk under the cursor |
| `Space h r` | Reset (discard) the hunk under the cursor |

Changed lines are also marked in the left gutter (`│` added/changed, `_`
removed), and the current branch shows in the statusline.

### Buffers and splits

| Keys | Action |
|---|---|
| `Shift+L` / `Shift+H` | Next / previous open buffer (VS Code tab equivalent) |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Same as above — matches VS Code's actual default for cycling editor tabs |
| `Space b d`, `:q`, `:quit`, or click a tab's `x` icon | Close a buffer — always lands on another open file afterward, keeping the tree/terminal layout untouched, never falling back to the file tree. `:q!`/`:quit!` force-close, discarding unsaved changes; without `!`, a modified buffer is refused with a clean message rather than closed. Works the same way on `Space t t`'s full-window terminal too (its shell job is always force-killed on close — there's no "unsaved work" to protect there). Shared logic lives in `lua/config/utils.lua`'s `close_buffer`/`smart_quit`. Note this means `:q` no longer exits Neovim — use `:qa`/`:qa!` for that (untouched, works exactly as before) |
| `Ctrl+H/J/K/L` | Move focus between splits (left/down/up/right); also works from inside the terminal or file tree |
| `Ctrl+Up/Down/Left/Right` | Resize the current split |
| `Space s v` | **Split the current file vertically** (side by side) — VS Code's "Split Editor" |
| `Space s h` | Split the current file horizontally (stacked) |
| `Ctrl+\` | Same as `Space s v` — matches VS Code's own default key, as a bonus for terminals that pass it through (see the `Ctrl+`` `/`Ctrl+;` note above — not guaranteed everywhere, so `Space s v` is the one to rely on) |
| `:vsplit` / `:split` | Same, as plain Vim commands |

### Editing

| Keys | Action |
|---|---|
| `Ctrl+S` | Save (works in normal, insert, and visual mode) |
| `Ctrl+/` | Toggle a line comment (normal mode) or comment out a selection (visual mode) |
| `Alt+Up` / `Alt+Down` | Move the current line (or selection) up/down |
| `Tab` / `Shift+Tab` (visual mode) | Indent / outdent the selection, keeping it selected |
| `jk` (insert mode) | Exit to normal mode, instead of reaching for `Esc` |

### Code intelligence (LSP)

Available once a language server has attached to the buffer (check the
statusline, or `:LspInfo`). Currently configured (see "Adding a language
server" below to add more):

| Language(s) | Server |
|---|---|
| Lua | `lua_ls` |
| Python | `pyright` |
| JS / TypeScript / JSX / TSX | `ts_ls` |
| PHP | `intelephense` |
| Bash | `bashls` |
| JSON | `jsonls` |
| YAML | `yamlls` |
| HTML | `html` |
| CSS | `cssls` |

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Show hover docs for the symbol under the cursor |
| `Space r n` | Rename the symbol under the cursor, project-wide |
| `Space c a` | Show available code actions (quick fixes, refactors) |
| `Space f` | Format the current buffer |
| `[d` / `]d` | Jump to the previous / next diagnostic (error/warning) |

### Markdown preview

Opening any `.md` file automatically renders it in place: headers, bold/
italic, tables, checkboxes, and code blocks get redrawn nicely right in the
buffer as you edit — no browser, no external tool, works the same over SSH.

| Keys | Action |
|---|---|
| `Space m p` | Toggle rendering on/off for the current buffer (to edit raw markdown, e.g. around a tricky table) |

### Core Vim navigation (no plugin, for reference)

| Keys | Action |
|---|---|
| `h j k l` | Left / down / up / right |
| `w` / `b` / `e` | Next word start / previous word start / word end |
| `0` / `^` / `$` | Start of line / first non-blank char / end of line |
| `gg` / `G` | Top / bottom of file |
| `Ctrl+D` / `Ctrl+U` | Scroll half a page down / up |
| `dd` / `yy` / `p` | Delete (cut) line / copy line / paste |
| `u` / `Ctrl+R` | Undo / redo |
| `v` / `V` / `Ctrl+V` | Visual (char) / visual line / visual block select |
| `.` | Repeat the last change |

## Updating

```
:Lazy sync
```

pulls plugin updates and reruns install. `lazy-lock.json` pins exact plugin
commits — commit it whenever you intentionally update, so every machine you
pull this repo onto gets the identical, tested plugin versions rather than
whatever is newest at clone time.

## Adding a language server

Add the Mason package name to `ensure_installed` in `lua/plugins/lsp.lua`
(find exact names via `:Mason`), restart Neovim, and it installs
automatically on every machine that pulls this repo.
