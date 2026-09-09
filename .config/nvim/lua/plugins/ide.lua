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
        opts = {
            ensure_installed = {
                "cssls",
                "eslint",
                "gopls",
                "html",
                "lua_ls",
                "pyright",
                "ts_ls",
            },
        },
    },
    { 'mfussenegger/nvim-dap' },
    {
        "nvim-treesitter/nvim-treesitter",
        after = "mason.nvim",
        -- extend (not replace) NvChad's ensure_installed list
        opts_extend = { "ensure_installed" },
        opts = {
            -- parsers are picked up by NvChad's FileType autocmd, which calls
            -- vim.treesitter.start() natively; gopls adds semantic tokens
            ensure_installed = { "go", "gomod", "gosum", "gowork" },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        version = '^4',
        lazy = false
    }
}
