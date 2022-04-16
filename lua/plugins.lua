local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth", "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Install packer. Close and reopen Neovim once done..."
  vim.cmd [[packadd packer.nvim]]
end

-- Reload neovim whenever we save plugins.lua
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local ok, packer = pcall(require, "packer")
if not ok then
  print "packer.nvim not installed. No plugins will get installed."
  return
end

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end
  }
}

return packer.startup(function(use)

  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"
  use "nvim-lua/plenary.nvim"
  use "windwp/nvim-autopairs"
  use "numToStr/Comment.nvim"

  use 'folke/tokyonight.nvim'

  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end

end)

