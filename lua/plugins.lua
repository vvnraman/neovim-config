local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    'git',
    'clone',
    '--depth', '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  }
  print 'Installing packer. Close and reopen Neovim once done...'
  vim.cmd [[packadd packer.nvim]]
end

-- Reload neovim whenever we save plugins.lua
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local ok, packer = pcall(require, 'packer')
if not ok then
  print 'packer.nvim not installed. No plugins will get installed.'
  return
end

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float { border = 'rounded' }
    end
  }
}

return packer.startup(function(use)

  -- Libraries
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'lewis6991/impatient.nvim'

  -- Package management
  use 'wbthomason/packer.nvim'

  -- UI
  use 'folke/tokyonight.nvim' -- colorscheme
  use 'folke/lsp-colors.nvim'
  use 'folke/zen-mode.nvim'
  use 'folke/twilight.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use 'stevearc/dressing.nvim' -- UI hooks
  use {
    'nvim-lualine/lualine.nvim', -- status line
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'akinsho/bufferline.nvim', -- buffers within a tab
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -- Common sense helpers
  use 'windwp/nvim-autopairs'
  use 'numToStr/Comment.nvim'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'

  use 'kyazdani42/nvim-tree.lua'

  -- Legends
  use 'folke/which-key.nvim'
  -- use 'mrjones2014/legendary.nvim'

  -- Movement
  use 'justinmk/vim-sneak'
  use 'Lokaltog/vim-easymotion'

  -- LSP, Snippets, Completions
  use 'hrsh7th/nvim-cmp' -- The completion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- Lsp completion
  use 'hrsh7th/cmp-nvim-lua' -- Neovim lua runtime API completion
  use 'hrsh7th/cmp-buffer' -- buffer completions
  use 'hrsh7th/cmp-path' -- path completions
  use 'hrsh7th/cmp-cmdline' -- cmdline completions
  use 'L3MON4D3/LuaSnip' --snippet engine
  use 'saadparwaiz1/cmp_luasnip' -- snippet completions
  use 'onsails/lspkind-nvim' -- pictograms for lsp completion items
  use 'neovim/nvim-lspconfig' -- enable LSP
  use 'williamboman/nvim-lsp-installer' -- simple to use language server installer
  use 'j-hui/fidget.nvim' -- LSP status endpoint handler

  -- Diagnostics
  use 'folke/trouble.nvim'
  use 'folke/todo-comments.nvim'

  -- Languages
  use 'ziglang/zig.vim'
  use 'tmux-plugins/vim-tmux'

  -- Formatting
  use 'jose-elias-alvarez/null-ls.nvim' -- Formatting engine

  -- Searching
  use 'junegunn/fzf'
  use 'junegunn/fzf.vim'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  use {
    'nvim-telescope/telescope-frecency.nvim',
    requires = {'tami5/sqlite.lua'}
  }
  use 'benfowler/telescope-luasnip.nvim'

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'ray-x/cmp-treesitter'
  -- use 'ray-x/navigator.lua'

  -- Git
  use 'lewis6991/gitsigns.nvim'

  -- Untested
  use 'akinsho/toggleterm.nvim'
  use 'ahmedkhalf/project.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'goolord/alpha-nvim'

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end

end)

