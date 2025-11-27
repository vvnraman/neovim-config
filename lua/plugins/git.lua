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
  end, { desc = "Git hunk: previous", buffer = bufnr, expr = true })

  local help = function(desc)
    return { desc = "Git [h]unk: " .. desc, buffer = bufnr }
  end

  which_key.add({ "<leader>h", group = "+Git [h]unk" })

  vim.keymap.set("n", "<leader>hs", gs.stage_hunk, help("[s]tage"))
  vim.keymap.set("n", "<leader>hr", gs.reset_hunk, help("[r]reset"))
  vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, help("[u]ndo"))
  vim.keymap.set("n", "<leader>hS", gs.stage_buffer, help("[S]tage buffer"))
  vim.keymap.set("n", "<leader>hR", gs.reset_buffer, help("[R]eset buffer"))
  vim.keymap.set("n", "<leader>hp", gs.preview_hunk, help("[p]review"))
  vim.keymap.set("n", "<leader>hi", gs.preview_hunk_inline, help("[i]nline preview"))
  vim.keymap.set("n", "<leader>hb", function()
    gs.blame_line({ full = true })
  end, help("[b]lame"))
  vim.keymap.set("n", "<leader>hd", gs.diffthis, help("[d]iff - index"))
  vim.keymap.set("n", "<leader>hD", function()
    gs.diffthis("~")
  end, help("[D]iff - commit"))

  -- Toggles
  vim.keymap.set("n", "<leader>hl", gs.toggle_current_line_blame, help("toggle [l]ine blame"))
  vim.keymap.set("n", "<leader>hL", gs.toggle_linehl, help("toggle [L]ine highlight"))
  vim.keymap.set("n", "<leader>hd", gs.toggle_deleted, help("toggle [d]eleted"))

  -- Text object
  vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", help("[i]nside hunk"))
end

local diffview_config = function()
  local toggle_dv = function(cmd)
    if next(require("diffview.lib").views) == nil then
      vim.cmd(cmd)
    else
      vim.cmd("DiffviewClose")
    end
  end

  require("diffview").setup({
    keymaps = {
      view = {
        -- The `view` bindings are active in the diff buffers, only when the current
        -- tabpage is a Diffview.
        { "n", "q", require("diffview.actions").close, { desc = "Close help menu" } },
      },
      file_panel = {
        { "n", "q", "<Cmd>DiffviewClose<Cr>", { desc = "Close help menu" } },
      },
      file_history_panel = {
        { "n", "q", "<Cmd>DiffviewClose<Cr>", { desc = "Close help menu" } },
      },
    },
  })

  vim.keymap.set("n", "<leader>gd", function()
    toggle_dv("DiffviewOpen")
  end, { desc = "[g]it [d]iff index" })
  vim.keymap.set("n", "<leader>gf", function()
    toggle_dv("DiffviewFileHistory")
  end, { desc = "[g]it diff [f]ile" })
  vim.keymap.set("n", "<leader>gm", function()
    toggle_dv("DiffviewOpen master..HEAD")
  end, { desc = "[g]it diff [m]aster" })
  vim.keymap.set("n", "<leader>gn", function()
    toggle_dv("DiffviewOpen main..HEAD")
  end, { desc = "[g]it diff mai[n]" })
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
  {
    -- https://github.com/sindrets/diffview.nvim
    "sindrets/diffview.nvim",
    config = diffview_config,
  },
}

return M
