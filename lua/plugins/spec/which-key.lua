local which_key_lazy_config = function()
  local which_key = require("which-key")
  which_key.setup({
    key_labels = {
      ["<Space>"] = "Space",
      ["<Cr>"] = "Enter",
    },
    window = {
      border = "single",
    },
    layout = {
      height = { min = 5, max = 10 },
    },
  })

  local tab_prefix = function(desc)
    return "tab: " .. desc
  end

  which_key.register({
    ["<leader>"] = { name = "VISUAL <leader>" },
  }, { mode = "v" })

  -- Document existing mappings
  which_key.register({
    ["<leader><leader>w"] = { "<Cmd>WhichKey<Cr>", "Which Key" },
    ["<leader><leader>"] = {
      name = "oil | which_key",
      _ = "which_key_ignore",
    },
    ["<leader>c"] = { name = "code | colour ", _ = "which_key_ignore" },
    ["<leader>d"] = { name = "peek definition", _ = "which_key_ignore" },
    ["<leader>r"] = { name = "rename", _ = "which_key_ignore" },
  }, {})

  which_key.register({
    ["]t"] = { ":tabn<CR>", tab_prefix("→ Navigate Right ") },
    ["[t"] = { ":tabp<CR>", tab_prefix("← Navigate Left") },
  }, {})

  which_key.register({
    t = {
      name = "+Tabs",
      ["n"] = { ":$tabnew<CR>", tab_prefix("[n]ew") },
      ["c"] = { ":tabclose<CR>", tab_prefix("[c]lose") },
      ["h"] = { ":tabp<CR>", tab_prefix("← Navigate Left") },
      ["l"] = { ":tabn<CR>", tab_prefix("→ Navigate Right ") },
      ["k"] = { ":+tabmove<CR>", tab_prefix("↜ Move to Prev") },
      ["j"] = { ":-tabmove<CR>", tab_prefix("↝ Move to Next") },
    },
  }, { prefix = "<leader>" })
end

local M = {
  {
    "folke/which-key.nvim",
    config = which_key_lazy_config,
  },
}

return M
