local gitsigns_on_attach = function(bufnr)
  local gs = package.loaded.gitsigns
  local which_key = require("which-key")

  --[[
  Keymaps copied from
  https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#keymaps
  --]]

  -- Navigation
  which_key.register({
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end,
      "git: Jump to next hunk",
    },
    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end,
      "git: Jump to previous hunk",
    },
  }, { buffer = bufnr, expr = true })

  which_key.register({
    h = {
      name = "+Git [h]unk",
      -- Actions
      s = { gs.stage_hunk, "git: [s]tage hunk" },
      r = { gs.reset_hunk, "git: [r]reset hunk" },
      f = { gs.stage_buffer, "git: stage [f]ile (buffer) " },
      u = { gs.undo_stage_hunk, "git: [u]ndo stage hunk" },
      F = { gs.reset_buffer, "git: reset [F]ile (buffer)" },
      p = { gs.preview_hunk, "git: [p]review hunk" },
      b = {
        function()
          gs.blame_line({ full = false })
        end,
        "git: [b]lame line",
      },
      d = { gs.diffthis, "git: [d]iff against index" },
      c = {
        function()
          gs.diffthis("~")
        end,
        "git: diff against [c]ommit",
      },
      -- Toggles
      t = { gs.toggle_current_line_blame, "git: [t]oggle git blame line" },
      l = { gs.toggle_current_line_blame, "git: show de[l]eted" },
    },
  }, {
    prefix = "<leader>",
    buffer = bufnr,
    mode = "n", --[[ "n" is default --]]
  })

  which_key.register({
    h = {
      name = "+Git [h]unk",
      -- Actions
      s = {
        function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        "git: [s]tage hunk",
      },
      r = {
        function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end,
        "git: [r]eset hunk",
      },
    },
  }, {
    prefix = "<leader>",
    buffer = bufnr,
    mode = "v", --[[ "n" is default --]]
  })

  -- Text object
  which_key.register({
    ["ih"] = { ":<C-U>Gitsigns select_hunk<CR>", "git: select git hunk" },
  }, {
    buffer = bufnr,
    mode = { "o", "x" }, --[[ "n" is default --]]
  })
end

local M = {
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
