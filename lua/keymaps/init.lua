-- /lua/keymaps/init.lua
local M = {}

function M.load_keymaps()
    local log = require("lib.logger")
    local keymaps_dir = vim.fn.stdpath("config") .. "/lua/keymaps"
    local handle = vim.uv.fs_scandir(keymaps_dir)
    if not handle then return end

    while true do
        local name = vim.uv.fs_scandir_next(handle)
        if not name then break end
        if name:sub(-4) == ".lua" and name ~= "init.lua" then
            local mod = "keymaps." .. name:gsub("%.lua$", "")
            local ok, err = pcall(require, mod)
            if not ok then
                log.error(mod, "Keymap module failed to load", err)
                vim.notify(string.format("[keymaps] %s failed: %s", mod, tostring(err)), vim.log.levels.ERROR, { title = "Keymaps" })
            end
        end
    end
end

M.load_keymaps()
return M
