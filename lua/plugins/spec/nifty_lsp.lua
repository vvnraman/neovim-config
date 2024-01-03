local M = {
  {
    -- https://github.com/j-hui/fidget.nvim
    "j-hui/fidget.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },
  {
    -- https://github.com/ray-x/lsp_signature.nvim
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
    },
    opts = {
      close_timeout = 1500,
      transparency = 15,
      toggle_key = "<M-k>",
      select_signature_key = "<M-n>",
    },
  },
  {
    -- https://github.com/simrat39/symbols-outline.nvim
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = true,
    enabled = false,
  },
}

return M
