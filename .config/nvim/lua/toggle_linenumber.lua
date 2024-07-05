-- Function to toggle line numbers
function _G.toggle_line_numbers()
  if vim.wo.relativenumber then
    vim.wo.relativenumber = false
    vim.wo.number = true
  else
    vim.wo.relativenumber = true
    vim.wo.number = true
  end
end

-- Key mapping to toggle line numbers
vim.api.nvim_set_keymap('n', '|', ':lua toggle_line_numbers()<CR>', { noremap = true, silent = true })
