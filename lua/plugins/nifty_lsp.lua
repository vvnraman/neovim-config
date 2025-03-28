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
      toggle_key = "<M-l>",
      select_signature_key = "<M-e>",
    },
  },
  --[[
  -- Required Neovim version 0.10
  {
    -- https://github.com/Bekaboo/dropbar.nvim
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  } ]]
}

return M
