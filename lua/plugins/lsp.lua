return {
    -- Suporte a LSP
    { "neovim/nvim-lspconfig" },
  
    -- Gerenciador de LSPs, formatters e linters
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = true,
    },
    {
      "j-hui/fidget.nvim",
      event = "LspAttach",
      opts = {},
    },
  }