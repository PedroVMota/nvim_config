-- NewEraNeovim Theme & Environment Library
-- Funções para customizar o ambiente visual do Neovim.
-- Usage: local lib = require("lib")

local M = {}

-- Estado interno
local _state = {
  transparent = false,
  colorscheme = "tokyonight",
}

-- ============================================================================
-- Colorscheme
-- ============================================================================
M.theme = {}

--- Aplicar um colorscheme.
---@param name string Nome do colorscheme (ex: "tokyonight", "tokyonight-night", "tokyonight-storm")
function M.theme.set(name)
  local ok, _ = pcall(vim.cmd.colorscheme, name)
  if ok then
    _state.colorscheme = name
  else
    vim.notify("Colorscheme '" .. name .. "' não encontrado", vim.log.levels.WARN)
  end
end

--- Obter o colorscheme atual.
---@return string
function M.theme.get()
  return vim.g.colors_name or _state.colorscheme
end

--- Escolher colorscheme interativamente (via vim.ui.select).
function M.theme.pick()
  local themes = vim.fn.getcompletion("", "color")
  vim.ui.select(themes, { prompt = "Escolher colorscheme:" }, function(choice)
    if choice then
      M.theme.set(choice)
    end
  end)
end

-- ============================================================================
-- Transparência
-- ============================================================================
M.transparency = {}

--- Ativar transparência (fundo transparente).
function M.transparency.enable()
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
  _state.transparent = true
end

--- Desativar transparência (reaplica o colorscheme).
function M.transparency.disable()
  M.theme.set(_state.colorscheme)
  _state.transparent = false
end

--- Toggle transparência.
function M.transparency.toggle()
  if _state.transparent then
    M.transparency.disable()
  else
    M.transparency.enable()
  end
end

--- Verificar se transparência está ativa.
---@return boolean
function M.transparency.is_enabled()
  return _state.transparent
end

-- ============================================================================
-- Highlight Groups
-- ============================================================================
M.hl = {}

