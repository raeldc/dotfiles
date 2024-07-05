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
   		ensure_installed = {
   			"lua-language-server", "stylua",
   			"html-lsp", "css-lsp" , "prettier"
   		},
    },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    after = "mason.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "eslint", "tsserver"}
      })
    end,
  },
  { 'mfussenegger/nvim-dap'},
  {
    "nvim-treesitter/nvim-treesitter",
    after = "mason.nvim",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
      },
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = '^4',
    lazy = false
  }
}
