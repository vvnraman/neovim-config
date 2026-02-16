---@alias VvnYankMode "set"|"append"
---@alias VvnYankKind "filepath"|"relative_path"|"file_and_lines"|"diagnostics"|"file_line_diagnostics"|"file_line_simple"

---@class VvnYankOptions
---@field mode VvnYankMode
---@field kind VvnYankKind

---@class VvnFileAndLinesState
---@field last_relative_path string|nil
---@field last_filetype string|nil
---@field last_blocks string[]|nil
---@field last_register string|nil

---@class VvnYankModule
---@field setup fun()|nil

---@type VvnYankModule
local M = {}
local util = require("vvn.util")

local USER_COMMAND_NAME = "VvnYank"
local NOTIFY_TITLE = "VvnYank"

---@param message string
---@param level? string
local notify = function(message, level)
  Snacks.notifier.notify(message, level or "info", { title = NOTIFY_TITLE })
end

---@type VvnYankKind[]
local COMMAND_KINDS = {
  "filepath",
  "relative_path",
  "file_and_lines",
  "diagnostics",
  "file_line_diagnostics",
  "file_line_simple",
}

---@type VvnYankMode[]
local COMMAND_MODES = {
  "set",
  "append",
}

---@type table<string, string>
local COMMAND_OPTION_DEFAULTS = {
  mode = "set",
  kind = "file_and_lines",
}

---@type table<string, boolean>
local COMMAND_OPTION_KEYSET = {
  mode = true,
  kind = true,
}

---@type table<string, string[]>
local COMMAND_OPTION_ALLOWED_VALUES = {
  mode = COMMAND_MODES,
  kind = COMMAND_KINDS,
}

---@type VvnFileAndLinesState
local file_and_lines_state = {
  last_relative_path = nil,
  last_filetype = nil,
  last_blocks = nil,
  last_register = nil,
}

---@param register_content string
local reset_file_and_lines_state = function(register_content)
  file_and_lines_state.last_relative_path = nil
  file_and_lines_state.last_filetype = nil
  file_and_lines_state.last_blocks = nil
  file_and_lines_state.last_register = register_content
end

---@param existing string
---@param full_content string
local append_file_and_lines_fallback = function(existing, full_content)
  local combined = existing .. "\n" .. full_content
  vim.fn.setreg("+", combined)
  reset_file_and_lines_state(combined)
end

---@param register_content string
---@param block_content string|nil
---@param relative_path string|nil
---@param filetype string
local set_file_and_lines_register_state = function(
  register_content,
  block_content,
  relative_path,
  filetype
)
  vim.fn.setreg("+", register_content)

  if not relative_path or not block_content then
    reset_file_and_lines_state(register_content)
    return
  end

  file_and_lines_state.last_relative_path = relative_path
  file_and_lines_state.last_filetype = filetype
  file_and_lines_state.last_blocks = { block_content }
  file_and_lines_state.last_register = register_content
end

---@param filetype string
---@return string
local get_markdown_fence_open = function(filetype)
  if filetype == "" then
    return "```"
  end

  return "```" .. filetype
end

---@param relative_path string
---@param filetype string
---@param blocks string[]
---@return string
local build_compact_file_and_lines_content = function(relative_path, filetype, blocks)
  return string.format(
    "%s\n%s\n%s\n```",
    relative_path,
    get_markdown_fence_open(filetype),
    table.concat(blocks, "\n\n")
  )
end

---@param full_content string
---@param block_content string|nil
---@param relative_path string|nil
---@param filetype string
---@param append boolean
---When append=false, this replaces clipboard content and updates compaction state.
---When append=true, it appends by default, but compacts into a single fenced block
---for same-file/same-filetype yanks when previous clipboard state still matches.
local set_file_and_lines_clipboard = function(
  full_content,
  block_content,
  relative_path,
  filetype,
  append
)
  if not append then
    set_file_and_lines_register_state(full_content, block_content, relative_path, filetype)
    return
  end

  local existing = vim.fn.getreg("+")
  if existing == "" then
    set_file_and_lines_register_state(full_content, block_content, relative_path, filetype)
    return
  end

  local can_compact_same_file = relative_path
    and block_content
    and file_and_lines_state.last_relative_path == relative_path
    and file_and_lines_state.last_filetype == filetype
    and file_and_lines_state.last_blocks ~= nil
    and file_and_lines_state.last_register == existing

  if not can_compact_same_file then
    append_file_and_lines_fallback(existing, full_content)
    return
  end

  local previous_blocks = file_and_lines_state.last_blocks or {}
  ---@type string[]
  local blocks = vim.deepcopy(previous_blocks)
  local relative_path_value = relative_path or ""
  local block_content_value = block_content or ""

  table.insert(blocks, block_content_value)

  local compact_content =
    build_compact_file_and_lines_content(relative_path_value, filetype, blocks)
  vim.fn.setreg("+", compact_content)

  file_and_lines_state.last_relative_path = relative_path_value
  file_and_lines_state.last_filetype = filetype
  file_and_lines_state.last_blocks = blocks
  file_and_lines_state.last_register = compact_content
