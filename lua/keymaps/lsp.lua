-- /lua/config/lsp.lua

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
    map("n", "[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
    map("n", "]d", vim.diagnostic.goto_next, "Próximo diagnóstico")
  end,
})

-- Configuração básica para cada servidor usando a API nativa do Neovim 0.11+
for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, {})
end
vim.lsp.enable(servers)
