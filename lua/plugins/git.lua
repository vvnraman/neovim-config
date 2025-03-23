local gitsigns_on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  local which_key = require("which-key")

  --[[
  Keymaps copied from
  https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#keymaps
  --]]

  -- Navigation
  vim.keymap.set("n", "]c", function()
    if vim.wo.diff then
      return "]c"
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return "<Ignore>"
  end, { desc = "Git hunk: next", buffer = bufnr, expr = true })
  vim.keymap.set("n", "[c", function()
    if vim.wo.diff then
      return "[c"
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return "<Ignore>"
  end, { "Git hunk: previous", buffer = bufnr, expr = true })

  local h_desc = function(desc)
    return { desc = "Git [h]unk: " .. desc, buffer = bufnr }
  end
  local g_desc = function(desc)
    return { desc = "[g]it: " .. desc, buffer = bufnr }
  end

  which_key.add({ "<leader>h", group = "+Git [h]unk" })

  vim.keymap.set("n", "<leader>hs", gs.stage_hunk, h_desc("[s]tage"))
  vim.keymap.set("v", "<leader>hs", function()
    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, h_desc("[s]tage"))

  vim.keymap.set("n", "<leader>hr", gs.reset_hunk, h_desc("[r]reset"))
  vim.keymap.set("v", "<leader>hr", function()
    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
  end, h_desc("[r]eset"))

  vim.keymap.set("n", "<leader>gs", gs.stage_buffer, g_desc("[s]tage buffer"))
  vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, h_desc("[u]ndo"))
  vim.keymap.set("n", "<leader>gr", gs.reset_buffer, g_desc("[r]eset buffer"))
  vim.keymap.set("n", "<leader>hp", gs.preview_hunk, h_desc("[p]review"))
  vim.keymap.set("n", "<leader>hi", gs.preview_hunk_inline, h_desc("[i]nline preview"))
  vim.keymap.set("n", "<leader>hb", function()
    gs.blame_line({ full = true })
  end, h_desc("[b]lame"))
  vim.keymap.set("n", "<leader>gd", gs.diffthis, g_desc("[d]iff - index"))
  vim.keymap.set("n", "<leader>gc", function()
    gs.diffthis("~")
  end, g_desc("diff - [c]ommit"))
  vim.keymap.set("n", "<leader>ht", gs.toggle_current_line_blame, h_desc("[t]oggle blame"))
  vim.keymap.set("n", "<leader>hd", gs.toggle_deleted, h_desc("toggle [d]eleted"))
  vim.keymap.set("n", "<leader>hw", gs.toggle_word_diff, h_desc("toggle [w]ord"))

  -- Text object
  vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", g_desc("inside hunk"))
end

local M = {
  {
    -- https://github.com/tpope/vim-fugitive
    "tpope/vim-fugitive",
  },
  {
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        on_attach = gitsigns_on_attach,
      })
    end,
    dependencies = { "folke/which-key.nvim" },
  },
}

return M
