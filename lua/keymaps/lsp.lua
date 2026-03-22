-- /lua/config/lsp.lua

local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Inicializa Mason
mason.setup()

-- LSPs que devem ser instalados automaticamente
local servers = { "clangd", "phpactor", "pyright", "lua_ls" }

-- Configura o mason-lspconfig
mason_lspconfig.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

-- Atalhos padrão ao anexar um LSP
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Ir para definição")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gr", vim.lsp.buf.references, "Referências")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Renomear símbolo")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Ações de código")
  map("n", "[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
  map("n", "]d", vim.diagnostic.goto_next, "Próximo diagnóstico")
  
end

-- Configuração básica para cada servidor
mason_lspconfig.setup_handlers {
  function(server_name)
    lspconfig[server_name].setup {
      on_attach = on_attach,
    }
  end,
}
