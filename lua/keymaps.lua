-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.

local setup_sensible_mappings = function()
  -- Esc on jk as well
  vim.keymap.set("i", "jk", "<Esc>", NOREMAP("Escape using jk"))

  -- Purge selection into black hole and paste over it
  vim.keymap.set("x", "<leader>p", [["_dP]])

  -- Move lines
  vim.keymap.set("i", "<C-j>", "<Esc><Cmd>m .+1<Cr>==gi", { desc = "Move down" })
  vim.keymap.set("i", "<C-k>", "<Esc><Cmd>m .-2<Cr>==gi", { desc = "Move up" })
  vim.keymap.set("n", "<C-j>", "<cmd>m .+1<Cr>==", { desc = "Move down" })
  vim.keymap.set("n", "<C-k>", "<cmd>m .-2<Cr>==", { desc = "Move up" })
  vim.keymap.set("v", "<C-j>", ":m '>+1<Cr>gv=gv", { desc = "Move down" })
  vim.keymap.set("v", "<C-k>", ":m '<-2<Cr>gv=gv", { desc = "Move up" })

  -- Remap for dealing with word wrap
  vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- When scrolling using CTRL F/D/U, put the screen in center
  vim.keymap.set("n", "<C-f>", "<C-f>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "<C-d>", "<C-d>zz")

  vim.keymap.set("n", "\\i", function()
    Snacks.notifier.notify(vim.api.nvim_buf_get_name(0), "info", { title = "Current Buffer" })
  end, { desc = "Show current buffer path", noremap = true })
end

local setup_window_mappings = function()
  -- Resize with arrows
  vim.keymap.set("n", "<C-Up>", "<Cmd>resize -4<Cr>", NOREMAP("Resize window ⬆️ by 4"))
  vim.keymap.set("n", "<C-Down>", "<Cmd>resize +4<Cr>", NOREMAP("Resize window ⬇️ by 4"))
  vim.keymap.set(
    "n",
    "<C-Left>",
    "<Cmd>vertical resize -4<Cr>",
    NOREMAP("Resize window ⬅️ by 4")
  )
  vim.keymap.set(
    "n",
    "<C-Right>",
    "<Cmd>vertical resize +4<Cr>",
    NOREMAP("Resize window ➡️ by 4")
  )
end

local setup_tab_mapping = function()
  local tab_prefix = function(desc)
    return { desc = "tab: " .. desc, noremap = true }
  end

  -- Cycle through windows in a tab
  vim.keymap.set("n", "<Tab>", "<C-W>w", NOREMAP("Next window in tab"))
  vim.keymap.set("n", "<S-Tab>", "<C-W>W", NOREMAP("Previous window in tab"))

  vim.keymap.set("n", "]t", ":tabn<CR>", tab_prefix("→ Next"))
  vim.keymap.set("n", "[t", ":tabp<CR>", tab_prefix("← Prev"))

  vim.keymap.set("n", "<leader>th", ":-tabmove<CR>", tab_prefix("↝ Move Left"))
  vim.keymap.set("n", "<leader>tl", ":+tabmove<CR>", tab_prefix("↜ Move Right"))
end

local setup_lua_dev_mappings = function()
  -- Got these from Tj's video
  --  - "Everything You Need To Start Writing Lua"
  --  - https://www.youtube.com/watch?v=CuWfgiwI73Q

  vim.keymap.set(
    "n",
    "<leader><leader>n",
    "<Cmd>source %<Cr>",
    { desc = "Config: [r]eload file" }
  )
  vim.keymap.set("n", "<leader>nr", ":.lua<Cr>", { desc = "Config: [r]eload line" })
  vim.keymap.set("v", "<leader>nr", ":lua<Cr>", { desc = "Config: [r]eload line" })
end

local setup_quick_edit_locations = function()
  -- A lot of these have been setup under telescope as they have multiple files
  vim.keymap.set(
    "n",
    "<leader>es",
    "<Cmd>tabe ~/.config/starship/starship.toml<Cr>",
    { desc = "Open starship config", noremap = true }
  )
end

local setup_plugin_mappings = function()
  -- https://github.com/nvzone/minty
  vim.keymap.set(
    "n",
    "<leader>cs",
    "<Cmd>Shades<Cr>",
    { desc = "[c]olor [s]hades", noremap = true }
  )
  vim.keymap.set(
    "n",
    "<leader>ch",
    "<Cmd>Huefy<Cr>",
    { desc = "[c]olor [h]ues", noremap = true }
  )
end

setup_sensible_mappings()
setup_window_mappings()
setup_tab_mapping()
setup_lua_dev_mappings()
setup_quick_edit_locations()
setup_plugin_mappings()
