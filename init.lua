-- init.lua
-- Bootstrap do lazy.nvim

vim.g.mapleader=" "
-- Yank para o clipboard
vim.opt.clipboard="unnamedplus"

vim.opt.showtabline=0
vim.opt.winbar = ""

print("Loadding:")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
    local start = vim.loop.hrtime()
    fn()
    local elapsed = (vim.loop.hrtime() - start) / 1e6  -- convert ns to ms
    -- print(string.format("%s took %.2f ms", name, elapsed))

    vim.notify(string.format("%s took %.2f ms", name, elapsed), { title = "Loadding",})
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