--- Definir um highlight group.
---@param group string Nome do grupo (ex: "Comment", "Function")
---@param opts table Opções: fg, bg, bold, italic, underline, sp, etc.
function M.hl.set(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

--- Obter a definição de um highlight group.
---@param group string
---@return table
function M.hl.get(group)
  return vim.api.nvim_get_hl(0, { name = group })
end

--- Definir a cor do foreground de um grupo.
---@param group string
---@param fg string Cor hex (ex: "#ff0000")
function M.hl.set_fg(group, fg)
  local current = M.hl.get(group)
  current.fg = fg
  M.hl.set(group, current)
end

--- Definir a cor do background de um grupo.
---@param group string
---@param bg string Cor hex (ex: "#1a1b26")
function M.hl.set_bg(group, bg)
  local current = M.hl.get(group)
  current.bg = bg
  M.hl.set(group, current)
end

--- Tornar comentários itálicos (ou não).
---@param italic boolean
function M.hl.italic_comments(italic)
  local current = M.hl.get("Comment")
  current.italic = italic
  M.hl.set("Comment", current)
end

--- Aplicar um conjunto de overrides de highlight groups.
---@param overrides table<string, table> Ex: { Comment = { fg = "#888888", italic = true } }
function M.hl.apply(overrides)
  for group, opts in pairs(overrides) do
    M.hl.set(group, opts)
  end
end

-- ============================================================================
-- Cursor & Line
-- ============================================================================
M.cursor = {}

--- Toggle cursorline.
function M.cursor.toggle_cursorline()
  vim.opt.cursorline = not vim.opt.cursorline:get()
end

--- Toggle cursorcolumn.
function M.cursor.toggle_cursorcolumn()
  vim.opt.cursorcolumn = not vim.opt.cursorcolumn:get()
end

--- Definir o estilo do cursor (ex: "block", "ver25", "hor20").
---@param style string Formato guicursor (ex: "n-v-c:block,i-ci-ve:ver25")
function M.cursor.set_style(style)
  vim.opt.guicursor = style
end

-- ============================================================================
-- Números & Gutter
-- ============================================================================
M.numbers = {}

--- Toggle números de linha.
function M.numbers.toggle()
  vim.opt.number = not vim.opt.number:get()
end

--- Toggle números relativos.
function M.numbers.toggle_relative()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end

--- Ativar números absolutos + relativos.
function M.numbers.hybrid()
  vim.opt.number = true
  vim.opt.relativenumber = true
end

--- Desativar todos os números.
function M.numbers.none()
  vim.opt.number = false
  vim.opt.relativenumber = false
end

--- Toggle signcolumn ("yes" / "no").
function M.numbers.toggle_signcolumn()
  if vim.opt.signcolumn:get() == "yes" then
    vim.opt.signcolumn = "no"
  else
    vim.opt.signcolumn = "yes"
  end
end

-- ============================================================================
-- Statusline & Tabline
-- ============================================================================
M.statusline = {}

--- Esconder a statusline.
function M.statusline.hide()
  vim.opt.laststatus = 0
end

--- Mostrar statusline global (uma só para todas as janelas).
function M.statusline.global()
  vim.opt.laststatus = 3
end

--- Mostrar statusline por janela.
function M.statusline.per_window()
  vim.opt.laststatus = 2
end

--- Toggle visibilidade da statusline (0 <-> 3).
function M.statusline.toggle()
  if vim.opt.laststatus:get() == 0 then
    vim.opt.laststatus = 3
  else
    vim.opt.laststatus = 0
  end
end

-- ============================================================================
-- Visual Toggles (opções que afetam a aparência)
-- ============================================================================
M.visual = {}

--- Toggle wrap de linhas.
function M.visual.toggle_wrap()
  vim.opt.wrap = not vim.opt.wrap:get()
end

--- Toggle listchars (caracteres invisíveis).
function M.visual.toggle_listchars()
  vim.opt.list = not vim.opt.list:get()
end

--- Toggle spell checking.
function M.visual.toggle_spell()
  vim.opt.spell = not vim.opt.spell:get()
end

--- Toggle modo escuro / claro (para temas que suportam, ex: tokyonight).
function M.visual.toggle_background()
  if vim.opt.background:get() == "dark" then
    vim.opt.background = "light"
  else
    vim.opt.background = "dark"
  end
end

--- Definir a largura da coluna de cor (colorcolumn).
---@param col string|nil Ex: "80", "100", "80,120" ou nil para desativar
function M.visual.set_colorcolumn(col)
  vim.opt.colorcolumn = col or ""
end

--- Toggle colorcolumn no valor 80.
function M.visual.toggle_colorcolumn()
  if vim.opt.colorcolumn:get()[1] then
    vim.opt.colorcolumn = ""
  else
    vim.opt.colorcolumn = "80"
  end
end

--- Definir o scrolloff (linhas visíveis acima/abaixo do cursor).
---@param lines integer
function M.visual.set_scrolloff(lines)
  vim.opt.scrolloff = lines
end

--- Toggle conceallevel (0 <-> 2), útil para markdown.
function M.visual.toggle_conceal()
  if vim.opt.conceallevel:get() == 0 then
    vim.opt.conceallevel = 2
  else
    vim.opt.conceallevel = 0
  end
end

-- ============================================================================
-- Font (para GUIs como Neovide)
-- ============================================================================
M.font = {}

--- Definir a font da GUI.
---@param name string Nome da font (ex: "JetBrainsMono Nerd Font")
---@param size? integer Tamanho (default 12)
function M.font.set(name, size)
  size = size or 12
  vim.opt.guifont = name .. ":h" .. tostring(size)
end

--- Aumentar o tamanho da font da GUI.
---@param increment? integer (default 1)
function M.font.increase(increment)
  increment = increment or 1
  local current = vim.opt.guifont:get()
  local name, size = current:match("(.+):h(%d+)")
  if name and size then
    vim.opt.guifont = name .. ":h" .. tostring(tonumber(size) + increment)
  end
end

--- Diminuir o tamanho da font da GUI.
---@param decrement? integer (default 1)
function M.font.decrease(decrement)
  decrement = decrement or 1
  local current = vim.opt.guifont:get()
  local name, size = current:match("(.+):h(%d+)")
  if name and size then
    local new_size = math.max(6, tonumber(size) - decrement)
    vim.opt.guifont = name .. ":h" .. tostring(new_size)
  end
end

return M
