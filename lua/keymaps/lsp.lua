-- /lua/config/lsp.lua

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Inicializa Mason
mason.setup()

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

-- Configura o mason-lspconfig
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

-- Atalhos padrão ao anexar um LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
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
  vim.lsp.config(server_name, server_settings[server_name] or {})
end
vim.lsp.enable(servers)
