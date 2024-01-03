--[[===========================================================================
Neovim automatically adds a 'lua' folder, if present here, to be available in
vim's runtimepath. This allows us to import the files and folders in the `lua`
directory as lua modules as we're doing below.

We also don't need to refer to them by their full path which includes '.lua',
we can omit the extension. This is standard lua setup.

On top of this, we can also `require` a folder as long as it has an 'init.lua'
inside the folder. Its the job of that 'init.lua' file to 'require' any other
sub-modules inside the folder.
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
require("lazy").setup("plugins.spec")

-------------------------------------------------------------------------------
require("options")
require("mappings")
require("autocommands")

-------------------------------------------------------------------------------
