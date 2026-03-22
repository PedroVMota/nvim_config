---- filepath: /Users/pedro_mota/Desktop/NewEra/nvim/lua/keymaps/harpoon.lua
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED
 
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to Harpoon list" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon quick menu" })

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Select Harpoon mark 1" })
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Select Harpoon mark 2" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Select Harpoon mark 3" })
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Select Harpoon mark 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Previous Harpoon buffer" })
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Next Harpoon buffer" })



