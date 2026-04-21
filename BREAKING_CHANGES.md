# Breaking Changes

## Neovim 12.1 Support

**Minimum required version: Neovim 12.1**

This release drops support for Neovim versions below 12.1. If you are running an older version, NewEraNeovim will refuse to load and display an error message.

---

### 1. `vim.loop` removed — replaced by `vim.uv`

**Affected files:**
- `init.lua`
- `lua/config/init.lua`
- `lua/keymaps/init.lua`

`vim.loop` was a compatibility alias for the libuv bindings (`vim.uv`) introduced in Neovim 0.10. It has been fully removed in Neovim 12.x.

**Before:**
```lua
vim.loop.fs_stat(path)
vim.loop.hrtime()
vim.loop.fs_scandir(dir)
vim.loop.fs_scandir_next(handle)
```

**After:**
```lua
vim.uv.fs_stat(path)
vim.uv.hrtime()
vim.uv.fs_scandir(dir)
vim.uv.fs_scandir_next(handle)
```

---

### 2. `vim.diagnostic.goto_prev` / `vim.diagnostic.goto_next` removed — replaced by `vim.diagnostic.jump`

**Affected files:**
- `lua/keymaps/lsp.lua`

`vim.diagnostic.goto_prev` and `vim.diagnostic.goto_next` were deprecated in Neovim 0.11 when `vim.diagnostic.jump` was introduced as the unified API. They have been removed in Neovim 12.x.

**Before:**
```lua
vim.diagnostic.goto_prev
vim.diagnostic.goto_next
```

**After:**
```lua
function() vim.diagnostic.jump({ count = -1 }) end  -- previous
function() vim.diagnostic.jump({ count = 1 }) end   -- next
```

The `count` field controls direction and how many diagnostics to jump: negative for previous, positive for next.

---

### 3. Minimum version enforcement

`init.lua` now checks for Neovim 12.1 on startup. If the requirement is not met, loading is aborted with a clear error:

```
NewEraNeovim requires Neovim 12.1 or later. Please upgrade: https://neovim.io
```

`install.sh` also validates the fetched Neovim release against the minimum version before proceeding with the installation.

---

### Migration Guide

If you are upgrading from a previous version of NewEraNeovim:

1. **Update Neovim** to version 12.1 or later:
   ```bash
   ./install.sh
   ```

2. **Update your config** by pulling the latest changes:
   ```bash
   git pull origin main
   ```

3. Restart Neovim. Lazy.nvim will sync any updated plugin dependencies automatically.

> For issues or questions, open a GitHub issue at https://github.com/PedroVMota/NewEraNeovim/issues
