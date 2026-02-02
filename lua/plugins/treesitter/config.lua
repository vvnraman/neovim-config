local get_textobject_config = function()
  return {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
      selection_modes = {
        ["@function.outer"] = "V",
        ["@loop.outer"] = "V",
        ["@conditional.outer"] = "V",
        ["@parameter.outer"] = "v",
      },
      include_surrounding_whitespace = false,
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>an"] = {
          query = "@parameter.inner",
          desc = "Swap: parameter.next",
        },
      },
      swap_previous = {
        ["<leader>ap"] = {
          query = "@parameter.inner",
          desc = "Swap: parameter.prev",
        },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = { "@loop.outer", "@conditional.outer" } },
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = "@fold",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = { query = { "@loop.outer", "@conditional.outer" } },
        ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["[z"] = "@fold",
      },
    },
  }
end

local setup_treesitter = function()
  local ts_config = require("nvim-treesitter.configs")
  ts_config.setup({
    ensure_installed = {
      "bash",
      "c",
      "cmake",
      "comment",
      "cpp",
      "desktop",
      "fish",
      "go",
      "gotmpl",
      "hjson",
      "hyprlang",
      "html",
      "ini",
      "json",
      "jq",
      "lua",
      "markdown",
      "mermaid",
      "norg",
      "regex",
      "rst",
      "sql",
      "ssh_config",
      "templ",
      "tmux",
      "toml",
      "typescript",
      "udev",
      "vim",
      "yaml",
      "zig",
    },
    sync_install = false,
    ignore_install = {},
    auto_install = false,
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = false,
    },
    indent = { enable = true },
    textobjects = get_textobject_config(),
  })
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
      "lvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      vim.defer_fn(setup_treesitter, 0)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "master",
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    config = function()
      local ts_context = require("treesitter-context")
      ts_context.setup()
      vim.keymap.set("n", "[c", function()
        ts_context.go_to_context()
      end, NOREMAP_SILENT("Go to context"))
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    config = true,
  },
  {
    -- https://github.com/windwp/nvim-ts-autotag
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = true,
  },
}

return M
