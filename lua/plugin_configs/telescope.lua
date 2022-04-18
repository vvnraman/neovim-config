-- 'nvim-telescope/telescope.nvim'
local ok, telescope = pcall(require, 'telescope')
if not ok then
  print '"nvim-telescope/telescope.nvim" not available'
  return
end
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('frecency')
require('telescope').load_extension('luasnip')

local telescope_builtin = require('telescope.builtin')
local telescope_extensions = require('telescope').extensions

local project_files = function()
  local opts = {}
  local ok = pcall(telescope_builtin.git_files, opts)
  if not ok then telescope_builtin.find_files(opts) end
end

vim.keymap.set({'n'}, '<leader>ff', function() project_files() end)
vim.keymap.set({'n'}, '<leader>fg', function() telescope_builtin.live_grep() end)
vim.keymap.set({'n'}, '<leader>fb', function() telescope_builtin.buffers() end)
vim.keymap.set({'n'}, '<leader>fh', function() telescope_builtin.help_tags() end)

vim.keymap.set({'n'}, '<leader>fq', function() telescope_extensions.frecency.frecency() end)
vim.keymap.set({'n'}, '<leader>fs', function() telescope_extensions.luasnip.luasnip() end)
