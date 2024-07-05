return {
  {
    "karb94/neoscroll.nvim",
    enabled = true,
    event = "BufWinEnter",
    config = function()
      require "configs.neoscroll"
    end,
  }
}
