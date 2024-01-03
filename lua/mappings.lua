-- Only generic keymaps are set here. Most of the other ones are set alongside
-- the corresponding plugin setup.

-- Esc on jk as well
vim.keymap.set({ "i" }, "jk", "<Esc>", NOREMAP("Escape using jk"))

-- Resize with arrows
vim.keymap.set(
  { "n" },
  "<C-Up>",
  "<Cmd>resize -4<Cr>",
  NOREMAP("Resize window ⬆️ by 4")
)
vim.keymap.set(
  { "n" },
  "<C-Down>",
  "<Cmd>resize +4<Cr>",
  NOREMAP("Resize window ⬇️ by 4")
)
vim.keymap.set(
  { "n" },
  "<C-Left>",
  "<Cmd>vertical resize -4<Cr>",
  NOREMAP("Resize window ⬅️ by 4")
)
vim.keymap.set(
  { "n" },
  "<C-Right>",
  "<Cmd>vertical resize +4<Cr>",
  NOREMAP("Resize window ➡️ by 4")
)

-- Remap for dealing with word wrap
vim.keymap.set(
  "n",
  "k",
  "v:count == 0 ? 'gk' : 'k'",
  { expr = true, silent = true }
)
vim.keymap.set(
  "n",
  "j",
  "v:count == 0 ? 'gj' : 'j'",
  { expr = true, silent = true }
)
