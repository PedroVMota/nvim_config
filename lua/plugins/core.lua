return {
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        config = function()
          require("tokyonight").setup({
            transparent = true, -- true if you want background color or not 
          })
          vim.cmd("colorscheme tokyonight")
        end,
      }
  }
