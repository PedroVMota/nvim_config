-- NewEraNeovim Function Library
-- A collection of reusable utility functions for Neovim configuration.
-- Usage: local lib = require("lib")

local M = {}

-- ============================================================================
-- Keymap Helpers
-- ============================================================================
M.keymap = {}

--- Set a keymap with sensible defaults (noremap + silent).
---@param mode string|table Mode(s) for the keymap ("n", "i", "v", {"n","v"}, etc.)
---@param lhs string Left-hand side of the mapping
---@param rhs string|function Right-hand side of the mapping
---@param desc? string Description for which-key
---@param extra_opts? table Additional options to merge
function M.keymap.set(mode, lhs, rhs, desc, extra_opts)
  local opts = { noremap = true, silent = true }
  if desc then
    opts.desc = desc
  end
  if extra_opts then
    opts = vim.tbl_extend("force", opts, extra_opts)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Set a normal-mode keymap.
---@param lhs string
---@param rhs string|function
---@param desc? string
function M.keymap.n(lhs, rhs, desc)
  M.keymap.set("n", lhs, rhs, desc)
end

--- Set an insert-mode keymap.
---@param lhs string
---@param rhs string|function
---@param desc? string
function M.keymap.i(lhs, rhs, desc)
  M.keymap.set("i", lhs, rhs, desc)
end

--- Set a visual-mode keymap.
---@param lhs string
---@param rhs string|function
---@param desc? string
function M.keymap.v(lhs, rhs, desc)
  M.keymap.set("v", lhs, rhs, desc)
end

--- Set a terminal-mode keymap.
---@param lhs string
---@param rhs string|function
---@param desc? string
function M.keymap.t(lhs, rhs, desc)
  M.keymap.set("t", lhs, rhs, desc)
end

--- Set a buffer-local keymap (useful inside LSP attach callbacks).
---@param bufnr integer Buffer number
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param desc? string
function M.keymap.buf(bufnr, mode, lhs, rhs, desc)
  M.keymap.set(mode, lhs, rhs, desc, { buffer = bufnr })
end

-- ============================================================================
-- Autocmd Helpers
-- ============================================================================
M.autocmd = {}

--- Create an augroup and return its id.
---@param name string Group name
---@param clear? boolean Whether to clear existing (default true)
---@return integer
function M.autocmd.group(name, clear)
  if clear == nil then
    clear = true
  end
  return vim.api.nvim_create_augroup(name, { clear = clear })
end

--- Create an autocmd with a simpler interface.
---@param event string|table Event(s) to listen for
---@param opts table Options: pattern, group, callback, command, buffer, desc
function M.autocmd.on(event, opts)
  vim.api.nvim_create_autocmd(event, opts)
end

--- Run a callback once when a filetype is opened.
---@param ft string|table Filetype(s)
---@param callback function
---@param desc? string
function M.autocmd.on_ft(ft, callback, desc)
  if type(ft) == "string" then
    ft = { ft }
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = ft,
    callback = callback,
    desc = desc,
  })
end

--- Run a callback when entering a buffer.
---@param callback function
---@param desc? string
function M.autocmd.on_buf_enter(callback, desc)
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = callback,
    desc = desc,
  })
end

-- ============================================================================
-- Buffer Utilities
-- ============================================================================
M.buf = {}

--- Get the current buffer number.
---@return integer
function M.buf.current()
  return vim.api.nvim_get_current_buf()
end

--- Get the full file path of a buffer.
---@param bufnr? integer Buffer number (default: current)
---@return string
function M.buf.name(bufnr)
  return vim.api.nvim_buf_get_name(bufnr or 0)
end

--- Get the filetype of a buffer.
---@param bufnr? integer
---@return string
function M.buf.filetype(bufnr)
  return vim.bo[bufnr or 0].filetype
end

--- Check if a buffer is modified.
---@param bufnr? integer
---@return boolean
function M.buf.is_modified(bufnr)
  return vim.bo[bufnr or 0].modified
end

