-- ~/.config/nvim/lua/plugins/toggleterm.lua
-- require this file from your init.lua: require("plugins.toggleterm")

-- 1. Basic setup
require("toggleterm").setup({
  -- open the terminal with Ctrl-`
  open_mapping       = [[<c-`>]],
  -- size in lines (if horizontal) or columns (if vertical)
  size               = 20,
  -- hide the number column in terminals
  hide_numbers       = true,
  -- start in insert mode
  start_in_insert    = true,
  -- whether to close the terminal on process exit
  close_on_exit      = true,
  -- keep terminal window size when toggling
  persist_size       = true,
  -- shading
  shade_terminals    = true,
  shading_factor     = 2,
  -- direction: "vertical" | "horizontal" | "window" | "float"
  direction          = "float",
  -- float window options (only used when direction = "float")
  float_opts = {
    border = "rounded",      -- “single” | “double” | “shadow” | …
    winblend = 3,            -- transparency
    highlights = {
      border   = "Normal",
      background = "Normal",
    },
  },
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- 3. Create “VSCode tasks” – a floating LazyGit, etc.
local Terminal = require("toggleterm.terminal").Terminal

-- Git UI
local lazygit = Terminal:new({
  cmd      = "lazygit",
  hidden   = true,
  direction= "float",
  float_opts = { border = "double" },
})
function _LAZYGIT_TOGGLE()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { noremap = true, silent = true })

-- Python REPL
local ipython = Terminal:new({ cmd = "ipython", hidden = true })
function _IPY_TOGGLE()
  ipython:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>py", "<cmd>lua _IPY_TOGGLE()<CR>", { noremap = true, silent = true })

-- System monitor
local htop = Terminal:new({ cmd = "htop", hidden = true })
function _HTOP_TOGGLE()
  htop:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>ht", "<cmd>lua _HTOP_TOGGLE()<CR>", { noremap = true, silent = true })
