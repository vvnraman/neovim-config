local M = {}

---@return boolean
M.is_inside_git_worktree = function()
  local cmd = "git rev-parse --is-inside-work-tree"
  if vim.fn.system(cmd) == "true\n" then
    return true
  end
  return false
end

---@param content string
---@param append boolean
M.set_or_append_clipboard = function(content, append)
  if not append then
    vim.fn.setreg("+", content)
    return
  end

  local existing = vim.fn.getreg("+")
  if existing == "" then
    vim.fn.setreg("+", content)
    return
  end

  vim.fn.setreg("+", existing .. "\n" .. content)
end

---@return string
M.get_relative_path = function()
  local path = GET_CURRENT_FILE_PATH()
  local relative_path = path and vim.fn.fnamemodify(path, ":.") or "[No Name]"
  return relative_path
end

---@return boolean
M.is_visual_line_mode = function()
  local mode = vim.fn.mode(1)
  if string.sub(mode, 1, 1) == "V" then
    return true
  end

  return vim.fn.visualmode() == "V"
end

---@param cmd_line string
---@param arg_lead string
---@param option_keyset table<string, boolean>
---@return table<string, boolean>
M.get_used_command_option_keys = function(cmd_line, arg_lead, option_keyset)
  ---@type table<string, boolean>
  local used = {}
  local parts = vim.split(cmd_line, "%s+", { trimempty = true })

  for i = 2, #parts do
    local part = parts[i]
    if part ~= arg_lead then
      local key = string.match(part, "^([%a_]+)=")
      if key and option_keyset[key] then
        used[key] = true
      end
    end
  end

  return used
end

---@param fargs string[]
---@param defaults table<string, string>
---@param option_keyset table<string, boolean>
---@param allowed_values_by_key table<string, string[]>
---@param max_args integer
---@return table<string, string>|nil
---@return string|nil
M.parse_command_options = function(
  fargs,
  defaults,
  option_keyset,
  allowed_values_by_key,
  max_args
)
  if #fargs > max_args then
    return nil, string.format("Too many arguments: expected at most %d", max_args)
  end

  ---@type table<string, string>
  local opts = vim.deepcopy(defaults)

  if #fargs == 0 then
    return opts
  end

  local seen = {}

  for _, arg in ipairs(fargs) do
    local key, value = string.match(arg, "^([%a_]+)=(.+)$")
    if not key or not value then
      return nil, string.format("Invalid argument format: %s", arg)
    end

    if not option_keyset[key] then
      return nil, string.format("Unknown option: %s", key)
    end

    if seen[key] then
      return nil, string.format("Duplicate option: %s", key)
    end
    seen[key] = true

    opts[key] = value
  end

  for key, allowed_values in pairs(allowed_values_by_key) do
    local value = opts[key]
    if value and not vim.tbl_contains(allowed_values, value) then
      return nil, string.format("Invalid %s: %s", key, value)
    end
  end

  return opts
end

return M
