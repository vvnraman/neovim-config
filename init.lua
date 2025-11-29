--[[===========================================================================
Neovim automatically adds a 'lua' folder, if present here, to be available in
vim's runtimepath. This allows us to import the files and folders in the `lua`
directory as lua modules as we're doing below.

- We don't need to refer to them by their full path which includes '.lua',
  this is standard lua setup.
- We can `require()` a folder as long as it has an 'init.lua' inside. Its the
  job of that `init.lua` file to `require()` any other sub-modules inside.
  When doing so, the `require` path should always be fully qualified.
--]]
-------------------------------------------------------------------------------

require("globals")
-------------------------------------------------------------------------------

--  Leader must be set before plugins are required (otherwise wrong leader will
--  be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-------------------------------------------------------------------------------

-- https://github.com/folke/lazy.nvim?tab=readme-ov-file#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  require("plugins.dev"),
  require("plugins.pde.cmp"),
  require("plugins.pde.lsp"),
  require("plugins.pde.nifty"),
  require("plugins.persona.outfit"),
  require("plugins.persona.theme"),
  require("plugins.persona.concierge"),
  require("plugins.persona.physique"),
  require("plugins.author"),
  require("plugins.git"),
  require("plugins.hotkeys"),
  require("plugins.expedition.cardio"),
  require("plugins.expedition.rucking"),
  require("plugins.expedition.telescope"),
  require("plugins.treesitter.config"),
  require("plugins.quagmire.trouble"),
  require("plugins.quagmire.quicker"),
})
-------------------------------------------------------------------------------

-- These come later as I use some plugins in the mappings as well.
require("options")
require("keymaps")
require("autocommands")
-------------------------------------------------------------------------------
