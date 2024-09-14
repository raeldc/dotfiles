return {
    {
        "rust-lang/rust.vim",
        ft = "rust",
        event = "BufWinEnter",
        config = function()
            vim.g.rustfmt_autosave = 1
        end,
    },
    {
        "neovim/nvim-lspconfig",
        after = "mason-lspconfig",
        lazy = false,
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require "configs.lspconfig"
            require "configs.ide"
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
        },
    },
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        after = "mason.nvim",
    },
    { 'mfussenegger/nvim-dap' },
    {
        "nvim-treesitter/nvim-treesitter",
        after = "mason.nvim",
    },
    {
        "mrcjkb/rustaceanvim",
        version = '^4',
        lazy = false
    }
}