end

---@param annotation string
---@return string
local format_with_commentstring = function(annotation)
  local commentstring = vim.bo.commentstring
  if commentstring == "" or not string.find(commentstring, "%%s") then
    return annotation
  end

  local ok, formatted = pcall(string.format, commentstring, annotation)
  if ok and type(formatted) == "string" then
    return formatted
  end

  return annotation
end

---@param start_line integer
---@param end_line integer
---@return string
local build_line_annotation = function(start_line, end_line)
  if start_line == end_line then
    return format_with_commentstring(string.format("line %d", start_line))
  end

  return format_with_commentstring(string.format("lines %d-%d", start_line, end_line))
end

---@param start_line integer
---@param end_line integer
---@param lines string[]
---@return string full_content
---@return string block_content
---@return string relative_path
---@return string filetype
local build_file_and_lines_markdown = function(start_line, end_line, lines)
  local relative_path = util.get_relative_path()

  local filetype = vim.bo.filetype
  local fence_open = get_markdown_fence_open(filetype)

  local block_lines = { build_line_annotation(start_line, end_line) }
  for _, line in ipairs(lines) do
    table.insert(block_lines, line)
  end

  local block_content = table.concat(block_lines, "\n")
  local fenced_block_content = string.format("%s\n%s\n```", fence_open, block_content)

  local full_content = relative_path .. "\n" .. fenced_block_content
  return full_content, block_content, relative_path, filetype
end

---@return string|nil
local get_current_line_diagnostics = function()
  local bufnr = 0
  ---@type vim.Diagnostic[]
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = GET_CURRENT_LINE() })

  if #diagnostics == 0 then
    return nil
  end

  ---@type string[]
  local messages = {}

  for _, d in ipairs(diagnostics) do
    local msg = d.message
    if d.source then
      msg = string.format("[%s] %s", d.source, msg)
    end
    table.insert(messages, msg)
  end

  return table.concat(messages, "\n")
end

---@param line_diagnostics string|nil
---@return boolean
local no_diagnostics_notify = function(line_diagnostics)
  if not line_diagnostics or line_diagnostics == "" then
    notify("No diagnostics for current line")
    return true
  end

  return false
end

---@param path string
---@return string
local identity = function(path)
  return path
end

---@param path string
---@return string
local to_relative_path = function(path)
  return vim.fn.fnamemodify(path, ":.")
end

---@param append boolean
---@param path_transformer fun(path: string): string
---@param message string
local yank_current_path = function(append, path_transformer, message)
  local path = GET_CURRENT_FILE_PATH()
  if not path then
    return
  end

  util.set_or_append_clipboard(path_transformer(path), append)
  notify(message)
end

---@param append boolean
local yank_current_line_with_path_and_line_number = function(append)
  local current_line = vim.api.nvim_get_current_line()
  local line_nr = vim.fn.line(".")

  local content_to_copy, block_content, relative_path, filetype =
    build_file_and_lines_markdown(line_nr, line_nr, { current_line })

  set_file_and_lines_clipboard(content_to_copy, block_content, relative_path, filetype, append)
  notify("Yanked file path & line")
end

---@param start_line integer|nil
---@param end_line integer|nil
---@param append boolean
local yank_selected_lines_with_file_and_range = function(start_line, end_line, append)
  local current_mode = vim.fn.mode(1)
  local visual_type = string.sub(current_mode, 1, 1)
  if visual_type ~= "V" then
    visual_type = vim.fn.visualmode()
  end

  if not start_line and visual_type ~= "V" then
    notify(
      string.format("'file_and_lines' supports visual-line mode only (got: %s)", visual_type),
      "warn"
    )
    return
  end

  start_line = start_line or vim.fn.line("v")
  end_line = end_line or vim.fn.line(".")

  if start_line == 0 or end_line == 0 then
    start_line = vim.fn.getpos("'<")[2]
    end_line = vim.fn.getpos("'>")[2]
  end

  if start_line == 0 or end_line == 0 then
    notify("Unable to resolve visual selection range", "warn")
    return
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local selected_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local content_to_copy, block_content, relative_path, filetype =
    build_file_and_lines_markdown(start_line, end_line, selected_lines)

  set_file_and_lines_clipboard(content_to_copy, block_content, relative_path, filetype, append)
  notify("Yanked selected lines with file path")
end

---@param append boolean
local yank_current_line_diagnostics = function(append)
  local line_diagnostics = get_current_line_diagnostics()
  if no_diagnostics_notify(line_diagnostics) then
    return
  end

  util.set_or_append_clipboard(line_diagnostics, append)
  notify("Diagnostics copied to clipboard")
end

---@param append boolean
local yank_current_line_with_diagnostics = function(append)
  local line_diagnostics = get_current_line_diagnostics()
  if no_diagnostics_notify(line_diagnostics) then
    return
  end

  local relative_path = util.get_relative_path()

  local content_to_copy = {
    relative_path .. ":" .. tostring(vim.fn.line(".")),
    vim.api.nvim_get_current_line(),
    line_diagnostics,
  }

  util.set_or_append_clipboard(table.concat(content_to_copy, "\n"), append)
  notify("Current line + diagnostics copied to clipboard")
