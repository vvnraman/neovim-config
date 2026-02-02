---@module "keymap_docs"
---@class keymap_docs
--- Treesitter-based keymap extraction for Neovim configuration documentation
--- Note: This module uses Neovim's built-in treesitter API which may not have
--- complete type stubs in lua-language-server. The code is correct and functional.
local M = {}

-- Treesitter query to find vim.keymap.set calls
-- Match any function_call with dot_index_expression to get potential candidates
-- We'll filter for vim.keymap.set in Lua code
local keymap_query = [[
  (function_call
    (dot_index_expression) @dot_expr
    (arguments) @args)
]]

-- Helper patterns to track for description resolution
local helper_patterns = {
  help = true,
  NOREMAP = true,
  NOREMAP_SILENT = true,
}

-- Check if a dot_index_expression is vim.keymap.set
local function is_vim_keymap_set(dot_node, bufnr)
  -- dot_node should be a dot_index_expression
  if dot_node:type() ~= "dot_index_expression" then
    return false
  end

  -- Get the structure: vim.keymap.set
  -- The outer dot_index_expression has:
  --   - table: another dot_index_expression (vim.keymap)
  --   - field: identifier (set)

  local outer_table = nil
  local outer_field = nil

  for child in dot_node:iter_children() do
    local t = child:type()
    if t == "dot_index_expression" then
      outer_table = child
    elseif t == "identifier" then
      outer_field = child
    end
  end

  if not outer_table or not outer_field then
    return false
  end

  -- Check outer field is "set"
  local field_name = vim.treesitter.get_node_text(outer_field, bufnr)
  if field_name ~= "set" then
    return false
  end

  -- Check inner dot_index_expression is vim.keymap
  local inner_table = nil
  local inner_field = nil

  for child in outer_table:iter_children() do
    local t = child:type()
    if t == "identifier" then
      if not inner_table then
        inner_table = child
      else
        inner_field = child
      end
    end
  end

  if not inner_table or not inner_field then
    return false
  end

  local inner_table_name = vim.treesitter.get_node_text(inner_table, bufnr)
  local inner_field_name = vim.treesitter.get_node_text(inner_field, bufnr)

  return inner_table_name == "vim" and inner_field_name == "keymap"
end

-- Extract string value from a node
local function extract_string(node, bufnr)
  if not node then
    return nil
  end

  local node_type = node:type()

  if node_type == "string" then
    local text = vim.treesitter.get_node_text(node, bufnr)
    -- Remove quotes
    return text:gsub("^['\"]", ""):gsub("['\"]$", "")
  elseif node_type == "string_content" then
    return vim.treesitter.get_node_text(node, bufnr)
  end

  return nil
end

-- Extract mode from arguments
local function extract_mode(args_node, bufnr)
  if not args_node then
    return "?"
  end

  -- Get first non-punctuation child (the mode argument)
  local mode_node = nil
  for child in args_node:iter_children() do
    local t = child:type()
    if t ~= "(" and t ~= ")" and t ~= "," then
      mode_node = child
      break
    end
  end

  if not mode_node then
    return "?"
  end

  local node_type = mode_node:type()

  if node_type == "string" then
    return extract_string(mode_node, bufnr) or "?"
  elseif node_type == "table_constructor" then
    -- Handle table of modes like { "n", "x" }
    local modes = {}
    for child in mode_node:iter_children() do
      local child_type = child:type()
      if child_type == "string" then
        -- Direct string child (e.g., { "n" })
        local mode = extract_string(child, bufnr)
        if mode then
          table.insert(modes, mode)
        end
      elseif child_type == "field" then
        -- Field-wrapped string (e.g., { "n", "x", "o" })
        -- Field has: identifier/value = value
        -- For array-like tables, the value is the first non-punctuation child
        for field_child in child:iter_children() do
          local field_child_type = field_child:type()
          if field_child_type ~= "=" then
            local mode = extract_string(field_child, bufnr)
            if mode then
              table.insert(modes, mode)
            end
            break -- Only take the first value from the field
          end
        end
      end
    end
    return table.concat(modes, ", ")
  end

  return "?"
end

-- Extract lhs (keybinding) from arguments
local function extract_lhs(args_node, bufnr)
  if not args_node then
    return "?"
  end

  -- Second non-punctuation child is lhs
  local lhs_node = nil
  local found_first = false
  for child in args_node:iter_children() do
    local t = child:type()
    if t ~= "(" and t ~= ")" and t ~= "," then
      if not found_first then
        found_first = true
      else
        lhs_node = child
        break
      end
    end
  end

  if lhs_node then
    return extract_string(lhs_node, bufnr) or "?"
  end

  return "?"
end

