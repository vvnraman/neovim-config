---@class VvnGitUtilModule
---@field is_inside_git_worktree fun(): boolean
---@field get_project_root fun(): string, boolean

---@type VvnGitUtilModule
local M = {}

---@return boolean
M.is_inside_git_worktree = function()
  local cmd = "git rev-parse --is-inside-work-tree"
  return vim.fn.system(cmd) == "true\n"
end

---@return string
---@return boolean
M.get_project_root = function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local current_dir = current_file == "" and cwd or vim.fn.fnamemodify(current_file, ":h")

  local git_root = vim.fn.systemlist(
    "git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel"
  )[1]

  if vim.v.shell_error == 0 then
    return git_root, true
  end

  return cwd, false
end

return M