end

---@param append boolean
local yank_current_line_simple = function(append)
  local relative_path = util.get_relative_path()
  local line_nr = vim.fn.line(".")
  local current_line = vim.api.nvim_get_current_line()

  local content_to_copy = string.format("%s:%d:%s", relative_path, line_nr, current_line)
  util.set_or_append_clipboard(content_to_copy, append)
  notify("Current line copied as file:line:content")
end

---@param append boolean
---@param args vim.api.keyset.create_user_command.command_args
local yank_file_and_lines = function(append, args)
  if args.range > 0 then
    yank_selected_lines_with_file_and_range(args.line1, args.line2, append)
    return
  end

  if util.is_visual_line_mode() then
    yank_selected_lines_with_file_and_range(nil, nil, append)
    return
  end

  yank_current_line_with_path_and_line_number(append)
end

---@alias VvnYankHandler fun(append: boolean, ...: any)

---@type table<VvnYankKind, VvnYankHandler>
local KIND_HANDLERS = {
  filepath = function(append)
    yank_current_path(append, identity, "Yanked buffer path")
  end,
  relative_path = function(append)
    yank_current_path(append, to_relative_path, "Yanked relative buffer path")
  end,
  file_and_lines = yank_file_and_lines,
  diagnostics = yank_current_line_diagnostics,
  file_line_diagnostics = yank_current_line_with_diagnostics,
  file_line_simple = yank_current_line_simple,
}

local setup_user_commands = function()
  ---@param args vim.api.keyset.create_user_command.command_args
  vim.api.nvim_create_user_command(USER_COMMAND_NAME, function(args)
    local opts, err = util.parse_command_options(
      args.fargs,
      COMMAND_OPTION_DEFAULTS,
      COMMAND_OPTION_KEYSET,
      COMMAND_OPTION_ALLOWED_VALUES,
      2
    )
    if err then
      notify(err, "warn")
      return
    end

    if not opts then
      notify("Unable to parse VvnYank options", "warn")
      return
    end

    ---@cast opts VvnYankOptions
    local append = opts.mode == "append"
    local kind = opts.kind

    local handler = KIND_HANDLERS[kind]
    if not handler then
      notify(string.format("Unhandled kind: %s", kind), "warn")
      return
    end

    handler(append, args)
  end, {
    desc = "Yank file path, line metadata, and diagnostics",
    nargs = "*",
    range = true,
    complete = function(arg_lead, cmd_line)
      local items = {}
      local used_option_keys =
        util.get_used_command_option_keys(cmd_line, arg_lead, COMMAND_OPTION_KEYSET)
      local can_suggest_mode = not used_option_keys.mode or vim.startswith(arg_lead, "mode=")
      local can_suggest_kind = not used_option_keys.kind or vim.startswith(arg_lead, "kind=")

      if can_suggest_mode then
        vim.list_extend(
          items,
          vim.tbl_map(function(mode)
            return "mode=" .. mode
          end, COMMAND_MODES)
        )
      end

      if can_suggest_kind then
        vim.list_extend(
          items,
          vim.tbl_map(function(kind)
            return "kind=" .. kind
          end, COMMAND_KINDS)
        )
      end

      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, items)
    end,
  })
end

local setup_keymaps = function()
  vim.keymap.set(
    "n",
    "<leader>yf",
    "<Cmd>VvnYank mode=set kind=filepath<Cr>",
    NOREMAP("Yank current file path")
  )
  vim.keymap.set(
    "n",
    "<leader>yr",
    "<Cmd>VvnYank mode=set kind=relative_path<Cr>",
    NOREMAP("Yank current file's cwd relative path")
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>yy",
    "<Cmd>VvnYank mode=set kind=file_and_lines<Cr>",
    NOREMAP("[y]ank current file and line(s)")
  )
  vim.keymap.set(
    { "n", "x" },
    "<leader>ya",
    "<Cmd>VvnYank mode=append kind=file_and_lines<Cr>",
    NOREMAP("[y]ank [a]ppend current file and line(s)")
  )
  vim.keymap.set(
    "n",
    "<leader>dd",
    "<Cmd>VvnYank mode=set kind=diagnostics<Cr>",
    NOREMAP("[d]ump [d]iagnostics to clipboard")
  )
  vim.keymap.set(
    "n",
    "<leader>yd",
    "<Cmd>VvnYank mode=set kind=file_line_diagnostics<Cr>",
    NOREMAP("[y]ank file, line and [d]iagnostics")
  )
  vim.keymap.set(
    "n",
    "<leader>ys",
    "<Cmd>VvnYank mode=set kind=file_line_simple<Cr>",
    NOREMAP("[y]ank file and line [s]imple")
  )
end

M.setup = function()
  setup_user_commands()
  setup_keymaps()
end

return M
