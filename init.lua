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
local profile = require("vvn.profile")
-------------------------------------------------------------------------------

--  Leader must be set before plugins are required (otherwise wrong leader will
--  be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-------------------------------------------------------------------------------

-- https://github.com/folke/lazy.nvim?tab=readme-ov-file#-installation
local lazy_root = profile.get_lazy_install_root_dir()
local lazypath = vim.fs.joinpath(lazy_root, "lazy.nvim")
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
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
  root = lazy_root,
  spec = {
    { import = "plugins.dev" }, -- first
    { import = "plugins.snacks" }, -- second
    { import = "plugins.pde.cmp" },
    { import = "plugins.pde.lsp" },
    { import = "plugins.pde.nifty" },
    { import = "plugins.persona.outfit" },
    { import = "plugins.persona.theme" },
    { import = "plugins.persona.concierge" },
    { import = "plugins.persona.physique" },
    { import = "plugins.author" },
    { import = "plugins.git" },
    { import = "plugins.hotkeys" },
    { import = "plugins.expedition.cardio" },
    { import = "plugins.expedition.rucking" },
    { import = "plugins.expedition.telescope" },
    { import = "plugins.treesitter.config" },
    { import = "plugins.quagmire.trouble" },
    { import = "plugins.quagmire.quicker" },
    { import = "plugins.override" },
    { import = "plugins.session" },
    { import = "plugins.ai" },
  },
  defaults = {
    version = "*",
  },
})
-------------------------------------------------------------------------------

-- These come later as I use some plugins in the mappings as well.
require("options")
require("keymaps")
require("autocommands")
require("vvn.yank").setup()
-------------------------------------------------------------------------------
