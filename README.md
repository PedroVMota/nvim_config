
![New Era Configuration Guide](assets/Main.png "New Era Configuration Guide")

<table>
  <tr>
    <td style="padding: 5px; border: 1px solid #ddd;">
      <img src="assets/Usage.png" alt="Image 1" style="width:100%;">
    </td>
    <td style="padding: 5px; border: 1px solid #ddd;">
      <img src="assets/Search.png" alt="Image 2" style="width:100%;">
    </td>
  </tr>
  <!-- Add more rows here as needed -->
</table>




### ‼️This is not finished‼️


`In case of something goes wrong, create an issue and I will right there to be give you feed back and solve your prblem`

# **New Era Configuration Guide**

## 1. File Structure
```
nvim/
  ├─ init.lua               # Main entrypoint and bootstrap
  ├─ lazy-lock.json         # Plugin version lockfile
  └─ lua/
      ├─ config/            # Plugin-specific settings and keymaps
      │   ├─ init.lua       # Auto-loads all other config/*.lua files
      │   ├─ lualine.lua    # lualine setup (statusline)
      │   ├─ cmp.lua        # nvim-cmp mappings & setup
      │   ├─ harpoon.lua    # harpoon keymaps & Telescope integration
      │   └─ whichkey.lua   # (currently empty placeholder)
      └─ plugins/           # Plugin declarations for lazy.nvim
          ├─ core.lua       # Core UI plugins (file explorer, statusline, theme)
          ├─ lazy.lua       # bootstrap dependency (plenary.nvim)
          ├─ cmp.lua        # Autocompletion engine & sources
          ├─ lsp.lua        # LSP management (lspconfig, mason)
          ├─ Telescope.lua  # Fuzzy finder + fzf-native
          ├─ GitSigns.lua   # Git gutter signs
          ├─ bufferline.lua # Buffer/tabline management
          ├─ harpoon.lua    # Mark & navigate files
          ├─ whichkey.lua   # Dynamic keybinding hints
          └─ noice.lua      # Noice.nvim UI enhancements (empty)
```
---
# Short Cuts