--- Get the total line count of a buffer.
---@param bufnr? integer
---@return integer
function M.buf.line_count(bufnr)
  return vim.api.nvim_buf_line_count(bufnr or 0)
end

--- Get lines from a buffer.
---@param bufnr? integer
---@param start_line? integer 0-indexed start (default 0)
---@param end_line? integer 0-indexed end (default -1 for all)
---@return string[]
function M.buf.get_lines(bufnr, start_line, end_line)
  return vim.api.nvim_buf_get_lines(bufnr or 0, start_line or 0, end_line or -1, false)
end

--- Close the current buffer without closing the window.
function M.buf.close()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  if #bufs > 1 then
    vim.cmd("bprevious | bdelete #")
  else
    vim.cmd("bdelete")
  end
end

--- Close all buffers except the current one.
function M.buf.close_others()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end

-- ============================================================================
-- Window Utilities
-- ============================================================================
M.win = {}

--- Get the current window number.
---@return integer
function M.win.current()
  return vim.api.nvim_get_current_win()
end

--- Get the width of a window.
---@param winnr? integer
---@return integer
function M.win.width(winnr)
  return vim.api.nvim_win_get_width(winnr or 0)
end

--- Get the height of a window.
---@param winnr? integer
---@return integer
function M.win.height(winnr)
  return vim.api.nvim_win_get_height(winnr or 0)
end

--- Split vertically and optionally open a file.
---@param file? string File path to open in the new split
function M.win.vsplit(file)
  if file then
    vim.cmd("vsplit " .. vim.fn.fnameescape(file))
  else
    vim.cmd("vsplit")
  end
end

--- Split horizontally and optionally open a file.
---@param file? string File path to open in the new split
function M.win.split(file)
  if file then
    vim.cmd("split " .. vim.fn.fnameescape(file))
  else
    vim.cmd("split")
  end
end

--- Close the current window.
function M.win.close()
  vim.api.nvim_win_close(0, false)
end

--- Resize the current window.
---@param width? integer
---@param height? integer
function M.win.resize(width, height)
  if width then
    vim.api.nvim_win_set_width(0, width)
  end
  if height then
    vim.api.nvim_win_set_height(0, height)
  end
end

-- ============================================================================
-- File Utilities
-- ============================================================================
M.file = {}

--- Check if a file or directory exists.
---@param path string
---@return boolean
function M.file.exists(path)
  return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

--- Check if a path is a directory.
---@param path string
---@return boolean
function M.file.is_dir(path)
  return vim.fn.isdirectory(path) == 1
end

--- Get the directory of the current file.
---@return string
function M.file.current_dir()
  return vim.fn.expand("%:p:h")
end

--- Get the filename (without path) of the current file.
---@return string
function M.file.current_name()
  return vim.fn.expand("%:t")
end

--- Get the file extension of the current file.
---@return string
function M.file.current_ext()
  return vim.fn.expand("%:e")
end

--- Get the full path of the current file.
---@return string
function M.file.current_path()
  return vim.fn.expand("%:p")
end

--- Read a file's contents as a string.
---@param path string
---@return string|nil contents, string|nil error
function M.file.read(path)
  local f = io.open(path, "r")
  if not f then
    return nil, "Cannot open file: " .. path
  end
  local content = f:read("*a")
  f:close()
  return content, nil
end

--- Write a string to a file.
---@param path string
---@param content string
---@return boolean success, string|nil error
function M.file.write(path, content)
  local f = io.open(path, "w")
  if not f then
    return false, "Cannot write to file: " .. path
  end
  f:write(content)
  f:close()
  return true, nil
end

-- ============================================================================
-- UI / Notification Helpers
-- ============================================================================
M.ui = {}

--- Show an info notification.
---@param msg string
---@param title? string
function M.ui.info(msg, title)
  vim.notify(msg, vim.log.levels.INFO, { title = title })
end

--- Show a warning notification.
---@param msg string
---@param title? string
function M.ui.warn(msg, title)
  vim.notify(msg, vim.log.levels.WARN, { title = title })
end

