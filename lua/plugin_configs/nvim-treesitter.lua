-- https://github.com/nvim-treesitter/nvim-treesitter
local ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print '"nvim-treesitter.configs" not available'
  return
end

treesitter_configs.setup({
  ensure_installed = {
    "bash", "c", "cmake", "comment", "cmake", "cpp", "go", "json", "lua",
    "toml", "typescript", "vim", "yaml", "zig"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    -- These are the default keymaps, which I can lookup via help, but still putting
    -- them here for easier access.
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    enable = true
  },
})
