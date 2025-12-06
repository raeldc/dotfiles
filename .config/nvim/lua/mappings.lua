require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- disable arrows
map('n', '<Up>', ':echo "Use k"<CR>', { noremap = true, silent = true })
map('n', '<Down>', ':echo "Use j"<CR>', { noremap = true, silent = true })
map('n', '<Left>', ':echo "Use h"<CR>', { noremap = true, silent = true })
map('n', '<Right>', ':echo "Use l"<CR>', { noremap = true, silent = true })

map('i', '<Up>', '<Esc>:echo "Use k"<CR>', { noremap = true, silent = true })
map('i', '<Down>', '<Esc>:echo "Use j"<CR>', { noremap = true, silent = true })
map('i', '<Left>', '<Esc>:echo "Use h"<CR>', { noremap = true, silent = true })
map('i', '<Right>', '<Esc>:echo "Use l"<CR>', { noremap = true, silent = true })

map('v', '<Up>', ':echo "Use k"<CR>', { noremap = true, silent = true })
map('v', '<Down>', ':echo "Use j"<CR>', { noremap = true, silent = true })
map('v', '<Left>', ':echo "Use h"<CR>', { noremap = true, silent = true })
map('v', '<Right>', ':echo "Use l"<CR>', { noremap = true, silent = true })

-- Disable backspace in normal mode
map('n', '<BS>', ':echo "Backspace is not allowed"<CR>', { noremap = true, silent = true })
map('n', '<Del>', ':echo "Backspace is not allowed"<CR>', { noremap = true, silent = true })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- toggle fold
map("n", "<A-z>", "za")

-- Zed: Insert mode escapes
map("i", "jj", "<ESC>")
map("i", "kk", "<ESC>")
map("i", "uu", "<ESC>")

-- Zed: Save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Zed: Pane Navigation
map("n", "<A-H>", "<C-w>h", { desc = "switch window left" })
map("n", "<A-L>", "<C-w>l", { desc = "switch window right" })
map("n", "<A-J>", "<C-w>j", { desc = "switch window down" })
map("n", "<A-K>", "<C-w>k", { desc = "switch window up" })

-- Zed: Split Panes
map("n", "<leader>L", "<cmd>vsp<CR>", { desc = "split window right" })
map("n", "<leader>J", "<cmd>sp<CR>", { desc = "split window down" })
map("n", "<leader>X", "<cmd>close<CR>", { desc = "close split window" })

-- Zed: Buffer Navigation
map("n", "<A-]>", function() require("nvchad.tabufline").next() end, { desc = "buffer goto next" })
map("n", "<A-[>", function() require("nvchad.tabufline").prev() end, { desc = "buffer goto prev" })
map("n", "<A-P>", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("i", "<A-P>", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<S-Space>", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })

-- Zed: Git Blame
map("n", "<leader>gt", function() require("gitsigns").blame_line() end, { desc = "git blame line" })
