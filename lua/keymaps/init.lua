-- /lua/keymaps/init.lua
local M = {}

function M.load_keymaps()
    local keymaps_dir = vim.fn.stdpath("config") .. "/lua/keymaps"
    local handle = vim.uv.fs_scandir(keymaps_dir)
    if not handle then return end

    while true do
        local name = vim.uv.fs_scandir_next(handle)
        if not name then break end
        if name:sub(-4) == ".lua" and name ~= "init.lua" then
            require("keymaps." .. name:gsub("%.lua$", ""))
        end
    end
end

M.load_keymaps()
return M
