local pathutil = require("vvn.pathutil")

local home = vim.fn.expand("~")
local obsidian_root = vim.fn.expand("~/obsidian")
local dropbox_root = vim.fn.expand("~/Dropbox")
local obsidian_rel = pathutil.relative_to_dir(home, obsidian_root)
local dropbox_rel = pathutil.relative_to_dir(home, dropbox_root)

---@type VvnTelescopeFilters
local M = {
  rg_globs = {
    "!" .. obsidian_rel .. "/.obsidian/*",
    "!.obsidian/*",
    "!" .. dropbox_rel .. "/.dropbox.cache/*",
    "!.dropbox.cache/*",
    "!" .. dropbox_rel .. "/.dropbox/*",
    "!.dropbox/*",
  },
  fd_excludes = {
    "obsidian/.obsidian/",
    ".obsidian/",
    "Dropbox/.dropbox.cache/",
    ".dropbox.cache/",
    "Dropbox/.dropbox/",
    ".dropbox/",
  },
}

return M
