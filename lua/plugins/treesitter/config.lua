---@return table
local get_textobject_config = function()
  return {
    select = {
      lookahead = true,
      selection_modes = {
        ["@function.outer"] = "V",
        ["@loop.outer"] = "V",
        ["@conditional.outer"] = "V",
        ["@parameter.outer"] = "v",
      },
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  }
end

---@return string[]
local get_ensure_installed = function()
  local configured = require("vvn.profile_config").get_treesitter_ensure_installed()
  ---@type table<string, boolean>
  local seen = {}
  ---@type string[]
  local languages = {}

  for _, language in ipairs(configured) do
    if not seen[language] then
      seen[language] = true
      table.insert(languages, language)
    end
  end

  return languages
end

---@param bufnr integer
local enable_buffer_treesitter = function(bufnr)
  local ok = pcall(vim.treesitter.start, bufnr)
  if not ok then
    return
  end

  vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

---@return nil
local setup_treesitter_runtime = function()
  local group = vim.api.nvim_create_augroup("vvn_treesitter_runtime", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    callback = function(args)
      enable_buffer_treesitter(args.buf)
    end,
  })

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype ~= "" then
      enable_buffer_treesitter(bufnr)
    end
  end
end

---@param modes string[]|string
---@param lhs string
---@param rhs fun()
---@param desc string
local set_keymap = function(modes, lhs, rhs, desc)
  vim.keymap.set(modes, lhs, rhs, { desc = desc })
end

---@return nil
local setup_textobjects = function()
  require("nvim-treesitter-textobjects").setup(get_textobject_config())

  local move = require("nvim-treesitter-textobjects.move")
  local select = require("nvim-treesitter-textobjects.select")

  set_keymap({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer")
  end, "Select around function")
  set_keymap({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner")
  end, "Select inner function")
  set_keymap({ "x", "o" }, "al", function()
    select.select_textobject("@loop.outer")
  end, "Select around loop")
  set_keymap({ "x", "o" }, "il", function()
    select.select_textobject("@loop.inner")
  end, "Select inner loop")
  set_keymap({ "x", "o" }, "ac", function()
    select.select_textobject("@conditional.outer")
  end, "Select around conditional")
  set_keymap({ "x", "o" }, "ic", function()
    select.select_textobject("@conditional.inner")
  end, "Select inner conditional")
  set_keymap({ "x", "o" }, "aa", function()
    select.select_textobject("@parameter.outer")
  end, "Select around parameter")
  set_keymap({ "x", "o" }, "ia", function()
    select.select_textobject("@parameter.inner")
  end, "Select inner parameter")

  set_keymap({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer")
  end, "Next function")
  set_keymap({ "n", "x", "o" }, "]]", function()
    move.goto_next_start({ "@loop.outer", "@conditional.outer" })
  end, "Next loop or conditional")
  set_keymap({ "n", "x", "o" }, "]s", function()
    move.goto_next_start("@scope", "locals")
  end, "Next scope")
  set_keymap({ "n", "x", "o" }, "]z", function()
    move.goto_next_start("@fold", "folds")
  end, "Next fold")
  set_keymap({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer")
  end, "Previous function")
  set_keymap({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start({ "@loop.outer", "@conditional.outer" })
  end, "Previous loop or conditional")
  set_keymap({ "n", "x", "o" }, "[s", function()
    move.goto_previous_start("@scope", "locals")
  end, "Previous scope")
  set_keymap({ "n", "x", "o" }, "[z", function()
    move.goto_previous_start("@fold", "folds")
  end, "Previous fold")
end

---@param languages string[]
---@param sync_install boolean
---@return nil
local ensure_treesitter_parsers = function(languages, sync_install)
  if #languages == 0 then
    return
  end

  local installer = require("nvim-treesitter").install(languages, { summary = true })
  if not sync_install or not installer then
    return
  end

  installer:wait(300000)
end

---@return nil
local setup_treesitter = function()
  local is_headless = #vim.api.nvim_list_uis() == 0
  local sync_install = is_headless and vim.env.NVIM_TREESITTER_SYNC_INSTALL == "1"

  require("nvim-treesitter").setup({})
  setup_treesitter_runtime()
  setup_textobjects()
  ensure_treesitter_parsers(get_ensure_installed(), sync_install)
end

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = setup_treesitter,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    lazy = false,
  },
  {
    -- https://github.com/windwp/nvim-ts-autotag
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    config = true,
  },
}

return M
