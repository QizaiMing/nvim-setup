# nvim-config

Personal Neovim config styled after VS Code + Dracula: same dark palette, a
left file explorer, tabs across the top, a status bar, fuzzy find, git gutter
signs, LSP-backed autocomplete/diagnostics, and familiar keybindings.

Everything is plain Lua under `lua/`, managed by [lazy.nvim](https://github.com/folke/lazy.nvim),
which bootstraps itself — there is nothing to install by hand beyond Neovim
and git.

## Install on any machine (including a fresh SSH server)

Requirements: Neovim >= 0.10 (built for 0.11), `git`, and for the full
experience `curl` or `wget`, a C compiler (`gcc`/`clang` — needed to build
Treesitter parsers), and `unzip` (needed by Mason to install language
servers). On Debian/Ubuntu:

```sh
sudo apt update && sudo apt install -y neovim git curl gcc unzip ripgrep
```

Then clone this repo directly into Neovim's config directory:

```sh
# Linux / macOS
git clone https://github.com/<your-user>/nvim-config.git ~/.config/nvim

# Windows (PowerShell)
git clone https://github.com/<your-user>/nvim-config.git $env:LOCALAPPDATA\nvim
```

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
| Comment toggling | `numToStr/Comment.nvim` |
| Integrated terminal | `akinsho/toggleterm.nvim` |
| Keybinding hints | `folke/which-key.nvim` |

Leader key is `<Space>`.

## Keybindings (VS Code parity)

| Keys | Action | Notes |
|---|---|---|
| `Ctrl+S` | Save file | works in normal/insert/visual |
| `Ctrl+P` | Find files | |
| `Ctrl+B` | Toggle file explorer | |
| `` Ctrl+` `` / `Ctrl+;` | Toggle terminal | both work; `Ctrl+;` matches this user's VS Code remap |
| `Ctrl+/` | Toggle line comment | sends `Ctrl+_` on most terminals |
| `Space f g` | Search in files (grep) | `Ctrl+Shift+F` also works in terminals that pass Shift through (Windows Terminal, Kitty, WezTerm) |
| `Space f p` | Command palette (`:Telescope commands`) | `Ctrl+Shift+P` also works where supported |
| `Space f b` | Switch open buffer | |
| `Alt+Up` / `Alt+Down` | Move line up/down | |
| `Shift+H` / `Shift+L` | Previous/next tab | |
| `Space b d` | Close current buffer/tab | |
| `gd` | Go to definition | |
| `gr` | Find references | |
| `K` | Hover docs | |
| `Space r n` | Rename symbol | |
| `Space c a` | Code action | |
| `Space f` (in a file with an LSP attached) | Format buffer | |
| `Ctrl+hjkl` | Move between splits | |
| `]c` / `[c` | Next/previous git change | |

Press `Space` and wait — which-key pops up a menu of everything available
from there.

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
