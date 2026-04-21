-- init.lua
-- Bootstrap do lazy.nvim

-- Neovim 12.1+ is required (vim.uv, vim.diagnostic.jump)
if vim.fn.has("nvim-0.11") ~= 1 then
  vim.notify(
    "NewEraNeovim requires Neovim 12.1 or later. Please upgrade: https://neovim.io",
    vim.log.levels.ERROR
  )
  return
end

vim.g.mapleader=" "
-- Yank para o clipboard
vim.opt.clipboard="unnamedplus"

vim.opt.showtabline=0
vim.opt.winbar = ""

print("Loadding:")

-- Load error logger before anything else so every subsequent error is captured
local log = require("lib.logger")
log.install_notify_interceptor()
log.check_lazy_errors()
log.setup_commands()
log.info("init", "Neovim startup begin")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

vim.opt.mouse = ""


vim.api.nvim_create_autocmd('TextYankPost', {
desc = 'Highlight when yanking (copying) text',
group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
callback = function()
    vim.highlight.on_yank()
end,
})

-- Carrega os plugins da pasta lua/plugins/
local function benchmark(name, fn)
    local start = vim.uv.hrtime()
    local ok, err = pcall(fn)
    local elapsed = (vim.uv.hrtime() - start) / 1e6  -- convert ns to ms
    if not ok then
      log.error("init/" .. name, "Load phase failed", err)
      vim.notify(string.format("%s FAILED: %s", name, tostring(err)), vim.log.levels.ERROR, { title = "Loading" })
    else
      vim.notify(string.format("%s took %.2f ms", name, elapsed), { title = "Loadding",})
    end
end

benchmark("lazy.nvim setup", function()
    require("lazy").setup("plugins")
end)

benchmark("keymaps", function()
    require("keymaps").load_keymaps()
end)

benchmark("config keymaps", function()
    require("config").load_keymaps()
end)
