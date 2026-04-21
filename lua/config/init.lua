-- /lua/config/init.lua
local M = {}

function M.load_keymaps()
    local log = require("lib.logger")
    local keymaps_dir = vim.fn.stdpath("config") .. "/lua/config"
    local handle = vim.uv.fs_scandir(keymaps_dir)
    if not handle then return end

    while true do
        local name = vim.uv.fs_scandir_next(handle)
        if not name then break end
        if name:sub(-4) == ".lua" and name ~= "init.lua" then
            local mod = "config." .. name:gsub("%.lua$", "")
            local ok, err = pcall(require, mod)
            if not ok then
                log.error(mod, "Config module failed to load", err)
                vim.notify(string.format("[config] %s failed: %s", mod, tostring(err)), vim.log.levels.ERROR, { title = "Config" })
            end
        end
    end
end

M.load_keymaps()
return M
