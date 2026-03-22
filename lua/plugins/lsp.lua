return {
    -- Suporte a LSP
    { "neovim/nvim-lspconfig" },
  
    -- Gerenciador de LSPs, formatters e linters
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = true,
    },
    { "williamboman/mason-lspconfig.nvim" },
  }