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


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
