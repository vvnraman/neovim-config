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
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    config = which_key_lazy_config,
  },
  {
    -- https://github.com/mrjones2014/legendary.nvim
    "mrjones2014/legendary.nvim",
    version = "v2.1.0",
    event = "VeryLazy",
    dependencies = { "folke/which-key.nvim" },
    config = function()
      local legendary = require("legendary")
      legendary.setup({
        sort = {
          frecency = false,
        },
        lazy_nvim = { auto_register = true },
        which_key = {
          auto_register = true,
          do_binding = false,
          use_groups = true,
        },
        log_level = "warn",
      })

      require("which-key").register({
        ["k"] = {
          function()
            legendary.find({
              filters = {
                require("legendary.filters").keymaps(),
              },
              formatter = nil,
              select_prompt = "⚡ Legendary: Keymaps ⚡",
            })
          end,
          "legendary: [k]eys",
        },
        ["m"] = {
          function()
            legendary.find({
              filters = {
                require("legendary.filters").keymaps(),
                require("legendary.filters").current_mode(),
              },
              formatter = nil,
              select_prompt = "⚡ Legendary: Keymaps (mode) ⚡",
            })
          end,
          "legendary: [m]ode keys",
        },
      }, { prefix = "<leader>" })
    end,
  },
}

return M
