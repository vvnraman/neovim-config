-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.

local unmap_unimpaired_mappings = function()
  -- From `:help news`, which would become `:help news-0.11` later
  -- • Mappings inspired by Tim Pope's vim-unimpaired:
  --   • |[q|, |]q|, |[Q|, |]Q|, |[CTRL-Q|, |]CTRL-Q| navigate through the |quickfix| list
  --   • |[l|, |]l|, |[L|, |]L|, |[CTRL-L|, |]CTRL-L| navigate through the |location-list|
  --   • |[t|, |]t|, |[T|, |]T|, |[CTRL-T|, |]CTRL-T| navigate through the |tag-matchlist|
  --   • |[a|, |]a|, |[A|, |]A| navigate through the |argument-list|
  --   • |[b|, |]b|, |[B|, |]B| navigate through the |buffer-list|
  --   • |[<Space>|, |]<Space>| add an empty line above and below the cursor
  local del = function(key)
    local ukey = vim.fn.toupper(key)
    vim.keymap.del("n", "]" .. key)
    vim.keymap.del("n", "]" .. ukey)
    vim.keymap.del("n", "[" .. key)
    vim.keymap.del("n", "[" .. ukey)
  end
  del("a")
  del("b")
  del("t")
end

local setup_sensible_mappings = function()
  -- Esc on jk as well
  vim.keymap.set("i", "jk", "<Esc>", NOREMAP("Alias for <Esc> key"))

  -- Purge selection into black hole and paste over it
  vim.keymap.set(
    "x",
    "<leader>p",
    [["_dP]],
    NOREMAP("Put selection in black hole before pasting")
  )

  -- Move lines
  vim.keymap.set("i", "<C-j>", "<Esc><Cmd>m .+1<Cr>==gi", { desc = "Move lines down" })
  vim.keymap.set("i", "<C-k>", "<Esc><Cmd>m .-2<Cr>==gi", { desc = "Move lines up" })
  vim.keymap.set("n", "<C-j>", "<cmd>m .+1<Cr>==", { desc = "Move lines down" })
  vim.keymap.set("n", "<C-k>", "<cmd>m .-2<Cr>==", { desc = "Move lines up" })
  vim.keymap.set("v", "<C-j>", ":m '>+1<Cr>gv=gv", { desc = "Move lines down" })
  vim.keymap.set("v", "<C-k>", ":m '<-2<Cr>gv=gv", { desc = "Move lines up" })

  -- Remap arrow keys for dealing with word wrap
  vim.keymap.set({ "n", "x" }, "<Up>", "gk", NOREMAP_SILENT("Move <Up> in wrapped lines"))
  vim.keymap.set("i", "<Up>", "<C-o>gk", NOREMAP_SILENT("Move <Up> in wrapped lines"))
  vim.keymap.set({ "n", "x" }, "<Down>", "gj", NOREMAP_SILENT("Move <Down> in wrapped lines"))
  vim.keymap.set("i", "<Down>", "<C-o>gj", NOREMAP_SILENT("Move <Down> in wrapped lines"))

  -- When scrolling using CTRL D/U, put the screen in center
  vim.keymap.set("n", "<C-u>", "<C-u>zz", NOREMAP_SILENT("Scroll half-up with centered screen"))
  vim.keymap.set("n", "<C-d>", "<C-d>zz", NOREMAP_SILENT("Scroll half-up with centered screen"))

  vim.keymap.set("n", "\\i", function()
    Snacks.notifier.notify(vim.api.nvim_buf_get_name(0), "info", { title = "Current Buffer" })
  end, NOREMAP("Show current buffer path"))
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
  -- Cycle through windows in a tab
  vim.keymap.set("n", "<Tab>", "<C-W>w", NOREMAP("Next window in tab"))
  vim.keymap.set("n", "<S-Tab>", "<C-W>W", NOREMAP("Previous window in tab"))

  vim.keymap.set("n", "]t", ":tabn<CR>", NOREMAP("→ Next Tab"))
  vim.keymap.set("n", "[t", ":tabp<CR>", NOREMAP("← Prev Tab"))

  vim.keymap.set("n", "<leader>th", ":-tabmove<CR>", NOREMAP("↝ Move Tab Left"))
  vim.keymap.set("n", "<leader>tl", ":+tabmove<CR>", NOREMAP("↜ Move Tab Right"))
end

local setup_lua_dev_mappings = function()
  -- Got these from Tj's video
  --  - "Everything You Need To Start Writing Lua"
  --  - https://www.youtube.com/watch?v=CuWfgiwI73Q

  vim.keymap.set(
    "n",
    "<leader><leader>n",
    "<Cmd>source %<Cr>",
    { desc = "Config: reload current lua file" }
  )
  vim.keymap.set("n", "<leader>nr", ":.lua<Cr>", { desc = "Config: reload current line" })
  vim.keymap.set("v", "<leader>nr", ":lua<Cr>", { desc = "Config: reload current line" })
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

unmap_unimpaired_mappings()
setup_sensible_mappings()
setup_window_mappings()
setup_tab_mapping()
setup_lua_dev_mappings()
setup_quick_edit_locations()
setup_plugin_mappings()
