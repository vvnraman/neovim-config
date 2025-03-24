local M = {
  {
    -- https://github.com/folke/trouble.nvim
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        -- spec elsewhere
        "nvim-tree/nvim-web-devicons",
      },
    },
    config = function()
      local t = require("trouble")
      local opts_desc = function(desc)
        return { desc = "Trouble: " .. desc, noremap = true }
      end

      vim.keymap.set("n", "[q", function()
        if t.is_open() then
          t.previous({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end, opts_desc("Prev"))
      vim.keymap.set("n", "]q", function()
        if t.is_open() then
          t.next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end, opts_desc("Next"))

      require("which-key").add({
        "<leader>x",
        group = "+Trouble",
      })
      vim.keymap.set(
        "n",
        "<leader>xx",
        "<Cmd>Trouble diagnostics toggle<Cr>",
        opts_desc("Toggle")
      )
      vim.keymap.set(
        "n",
        "<leader>xf",
        "<Cmd>Trouble lsp toggle",
        opts_desc("LSP Re[f]erences toggle")
      )
      vim.keymap.set(
        "n",
        "<leader>xd",
        "<Cmd>Trouble diagnostics toggle filter.buf=0<Cr>",
        opts_desc("[d]ocument")
      )
      vim.keymap.set(
        "n",
        "<leader>xs",
        "<Cmd>Trouble symbols toggle<Cr>",
        opts_desc("[s]ymbols")
      )
      vim.keymap.set(
        "n",
        "<leader>xq",
        "<Cmd>Trouble qflist toggle<Cr>",
        opts_desc("[q]uickfix toggle")
      )
      vim.keymap.set(
        "n",
        "<leader>xl",
        "<Cmd>Trouble loclist toggle<Cr>",
        opts_desc("[l]ocation list toggle")
      )
    end,
  },
}

return M
