
-- Map space to leader
vim.g.mapleader = " "

-- Map Enter to create a new line below the current line in normal mode
vim.api.nvim_set_keymap('n', '<CR>', 'o<ESC>', { noremap = true, silent = true })

-- Mapping selected movement
vim.keymap.set("v", "<C-J>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-K>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-H>", "<gv")
vim.keymap.set("v", "<C-L>", ">gv")

vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', { noremap = true, silent = true })

-- Copy to system clipboard in visual mode
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })

-- Paste from system clipboard in normal mode
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