--- Show an error notification.
---@param msg string
---@param title? string
function M.ui.error(msg, title)
  vim.notify(msg, vim.log.levels.ERROR, { title = title })
end

--- Prompt the user for input and call a callback with the result.
---@param prompt_text string
---@param callback function Called with the user's input string (or nil if cancelled)
---@param default? string Default value
function M.ui.input(prompt_text, callback, default)
  vim.ui.input({ prompt = prompt_text, default = default }, callback)
end

--- Prompt the user to select from a list.
---@param items table List of items
---@param prompt_text string
---@param callback function Called with the selected item
---@param format_fn? function Optional formatter for display
function M.ui.select(items, prompt_text, callback, format_fn)
  vim.ui.select(items, { prompt = prompt_text, format_item = format_fn }, callback)
end

-- ============================================================================
-- LSP Helpers
-- ============================================================================
M.lsp = {}

--- Check if a LSP client supports a method (compatible with nvim 0.10 and 0.11+).
---@param client vim.lsp.Client
---@param method string
---@param bufnr? integer
---@return boolean
function M.lsp.supports_method(client, method, bufnr)
  if vim.fn.has("nvim-0.11") == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(method, { bufnr = bufnr })
  end
end

--- Get all active LSP clients for a buffer.
---@param bufnr? integer
---@return table[]
function M.lsp.get_clients(bufnr)
  if vim.lsp.get_clients then
    return vim.lsp.get_clients({ bufnr = bufnr or 0 })
  else
    ---@diagnostic disable-next-line: deprecated
    return vim.lsp.get_active_clients({ bufnr = bufnr or 0 })
  end
end

--- Format the current buffer using LSP.
---@param opts? table Options passed to vim.lsp.buf.format
function M.lsp.format(opts)
  vim.lsp.buf.format(opts or { async = true })
end

--- Get diagnostics for a buffer.
---@param bufnr? integer
---@param severity? integer vim.diagnostic.severity.*
---@return table[]
function M.lsp.get_diagnostics(bufnr, severity)
  local filter = {}
  if severity then
    filter.severity = severity
  end
  return vim.diagnostic.get(bufnr or 0, filter)
end

--- Get the count of diagnostics by severity for a buffer.
---@param bufnr? integer
---@return table {errors: integer, warnings: integer, info: integer, hints: integer}
function M.lsp.diagnostic_counts(bufnr)
  bufnr = bufnr or 0
  return {
    errors = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
    warnings = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
    info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }),
    hints = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT }),
  }
end

-- ============================================================================
-- Git Helpers
-- ============================================================================
M.git = {}

--- Check if the current directory is inside a git repository.
---@return boolean
function M.git.is_repo()
  return vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):find("true") ~= nil
end

--- Get the current git branch name.
---@return string|nil
function M.git.branch()
  if not M.git.is_repo() then
    return nil
  end
  local branch = vim.fn.system("git branch --show-current 2>/dev/null")
  return vim.trim(branch)
end

--- Get the git root directory.
---@return string|nil
function M.git.root()
  if not M.git.is_repo() then
    return nil
  end
  local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
  return vim.trim(root)
end

-- ============================================================================
-- Table / Functional Helpers
-- ============================================================================
M.tbl = {}

--- Map a function over a table (returns new table).
---@param t table
---@param fn function
---@return table
function M.tbl.map(t, fn)
  local result = {}
  for i, v in ipairs(t) do
    result[i] = fn(v, i)
  end
  return result
end

--- Filter a table by a predicate (returns new table).
---@param t table
---@param fn function Returns true to keep
---@return table
function M.tbl.filter(t, fn)
  local result = {}
  for _, v in ipairs(t) do
    if fn(v) then
      table.insert(result, v)
    end
  end
  return result
end

--- Check if a value exists in a list-like table.
---@param t table
---@param value any
---@return boolean
function M.tbl.contains(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

--- Merge multiple tables (shallow).
---@param ... table
---@return table
function M.tbl.merge(...)
  return vim.tbl_extend("force", {}, ...)
end

return M