-- Extract description from opts table
local function extract_desc_from_opts(opts_node, bufnr)
  if not opts_node then
    return nil
  end

  local node_type = opts_node:type()

  if node_type == "table_constructor" then
    -- Look for desc field in table
    for field in opts_node:iter_children() do
      if field:type() == "field" then
        -- Field structure: identifier = value
        local field_name = nil
        local value_node = nil

        for field_child in field:iter_children() do
          local t = field_child:type()
          if t == "identifier" then
            field_name = vim.treesitter.get_node_text(field_child, bufnr)
          elseif t ~= "=" and t ~= "{" and t ~= "}" then
            -- This is the value node
            value_node = field_child
          end
        end

        if field_name == "desc" and value_node then
          -- Check if it's a function call (like help("..."))
          local value_type = value_node:type()
          if value_type == "function_call" then
            -- Get function name from the dot_index_expression or identifier
            local func_name = nil
            local func_base = nil

            for func_child in value_node:iter_children() do
              if
                func_child:type() == "dot_index_expression"
                or func_child:type() == "identifier"
              then
                func_base = func_child
                break
              end
            end

            if func_base then
              func_name = vim.treesitter.get_node_text(func_base, bufnr)
            end

            -- Get arguments
            local args_node = nil
            for func_child in value_node:iter_children() do
              if func_child:type() == "arguments" then
                args_node = func_child
                break
              end
            end

            if func_name and args_node and helper_patterns[func_name] then
              -- Extract first non-punctuation argument of helper function
              for arg in args_node:iter_children() do
                local t = arg:type()
                if t ~= "(" and t ~= ")" and t ~= "," then
                  local desc = extract_string(arg, bufnr)
                  if desc then
                    return desc
                  end
                end
              end
            end
          else
            -- Direct string value
            return extract_string(value_node, bufnr)
          end
        end
      end
    end
  end

  return nil
end

-- Extract description from arguments
local function extract_desc(args_node, bufnr)
  if not args_node then
    return nil
  end

  -- Fourth non-punctuation argument is opts
  local opts_node = nil
  local arg_count = 0
  for child in args_node:iter_children() do
    local t = child:type()
    if t ~= "(" and t ~= ")" and t ~= "," then
      arg_count = arg_count + 1
      if arg_count == 4 then
        opts_node = child
        break
      end
    end
  end

  if not opts_node then
    return nil
  end

  local opts_type = opts_node:type()

  -- Case 1: Direct table constructor { desc = "..." }
  if opts_type == "table_constructor" then
    return extract_desc_from_opts(opts_node, bufnr)
  end

  -- Case 2: Helper function call like help("...") or NOREMAP("...")
  if opts_type == "function_call" then
    -- Get function name
    local func_name = nil
    for func_child in opts_node:iter_children() do
      local t = func_child:type()
      if t == "identifier" or t == "dot_index_expression" then
        func_name = vim.treesitter.get_node_text(func_child, bufnr)
        break
      end
    end

    -- Get arguments
    local func_args = nil
    for func_child in opts_node:iter_children() do
      if func_child:type() == "arguments" then
        func_args = func_child
        break
      end
    end

    if func_name and func_args and helper_patterns[func_name] then
      -- Extract first non-punctuation argument
      for arg in func_args:iter_children() do
        local t = arg:type()
        if t ~= "(" and t ~= ")" and t ~= "," then
          return extract_string(arg, bufnr)
        end
      end
    end
  end

  return nil
end

-- Parse a single file and extract keymaps
local function parse_file(filepath)
  local keymaps = {}

  -- Read file content
  local ok, lines = pcall(vim.fn.readfile, filepath)
  if not ok or not lines then
    return keymaps
  end

  local content = table.concat(lines, "\n")

  -- Parse with treesitter
  local parser_ok, parser = pcall(vim.treesitter.get_string_parser, content, "lua")
  if not parser_ok then
    return keymaps
  end

  local parse_ok, trees = pcall(function()
    return parser:parse()
  end)
  if not parse_ok or not trees or not trees[1] then
    return keymaps
  end
  local tree = trees[1]

  local root = tree:root()
  local query_ok, query = pcall(vim.treesitter.query.parse, "lua", keymap_query)
  if not query_ok then
    return keymaps
  end

  -- Create a temporary buffer for text extraction
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(content, "\n"))

  for _, match, _ in query:iter_matches(root, bufnr) do
    local dot_node = nil
    local args_node = nil

    for i = 1, #match do
      local node_list = match[i]
      local name = query.captures[i]
      if name == "dot_expr" and #node_list > 0 then
        dot_node = node_list[1]
      elseif name == "args" and #node_list > 0 then
        args_node = node_list[1]
      end
    end

    -- Check if this is vim.keymap.set
    if dot_node and args_node and is_vim_keymap_set(dot_node, bufnr) then
      local mode = extract_mode(args_node, bufnr)
      local lhs = extract_lhs(args_node, bufnr)
      local desc = extract_desc(args_node, bufnr)
      local start_row, _, _ = args_node:start()

      table.insert(keymaps, {
        mode = mode,
        lhs = lhs,
        desc = desc,
        line = start_row + 1,
        source = "treesitter",
      })
    end
  end

  vim.api.nvim_buf_delete(bufnr, { force = true })

  return keymaps
