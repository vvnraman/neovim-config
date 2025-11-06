local which_key_lazy_config = function()
  local which_key = require("which-key")
  which_key.setup({
    replace = {
      ["<Space>"] = "Space",
      ["<Cr>"] = "Enter",
    },
    win = {
      border = "single",
    },
    layout = {
      height = { min = 5, max = 10 },
    },
  })

  which_key.add({ "<leader>", group = "VISUAL <leader>", mode = "v" })

  -- Document existing mappings
  which_key.add({
    { "<leader>c_", group = "code | colour ", hidden = true },
    { "<leader>d_", group = "peek definition", hidden = true },
    { "<leader>r_", group = "rename", hidden = true },
  })

  vim.keymap.set("n", "<leader><leader>w", "<Cmd>WhichKey<Cr>", { desc = "Which Key" })
end

local M = {
  {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    config = which_key_lazy_config,
  },
}

return M
