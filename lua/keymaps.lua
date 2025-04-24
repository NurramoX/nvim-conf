-- List of keys to remove


local keys_to_remove = {
-- for ghostty 
  "<C-S-h>",
  "<C-S-j>",
  "<C-S-k>",
  "<C-S-l>",
  "<C-S-a>",
  "<C-a>",

-- for personal use :D
  "<C-h>",
  "<C-j>",
  "<C-k>",
  "<C-l>",
  "<C-S-p>",
  "<C-S-n>",
  "<C-Space>",
  "<C-Tab>",
  "<C-S-w>",
  "<C-w>",
  "<C-t>",
  "<C-T>",
  "<C-S-o>",
  "<C-S-i>",
  "gd"
}



-- List of modes to remove mappings from
local modes = {"n", "v", "x", "s", "i", "o", "c", "t"}


-- Remove each key in each mode
for _, mode in ipairs(modes) do
  for _, key in ipairs(keys_to_remove) do
    pcall(vim.keymap.del, mode, key)
  end
end


vim.keymap.set('n', '<C-i>', '<Nop>')
vim.keymap.set('n', '<C-o>', '<Nop>')

-- Navigate between buffers using Ctrl+Shift+H/J/K/L
vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap = true, silent = true, desc = "Go to previous buffer"})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap = true, silent = true, desc = "Go to next buffer"})
vim.keymap.set("n", "<C-j>", "<C-w>j", {noremap = true, silent = true, desc = "Go to last buffer"})
vim.keymap.set("n", "<C-k>", "<C-w>k", {noremap = true, silent = true, desc = "Go to first buffer"})

-- vim.keymap.set('n', '<C-b>', function() print('hello world') end)

-- user commands
-- Create custom commands for splits with uppercase names
vim.api.nvim_create_user_command('Hs', function(opts)
  if opts.args and opts.args ~= "" then
    vim.cmd('split ' .. opts.args)
  else
    vim.cmd('split')
  end
end, { nargs = '?', complete = 'file', desc = 'Horizontal split' })

vim.api.nvim_create_user_command('Vs', function(opts)
  if opts.args and opts.args ~= "" then
    vim.cmd('vsplit ' .. opts.args)
  else
    vim.cmd('vsplit')
  end
end, { nargs = '?', complete = 'file', desc = 'Vertical split' })

vim.cmd([[
  cnoreabbrev hs Hs
  cnoreabbrev vs Vs
]])

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>tp', function() vim.cmd('InspectTree') end, { desc = 'Open [T]reesitter [P]lugin' })
