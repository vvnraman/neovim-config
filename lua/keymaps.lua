-- These two are useful for navigating very long lines which wrap around
vim.keymap.set({'n'}, 'j', 'gj', { noremap = true })
vim.keymap.set({'n'}, 'k', 'gk', { noremap = true })

-- Esc on jk as well
vim.keymap.set({'i'}, 'jk', '<Esc>', { noremap = true })

-- Change current working directory to that of the current buffer
vim.keymap.set({'n'}, '<leader>cd', ':cd %:p:h<cr>:pwd<cr>', { noremap = true })

