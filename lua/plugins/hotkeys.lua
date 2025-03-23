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

  local tab_prefix = function(desc)
    return { desc = "tab: " .. desc, noremap = true }
  end

  which_key.add({ "<leader>", group = "VISUAL <leader>", mode = "v" })

  vim.keymap.set("n", "<leader><leader>w", "<Cmd>WhichKey<Cr>", { desc = "Which Key" })
  -- Document existing mappings
  which_key.add({
    { "<leader>c_", group = "code | colour ", hidden = true },
    { "<leader>d_", group = "peek definition", hidden = true },
    { "<leader>r_", group = "rename", hidden = true },
  })

  vim.keymap.set("n", "]t", ":tabn<CR>", tab_prefix("→ Right "))
  vim.keymap.set("n", "[t", ":tabp<CR>", tab_prefix("← Left"))

  vim.keymap.set("n", "<leader>k", ":+tabmove<CR>", tab_prefix("↜ Move to Prev"))
  vim.keymap.set("n", "<leader>j", ":-tabmove<CR>", tab_prefix("↝ Move to Next"))
end

local M = {
  {
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    config = which_key_lazy_config,
  },
}

return M