## General (from [nvim/lua/keymaps/general.lua](nvim/lua/keymaps/general.lua))
- `<leader>s` – Save file
- `<C-h>` – Move to the split on the left
- `<C-l>` – Move to the split on the right
- `<C-j>` – Move to the split below
- `<C-k>` – Move to the split above
- `<leader>w\` – Open a vertical split
- `<leader>w-` – Open a horizontal split
- `<leader>qq` – Force quit the current buffer/file
- `<leader>wq` – Write and quit the current buffer/file

## LSP (from [nvim/lua/keymaps/lsp.lua](nvim/lua/keymaps/lsp.lua))
- `gd` – Go to definition
- `K` – Show hover information
- `gr` – List references
- `<leader>rn` – Rename symbol
- `<leader>ca` – Code action
- `[d` – Go to previous diagnostic
- `]d` – Go to next diagnostic

## Mason (from [nvim/lua/keymaps/mason.lua](nvim/lua/keymaps/mason.lua))
- `<leader>m` – Open Mason
- `<leader>mi` – MasonInstall
- `<leader>mu` – MasonUpdate

## Harpoon (from [nvim/lua/keymaps/harpoon.lua](nvim/lua/keymaps/harpoon.lua) & [nvim/lua/config/harpoon.lua](nvim/lua/config/harpoon.lua))
- `<leader>a` – Add file to Harpoon list
- `<C-e>` – Toggle/ Open Harpoon quick menu
- `<C-h>` – Select Harpoon mark 1
- `<C-t>` – Select Harpoon mark 2
- `<C-n>` – Select Harpoon mark 3
- `<C-s>` – Select Harpoon mark 4
- `<C-S-P>` – Go to the previous Harpoon buffer
- `<C-S-N>` – Go to the next Harpoon buffer

## Telescope (from [nvim/lua/plugins/Telescope.lua](nvim/lua/plugins/Telescope.lua))
- `<leader>sh` – Search help tags
- `<leader>sk` – Search keymaps
- `<leader>sf` – Find files
- `<leader>ss` – List available Telescope pickers
- `<leader>sw` – Search the word under the cursor
- `<leader>sg` – Live grep search
- `<leader>sd` – Search diagnostics
- `<leader>sr` – Resume Telescope last picker
- `<leader>s.` – Show recent files
- `<leader><leader>` – List existing buffers
- `<leader>saf` – Global live grep ("Search All Files")
- `<leader>/` – Fuzzy search in the current buffer
- `<leader>s/` – Live grep in open files
- `<leader>sn` – Find Neovim configuration files

## Autocompletion (from [nvim/lua/config/cmp.lua](nvim/lua/config/cmp.lua))
- `<C-b>` – Scroll docs upward
- `<C-f>` – Scroll docs downward
- `<C-Space>` – Trigger completion
- `<C-e>` – Abort completion
- `<CR>` – Confirm selection


## 2. Bootstrap & Core Settings (`init.lua`)

- **Leader Key**: Set to space (`vim.g.mapleader = " "`).
- **Clipboard**: Uses `unnamedplus` for system clipboard integration.
- **Mouse**: Disabled (`vim.opt.mouse = ""`).
- **Yank Highlight**: Highlights text on yank via an autocommand.
- **Plugin Manager**: Clones and initializes **folke/lazy.nvim**, prepending it to `runtimepath`.
- **Loader Calls**:
  - `require("lazy").setup("plugins")` — Loads all files in `lua/plugins/`.
  - `require("keymaps").load_keymaps()` — Loads per-plugin keymaps from `lua/config/`.
  - `require("config").load_keymaps()` — (Redundant mirror of keymap loader).

---

## 3. Plugin Management with lazy.nvim

All plugins are declared in individual Lua files under `lua/plugins/`. The bootstrap in `init.lua` uses `lazy.nvim` to install, update, and load them on demand (e.g., by events like `BufRead` or `VimEnter`). The `lazy-lock.json` file pins exact commit hashes for reproducible setups.

---

## 4. Plugin Configuration & Commands

### 4.1 Core Plugins (`core.lua`)
- **nvim-tree/nvim-tree.lua**
  - A file explorer sidebar.
  - **Dependencies**: `nvim-tree/nvim-web-devicons` for file icons.
- **nvim-lualine/lualine.nvim**
  - A fast, easy-to-configure status line.
- **folke/tokyonight.nvim**
  - A minimal, dark colorscheme.
  - **Config**: Transparent background + sets `tokyonight` as the active theme.

### 4.2 Autocompletion (`cmp.lua`)
- **hrsh7th/nvim-cmp**: Core completion engine.
- **Sources**:
  - `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path` — Standard LSP, buffer, and path completions.
  - `LuaSnip` + `cmp_luasnip` — Snippet engine integration.
- **Key Mappings** (Insert Mode):
  - `<C-b>` / `<C-f>`: Scroll documentation.
  - `<C-Space>`: Trigger completion menu.
  - `<C-e>`: Abort completion.
  - `<CR>`: Confirm selection.

### 4.3 LSP Setup (`lsp.lua`)
- **neovim/nvim-lspconfig**: Native LSP support.
- **williamboman/mason.nvim**: Installer & manager for LSP servers, linters, and formatters.
  - **Build Command**: `:MasonUpdate` on install/update.
- **williamboman/mason-lspconfig.nvim**: Bridges `mason.nvim` with `nvim-lspconfig` for automatic setup.

### 4.4 Fuzzy Finder (`Telescope.lua`)
- **nvim-telescope/telescope.nvim**: Flexible fuzzy finder.
- **Dependencies**: `nvim-lua/plenary.nvim` + optional `telescope-fzf-native.nvim` (with `make` build).
- **Lazy-loading**: Triggered on `VimEnter` for responsiveness.
- **Key Mappings**:
  - `<leader>s/` — Live grep **within open files**.
  - `<leader>sn` — Find files in your Neovim config directory.
- **Usage Hints**:
  - Insert mode `/<C-/>`, normal mode `?` for in-finder help.

### 4.5 Git Integration (`GitSigns.lua`)
- **lewis6991/gitsigns.nvim**: Git diff markers in the sign column.
- **Events**: Loads on `BufRead` and `BufNewFile`.
- **Options**: Custom symbols for add (`+`), change (`~`), delete (`_`), etc.

### 4.6 Buffer Line (`bufferline.lua`)
- **akinsho/bufferline.nvim**: Displays buffers as tabs.
- **Dependencies**: `nvim-tree/nvim-web-devicons`.

### 4.7 Harpoon (`harpoon.lua`)
- **ThePrimeagen/harpoon**: Quick file marking and navigation.
- **Branch**: `harpoon2`.
- **Dependencies**: `plenary.nvim`.
- **Key Mapping**:
  - `<C-e>`: Opens a Telescope-powered Harpoon picker.

### 4.8 Which-Key (`whichkey.lua`)
- **folke/which-key.nvim**: Displays available keybindings in a popup.
- **Loading Event**: `VimEnter`.
- **Options**:
  - Delay = 0 ms, icons dependent on `vim.g.have_nerd_font`.
  - Groups for `<leader>s`, `<leader>t`, and `<leader>h` (git hunks).

### 4.9 Noice (`noice.lua`)
- **noice.nvim**: Enhanced UI for messages and cmdline (currently empty configuration).

---

## 5. Keymap Loader (`config/init.lua`)

The loader scans `lua/config/` and requires each non-`init.lua` file, invoking any keymaps or settings defined. This keeps plugin declarations (in `lua/plugins/`) separate from key-binding logic.





## 6. Customization & Extending

- **Adding Plugins**: Create a new file in `lua/plugins/` returning a Lazy.nvim spec.
- **Keymaps**: Place any custom keybindings in `lua/config/<plugin>.lua`.
- **Themes**: Install new colorschemes via Lazy and configure them in `core.lua`.
- **LSP Servers**: Use `:Mason` UI to add new language servers, or configure manually with `nvim-lspconfig`.

