return {
    'lewis6991/gitsigns.nvim',
    event = { "BufRead", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '+' },
            change       = { text = '~' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
        },
        numhl = false,  -- disable number highlight
    },
}