end

-- Find all Lua files in the config directory
local function find_lua_files()
  local config_dir = vim.fn.stdpath("config")
  local files = {}

  local handle = vim.uv.fs_scandir(config_dir .. "/lua")
  if not handle then
    return files
  end

  local function scan_dir(dir, prefix)
    local dir_handle = vim.uv.fs_scandir(dir)
    if not dir_handle then
      return
    end

    while true do
      local name, entry_type = vim.uv.fs_scandir_next(dir_handle)
      if not name then
        break
      end

      local full_path = dir .. "/" .. name
      -- Ensure prefix doesn't start with "/"
      local rel_path = prefix and (prefix .. "/" .. name) or name
      if rel_path:sub(1, 1) == "/" then
        rel_path = rel_path:sub(2)
      end

      if entry_type == "directory" then
        scan_dir(full_path, rel_path)
      elseif entry_type == "file" and name:match("%.lua$") then
        table.insert(files, {
          full = full_path,
          relative = rel_path,
        })
      end
    end
  end

  scan_dir(config_dir .. "/lua", "")

  return files
end

-- Get all keymaps from Neovim API
local function get_api_keymaps()
  local all_keymaps = {}
  local modes = { "n", "v", "x", "s", "o", "i", "l", "c", "t" }

  for _, mode in ipairs(modes) do
    local ok, keymaps = pcall(vim.api.nvim_get_keymap, mode)
    if ok and keymaps then
      for _, km in ipairs(keymaps) do
        -- Skip built-in keymaps (those without a desc or with script_id = 0)
        -- User-defined keymaps typically have script_id > 0
        if km.scriptid and km.scriptid > 0 then
          table.insert(all_keymaps, {
            mode = km.mode,
            lhs = km.lhs,
            desc = km.desc,
            rhs = km.rhs,
            script_id = km.scriptid,
          })
        end
      end
    end
  end

  return all_keymaps
end

-- Normalize mode string for comparison
local function normalize_mode(mode_str)
  -- Split by comma, sort, and rejoin
  local modes = {}
  for mode in mode_str:gmatch("[^, ]+") do
    table.insert(modes, mode)
  end
  table.sort(modes)
  return table.concat(modes, ", ")
end

-- Build lookup table from API keymaps: mode_lhs -> desc
local function build_api_lookup(api_keymaps)
  local lookup = {}

  for _, km in ipairs(api_keymaps) do
    -- API returns individual mode entries, so create key for each
    local key = km.mode .. "_" .. km.lhs
    lookup[key] = km.desc
  end

  return lookup
end

-- Merge treesitter results with API results
local function merge_keymaps(ts_results, api_lookup)
  local merged = {}
  local seen = {}

  -- First pass: process treesitter results and merge with API desc
  for _, km in ipairs(ts_results) do
    -- Normalize mode for consistent lookup
    local normalized_mode = normalize_mode(km.mode)
    local key = normalized_mode .. "_" .. km.lhs

    -- Use API desc if available, otherwise use treesitter desc
    local final_desc = api_lookup[key] or km.desc

    if not seen[key] then
      seen[key] = true
      table.insert(merged, {
        mode = normalized_mode,
        lhs = km.lhs,
        desc = final_desc,
        line = km.line,
        source = km.source,
      })
    end
  end

  return merged
end

-- Find API-only keymaps (those not found by treesitter)
local function find_api_only_keymaps(api_keymaps, ts_results)
  local ts_lookup = {}

  -- Build lookup from treesitter results
  for _, km in ipairs(ts_results) do
    local normalized_mode = normalize_mode(km.mode)
    local key = normalized_mode .. "_" .. km.lhs
    ts_lookup[key] = true
  end

  -- Find API keymaps not in treesitter
  local api_only = {}
  local seen = {}

  for _, km in ipairs(api_keymaps) do
    local key = km.mode .. "_" .. km.lhs

    if not ts_lookup[key] and not seen[key] then
      seen[key] = true
      table.insert(api_only, {
        mode = km.mode,
        lhs = km.lhs,
        desc = km.desc,
        line = nil,
        source = "dynamic keymaps",
      })
    end
  end

  return api_only
end

