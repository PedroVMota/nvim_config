-- Plugin error logger: persists ERROR/WARN events to disk
local M = {}

local log_path = vim.fn.stdpath("log") .. "/plugin-errors.log"

local function ensure_log_dir()
  local dir = vim.fn.fnamemodify(log_path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function write_entry(level_str, source, message, details)
  ensure_log_dir()
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local file = io.open(log_path, "a")
  if not file then return end
  file:write(string.format("[%s] [%s] [%s] %s\n", timestamp, level_str, source, message))
  if details then
    for line in tostring(details):gmatch("[^\n]+") do
      file:write("  " .. line .. "\n")
    end
  end
  file:write("\n")
  file:close()
end

function M.error(source, message, details)
  write_entry("ERROR", source, message, details)
end

function M.warn(source, message, details)
  write_entry("WARN", source, message, details)
end

function M.info(source, message, details)
  write_entry("INFO", source, message, details)
end

-- Drop-in pcall replacement that logs failures
function M.pcall(source, fn, ...)
  local ok, result = pcall(fn, ...)
  if not ok then
    M.error(source, "Unhandled error", result)
  end
  return ok, result
end

-- Intercept vim.notify so ERROR/WARN notifications are also written to the log
function M.install_notify_interceptor()
  local original = vim.notify
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.notify = function(msg, level, opts)
    if level == vim.log.levels.ERROR or level == vim.log.levels.WARN then
      local source = (type(opts) == "table" and opts.title) or "nvim"
      local lvl_str = level == vim.log.levels.ERROR and "ERROR" or "WARN"
      write_entry(lvl_str, source, tostring(msg))
    end
    return original(msg, level, opts)
  end
end

-- After lazy.nvim finishes startup, scan every plugin for a stored .error field
function M.check_lazy_errors()
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    once = true,
    callback = function()
      local ok, lazy_config = pcall(require, "lazy.core.config")
      if not ok then return end
      for _, plugin in pairs(lazy_config.plugins or {}) do
        if plugin._ and plugin._.error then
          M.error(
            "lazy/" .. (plugin.name or "unknown"),
            "Plugin config failed",
            tostring(plugin._.error)
          )
        end
      end
    end,
  })
end

-- :PluginErrors  – open the log file
-- :PluginErrorsClear – wipe the log file
function M.setup_commands()
  vim.api.nvim_create_user_command("PluginErrors", function()
    if vim.fn.filereadable(log_path) == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(log_path))
    else
      vim.notify("No plugin errors logged yet.", vim.log.levels.INFO)
    end
  end, { desc = "View plugin error log" })

  vim.api.nvim_create_user_command("PluginErrorsClear", function()
    local file = io.open(log_path, "w")
    if file then
      file:close()
      vim.notify("Plugin error log cleared.", vim.log.levels.INFO)
    end
  end, { desc = "Clear plugin error log" })
end

function M.get_log_path()
  return log_path
end

return M
