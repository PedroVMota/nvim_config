-- /lua/keymaps/lsp.lua

local log = require("lib.logger")

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
  log.error("lsp/mason", "Failed to load mason.nvim", mason)
else
  local ok_setup, err = pcall(mason.setup)
  if not ok_setup then
    log.error("lsp/mason", "mason.setup() failed", err)
  end
end

-- LSPs que devem ser instalados automaticamente
local servers = {
  "clangd",       -- C/C++
  "gopls",        -- Go
  "lua_ls",       -- Lua
  "phpactor",     -- PHP
  "pyright",      -- Python
  "rust_analyzer", -- Rust
  "terraformls",  -- Terraform
  "yamlls",       -- YAML / GitHub Actions
}

-- Atalhos padrão ao anexar um LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data and args.data.client_id)
    local client_name = (client and client.name) or "unknown"

    local ok, err = pcall(function()
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "gd", vim.lsp.buf.definition, "Ir para definição")
      map("n", "K", vim.lsp.buf.hover, "Hover")
      map("n", "gr", vim.lsp.buf.references, "Referências")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Ações de código")
      map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
      map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Próximo diagnóstico")
    end)

    if not ok then
      log.error("lsp/attach/" .. client_name, "LspAttach keybind setup failed", err)
    end
  end,
})

-- Configuração específica por servidor
local server_settings = {
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://json.schemastore.org/github-action.json"] = "/action.{yml,yaml}",
        },
        validate = true,
        completion = true,
        hover = true,
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        cargo = { allFeatures = true },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
}

-- Configuração para cada servidor usando a API nativa do Neovim 0.11+
for _, server_name in ipairs(servers) do
  local ok, err = pcall(vim.lsp.config, server_name, server_settings[server_name] or {})
  if not ok then
    log.error("lsp/config/" .. server_name, "vim.lsp.config() failed", err)
  end
end

local ok_enable, err_enable = pcall(vim.lsp.enable, servers)
if not ok_enable then
  log.error("lsp/enable", "vim.lsp.enable() failed", err_enable)
end
