-- keymaps.general.lua
local map = vim.keymap.set


-- Configurações visuais básicas
vim.opt.number = true          -- Mostrar números das linhas
vim.opt.relativenumber = true  -- Mostrar números relativos
-- vim.opt.showtabline = 2        -- Sempre mostrar a linha de tabs
vim.opt.list = true            -- Mostrar caracteres invisíveis
vim.opt.listchars = {          -- Configurar caracteres invisíveis
    tab = '→ ',
    trail = '·',
    extends = '>',
    precedes = '<',
    space = '·'
}
vim.opt.cursorline = true      -- Destacar a linha atual
vim.opt.termguicolors = true   -- Habilitar cores verdadeiras no terminal
vim.opt.signcolumn = "yes"     -- Sempre mostrar a coluna de sinais

-- Salvar com <leader>s
map("n", "<leader>s", "<cmd>w<CR>", {
})

-- Janela: mover entre splits com Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", {
})
map("n", "<C-l>", "<C-w>l", {
})
map("n", "<C-j>", "<C-w>j", {
})
map("n", "<C-k>", "<C-w>k", {
})

map("n", "<leader>w\\", "<cmd>vsplit<CR>", {
    desc = "Vertical Split"
})

map("n", "<leader>w-", "<cmd>split<CR>", {
    desc = "Horizontal Split"
})

map("n", "<leader>qq", "<cmd>q!<CR>", {
    desc = "Quit buffer/File"
})

map("n", "<leader>wq", "<cmd>wq<CR>", {
    desc = "Write and quite buffer/file"
})