-- Generate RST content
local function generate_rst(keymaps_by_file)
  local lines = {
    "Keymaps Reference",
    "=================",
    "",
    "This document lists all keybindings defined in this Neovim configuration.",
    "It is auto-generated from the Lua configuration files.",
    "",
  }

  -- Sort files alphabetically, but put "dynamic keymaps" at the end
  local sorted_files = {}
  local dynamic_entry = nil

  for filepath, _ in pairs(keymaps_by_file) do
    if filepath == "dynamic keymaps" then
      dynamic_entry = filepath
    else
      table.insert(sorted_files, filepath)
    end
  end

  table.sort(sorted_files)

  -- Add dynamic keymaps at the end if present
  if dynamic_entry then
    table.insert(sorted_files, dynamic_entry)
  end

  for _, filepath in ipairs(sorted_files) do
    local keymaps = keymaps_by_file[filepath]

    -- File section header
    table.insert(lines, filepath)
    table.insert(lines, string.rep("-", #filepath))
    table.insert(lines, "")

    -- RST list table
    table.insert(lines, ".. list-table::")
    table.insert(lines, "   :header-rows: 1")
    table.insert(lines, "")
    table.insert(lines, "   * - Mode")
    table.insert(lines, "     - Key")
    table.insert(lines, "     - Description")
    table.insert(lines, "     - Source")

    for _, km in ipairs(keymaps) do
      local desc = km.desc or "[no description]"
      -- Escape special RST characters
      desc = desc:gsub("<", "\\<"):gsub(">", "\\>")
      local lhs = km.lhs:gsub("<", "\\<"):gsub(">", "\\>")

      table.insert(lines, string.format("   * - %s", km.mode))
      table.insert(lines, string.format("     - %s", lhs))
      table.insert(lines, string.format("     - %s", desc))

      -- Format source based on whether it's a file or dynamic
      if km.source == "dynamic keymaps" then
        table.insert(lines, string.format("     - %s", km.source))
      else
        table.insert(lines, string.format("     - %s:%d", filepath, km.line))
      end
    end

    table.insert(lines, "")
  end

  return table.concat(lines, "\n")
end

-- Main function to generate keymap documentation
M.generate = function()
  local files = find_lua_files()
  local keymaps_by_file = {}
  local all_ts_keymaps = {}
  local total_ts_keymaps = 0

  -- Step 1: Extract keymaps using treesitter
  for _, file_info in ipairs(files) do
    local keymaps = parse_file(file_info.full)
    if #keymaps > 0 then
      keymaps_by_file[file_info.relative] = keymaps
      total_ts_keymaps = total_ts_keymaps + #keymaps

      -- Collect all treesitter keymaps for merging
      for _, km in ipairs(keymaps) do
        table.insert(all_ts_keymaps, km)
      end
    end
  end

  if total_ts_keymaps == 0 then
    vim.notify("No keymaps found via treesitter!", vim.log.levels.WARN)
  end

  -- Step 2: Get keymaps from API
  local api_keymaps = get_api_keymaps()
  local api_lookup = build_api_lookup(api_keymaps)

  -- Step 3: Merge treesitter results with API descriptions
  for filepath, keymaps in pairs(keymaps_by_file) do
    keymaps_by_file[filepath] = merge_keymaps(keymaps, api_lookup)
  end

  -- Step 4: Find API-only keymaps (dynamic keymaps not in treesitter)
  local dynamic_keymaps = find_api_only_keymaps(api_keymaps, all_ts_keymaps)

  -- Step 5: Add dynamic keymaps as a special section
  if #dynamic_keymaps > 0 then
    keymaps_by_file["dynamic keymaps"] = dynamic_keymaps
  end

  -- Calculate total
  local total_keymaps = 0
  for _, keymaps in pairs(keymaps_by_file) do
    total_keymaps = total_keymaps + #keymaps
  end

  if total_keymaps == 0 then
    vim.notify("No keymaps found!", vim.log.levels.WARN)
    return
  end

  -- Generate RST content
  local rst_content = generate_rst(keymaps_by_file)

  -- Write to docs/reference/keymaps.rst
  local config_dir = vim.fn.stdpath("config")
  local output_path = config_dir .. "/docs/reference/keymaps.rst"

  -- Ensure directory exists
  vim.fn.mkdir(config_dir .. "/docs/reference", "p")

  -- Write file
  local file = io.open(output_path, "w")
  if file then
    file:write(rst_content)
    file:close()
    vim.notify(
      string.format(
        "Generated keymap documentation: %s (%d keymaps, %d dynamic)",
        output_path,
        total_keymaps,
        #dynamic_keymaps
      ),
      vim.log.levels.INFO
    )
  else
    vim.notify("Failed to write " .. output_path, vim.log.levels.ERROR)
  end
end

return M
