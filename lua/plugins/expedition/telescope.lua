local pathutil = require("vvn.pathutil")
local profile_config = require("vvn.profile_config")

---@param globs string[]
---@return string[]
local to_rg_glob_args = function(globs)
  ---@type string[]
  local args = {}
  for _, glob in ipairs(globs) do
    table.insert(args, "--glob")
    table.insert(args, glob)
  end
  return args
end

---@param excludes string[]
---@return string[]
local to_fd_exclude_args = function(excludes)
  ---@type string[]
  local args = {}
  for _, exclude in ipairs(excludes) do
    table.insert(args, "--exclude")
    table.insert(args, exclude)
  end
  return args
end

local telescope_filters = profile_config.get_telescope_filters()
local rg_glob_exclusions = vim.deepcopy(telescope_filters.rg_globs)
local rg_cmd =
  vim.list_extend({ "rg", "--files", "--hidden" }, to_rg_glob_args(rg_glob_exclusions))

local fd_exclusions = vim.deepcopy(telescope_filters.fd_excludes)
local fd_cmd =
  vim.list_extend({ "fd", "--type", "file", "--hidden" }, to_fd_exclude_args(fd_exclusions))
local fd_cmd_dir = vim.list_extend(
  { "fd", "--type", "directory", "--hidden" },
  to_fd_exclude_args(fd_exclusions)
)
local fd_cmd_d1 = vim.list_extend(vim.deepcopy(fd_cmd), { "--max-depth", "1" })

---@param prefix string
---@param is_git boolean
---@return string
local get_prompt = function(prefix, is_git)
  if is_git then
    return "Git " .. prefix
  else
    return "CWD " .. prefix
  end
end

---@class VvnTelescopeRuntime
---@field bufutil VvnBufUtilModule
---@field gitutil VvnGitUtilModule
---@field telescope table
---@field builtin table
---@field telescope_actions table
---@field action_state table
---@field telescope_state table
---@field which_key table
---@field telescope_config table
---@field trouble_open function
---@field egrepify_toggle_prefixes function
---@field vimgrep_arguments string[]
---@field telescope_ivy table

---@class VvnTelescopeActions
---@field copy_selected_entries fun(prompt_bufnr: integer)
---@field open_oil fun(prompt_bufnr: integer)
---@field attach_buffers_existing_window_mappings fun(prompt_bufnr: integer, map: fun(mode: string, lhs: string, rhs: function)): boolean
---@field open_find_files_in_new_tab fun()

---@param trt VvnTelescopeRuntime
---@param prompt_bufnr integer
---@param blend integer
local set_preview_winblend = function(trt, prompt_bufnr, blend)
  -- We want one transparency level for the search input/list (30), but a
  -- different one for the file preview area (10) so preview text stays easier
  -- to read.
  --
  -- After the search UI is created, it updates only the preview window (and
  -- preview border) to the requested blend value.
  vim.schedule(function()
    local status = trt.telescope_state.get_status(prompt_bufnr)
    local preview = status.layout and status.layout.preview
    if not preview then
      return
    end

    if preview.winid and vim.api.nvim_win_is_valid(preview.winid) then
      vim.wo[preview.winid].winblend = blend
    end

    local border_winid = preview.border and preview.border.winid
    if border_winid and vim.api.nvim_win_is_valid(border_winid) then
      vim.wo[border_winid].winblend = blend
    end
  end)
end

---@param trt VvnTelescopeRuntime
---@param opts table
---@param blend integer
---@return table
local with_preview_winblend = function(trt, opts, blend)
  -- Theme options apply one transparency value to the whole UI. This wrapper
  -- lets us keep that default while layering a preview-only adjustment.
  --
  -- It keeps any existing picker mapping setup, and adds one extra hook that
  -- applies preview blend after the UI opens.
  local picker_opts = vim.deepcopy(opts)
  local existing_attach = picker_opts.attach_mappings

  picker_opts.attach_mappings = function(prompt_bufnr, map)
    set_preview_winblend(trt, prompt_bufnr, blend)

    if not existing_attach then
      return true
    end

    local keep_mappings = existing_attach(prompt_bufnr, map)
    if keep_mappings == false then
      return false
    end

    return true
  end

  return picker_opts
end

---@return VvnTelescopeRuntime
local build_telescope_runtime = function()
  -- Build all expensive/shared dependencies once and pass them around as a
  -- runtime context. This keeps callback code lean and avoids repeated require
  -- calls.
  ---@type VvnTelescopeRuntime
  local trt = {
    bufutil = require("vvn.bufutil"),
    gitutil = require("vvn.gitutil"),
    telescope = require("telescope"),
    builtin = require("telescope.builtin"),
    telescope_actions = require("telescope.actions"),
    action_state = require("telescope.actions.state"),
    telescope_state = require("telescope.state"),
    which_key = require("which-key"),
    telescope_config = require("telescope.config"),
    trouble_open = require("trouble.sources.telescope").open,
    egrepify_toggle_prefixes = require("telescope._extensions.egrepify.actions").toggle_prefixes,
    vimgrep_arguments = {},
    telescope_ivy = {},
  }

  trt.vimgrep_arguments = vim.list_extend(
    vim.deepcopy(trt.telescope_config.values.vimgrep_arguments),
    vim.list_extend({ "--hidden" }, vim.deepcopy(rg_glob_exclusions))
  )

  trt.telescope_ivy = with_preview_winblend(
    trt,
    require("telescope.themes").get_ivy({
      enable_preview = true,
      layout_config = {
        height = 0.5,
      },
      winblend = 30,
    }),
    10
  )

  return trt
end

---@param entry string|table|nil
---@return string|nil
local entry_to_clipboard_text = function(entry)
  if not entry then
    return nil
  end

  if type(entry) == "string" then
    return entry
  end

  if type(entry.path) == "string" then
    return entry.path
  end

  if type(entry.filename) == "string" then
    return entry.filename
  end

  if type(entry.value) == "string" then
    return entry.value
  end

  if type(entry[1]) == "string" then
    return entry[1]
  end

  if entry.ordinal then
    return tostring(entry.ordinal)
  end

  return vim.inspect(entry)
end

---@param entry table|string|nil
---@return integer|nil
local get_buffer_entry_bufnr = function(entry)
  if type(entry) ~= "table" then
    return nil
  end

  if type(entry.bufnr) == "number" then
    return entry.bufnr
  end

  if type(entry.value) == "number" then
    return entry.value
  end

  return nil
end

---@param trt VvnTelescopeRuntime
---@return VvnTelescopeActions
local create_telescope_actions = function(trt)
  -- Group related picker actions in one place so keymap wiring stays small and
  -- behavior changes are localized.
  ---@type VvnTelescopeActions
  local A = {}

  ---@param prompt_bufnr integer
  A.copy_selected_entries = function(prompt_bufnr)
    ---@type table
    local picker = trt.action_state.get_current_picker(prompt_bufnr)
    ---@type table[]
    local multi = picker:get_multi_selection()
    ---@type string[]
    local lines = {}

    if #multi > 0 then
      for _, entry in ipairs(multi) do
        local text = entry_to_clipboard_text(entry)
        if text and text ~= "" then
          table.insert(lines, text)
        end
      end
    else
      local entry = trt.action_state.get_selected_entry()
      local text = entry_to_clipboard_text(entry)
      if text and text ~= "" then
        table.insert(lines, text)
      end
    end

    if #lines == 0 then
      Snacks.notifier.notify("Telescope <C-x>: No entry selected", "warn")
      return
    end

    vim.fn.setreg("+", table.concat(lines, "\n"))
    Snacks.notifier.notify(
      string.format("Copied %d Telescope entr%s", #lines, #lines == 1 and "y" or "ies"),
      "info"
    )
    trt.telescope_actions.close(prompt_bufnr)
  end

  ---@param prompt_bufnr integer
  local open_buffer_in_existing_window = function(prompt_bufnr)
    local selection = trt.action_state.get_selected_entry()
    local target_bufnr = get_buffer_entry_bufnr(selection)

    if not target_bufnr then
      Snacks.notifier.notify("Telescope buffers: No buffer selected", "warn")
      return
    end

    trt.telescope_actions.close(prompt_bufnr)
    local did_focus = trt.bufutil.focus_buffer(target_bufnr)
    if did_focus then
      return
    end

    Snacks.notifier.notify("Telescope buffers: Selected buffer is no longer valid", "warn")
  end

  ---@param prompt_bufnr integer
  ---@param map fun(mode: string, lhs: string, rhs: function)
  ---@return boolean
  A.attach_buffers_existing_window_mappings = function(prompt_bufnr, map)
    local jump_existing = function()
      open_buffer_in_existing_window(prompt_bufnr)
    end

    map("n", "<CR>", jump_existing)
    map("i", "<CR>", jump_existing)
    map("n", "<C-g>", jump_existing)
    map("i", "<C-g>", jump_existing)

    return true
  end

  ---@param prompt_bufnr integer
  A.open_oil = function(prompt_bufnr)
    local selection = trt.action_state.get_selected_entry()
    if not selection then
      Snacks.notifier.notify("Open oil <C-o>: No entry selected", "warn")
      return
    end

    local dir = pathutil.dir_or_parent(selection.path)
    if not dir then
      Snacks.notifier.notify(
        "Open oil <C-o>:" .. selection.path .. " could not be resolved as a directory.",
        "warn"
      )
      return
    end

    trt.telescope_actions.close(prompt_bufnr)
    require("oil").open_float(dir)
  end

  A.open_find_files_in_new_tab = function()
    local cwd, is_git = trt.gitutil.get_project_root()
    vim.cmd.tabnew()
    trt.builtin.find_files({
      prompt_title = get_prompt("Files (tab) ", is_git),
      cwd = cwd,
    })
  end

  return A
end

---@param trt VvnTelescopeRuntime
---@param A VvnTelescopeActions
local setup_telescope_plugin = function(trt, A)
  -- Core telescope setup: extensions + defaults + picker mappings.
  pcall(trt.telescope.load_extension, "fzf")
  pcall(trt.telescope.load_extension, "egrepify")

  local telescope_options = {
    defaults = {
      vimgrep_arguments = trt.vimgrep_arguments,
      winblend = 30,
      layout_strategy = "bottom_pane",
      sorting_strategy = "ascending",
      layout_config = {
        height = 0.5,
        preview_cutoff = 1,
        horizontal = {
          preview_width = 0.68,
        },
        vertical = {
          preview_height = 0.68,
        },
      },
      mappings = {
        n = {
          ["<C-q>"] = trt.trouble_open,
          ["<C-o>"] = A.open_oil,
          ["<C-h>"] = trt.telescope_actions.select_horizontal,
          ["<C-x>"] = A.copy_selected_entries,
        },
        i = {
          ["<C-q>"] = trt.trouble_open,
          ["<C-o>"] = A.open_oil,
          ["<C-e>"] = trt.egrepify_toggle_prefixes,
          ["<C-h>"] = trt.telescope_actions.select_horizontal,
          ["<C-x>"] = A.copy_selected_entries,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = rg_cmd,
      },
    },
    extensions = {
      fzf = {},
    },
  }

  trt.telescope.setup(telescope_options)
end

---@param trt VvnTelescopeRuntime
local setup_uncategorized_keymaps = function(trt)
  -- Small utility search mappings that don't fit other groups.
  vim.keymap.set({ "n" }, "<leader>/", function()
    trt.builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy({
      winblend = 10,
      previewer = false,
      skip_empty_lines = true,
    }))
  end, NOREMAP("[/] Fuzzy search current buffer"))

  vim.keymap.set({ "n" }, "<leader>cl", function()
    trt.builtin.colorscheme()
  end, NOREMAP("Chose [c]o[l]ourschemes"))

  vim.keymap.set({ "n" }, "<leader>ss", function()
    trt.builtin.resume()
  end, NOREMAP("Re[s]ume telescope"))
end

---@param trt VvnTelescopeRuntime
---@param A VvnTelescopeActions
local setup_standard_keymaps = function(trt, A)
  -- Main day-to-day search mappings for files, grep, buffers, and history.
  vim.keymap.set("n", "<leader>b", function()
    trt.builtin.find_files({
      prompt_title = "Files in buffer dir",
      cwd = trt.bufutil.current_buffer_dir(),
      find_command = fd_cmd_d1,
    })
  end, { desc = "Search [b]uffer's directory" })

  vim.keymap.set("n", "<leader>sb", function()
    trt.builtin.find_files({
      prompt_title = "Files in buffer dir recursively",
      cwd = trt.bufutil.current_buffer_dir(),
      find_command = fd_cmd,
    })
  end, { desc = "Search [b]uffer's directory recursively" })

  trt.which_key.add({ "s", group = "+Search fuzzy" })

  vim.keymap.set("n", "<leader>sf", function()
    local cwd, is_git = trt.gitutil.get_project_root()
    trt.builtin.find_files({
      prompt_title = get_prompt("Files ", is_git),
      cwd = cwd,
    })
  end, { desc = "[s]earch [f]iles in project (cwd/git)" })

  vim.keymap.set("n", "<leader>se", function()
    local cwd, is_git = trt.gitutil.get_project_root()
    trt.builtin.find_files({
      prompt_title = get_prompt("Folders ", is_git),
      cwd = cwd,
      find_command = fd_cmd_dir,
    })
  end, { desc = "[s]earch files in [e]xplorer (cwd/git)" })

  vim.keymap.set("n", "<leader>sp", function()
    trt.builtin.git_files({
      show_untracked = true,
    })
  end, { desc = "[s]earch [p]roject files, (also [s][f])" })

  vim.keymap.set("n", "<leader>sl", function()
    local cwd, is_git = trt.gitutil.get_project_root()
    trt.builtin.live_grep({
      prompt_title = get_prompt("Live Grep ", is_git),
      cwd = cwd,
    })
  end, { desc = "[s]earch [l]ive in project" })

  vim.keymap.set("n", "<leader>sr", function()
    local cwd, is_git = trt.gitutil.get_project_root()
    trt.telescope.extensions.egrepify.egrepify({
      prompt_title = get_prompt("Enhanced Grep ", is_git),
      cwd = cwd,
    })
  end, { desc = "Enhanced [s]search with [r]ipgrep flags" })

  vim.keymap.set("n", "\\b", function()
    trt.builtin.buffers({
      attach_mappings = A.attach_buffers_existing_window_mappings,
    })
  end, { desc = "[s]earch [b]uffers (jump existing <CR>/<C-g>)" })

  vim.keymap.set("n", "<leader>so", trt.builtin.oldfiles, { desc = "[s]earch [o]ld files" })

  vim.keymap.set("n", "<leader>sc", function()
    trt.builtin.command_history(trt.telescope_ivy)
  end, { desc = "[s]earch [c]ommands in history" })

  vim.keymap.set("n", "<leader>st", function()
    A.open_find_files_in_new_tab()
  end, { desc = "[s]earch files in new [t]ab" })

  vim.keymap.set("n", "<leader>sh", trt.builtin.help_tags, { desc = "[s]earch [h]elp tags" })

  vim.keymap.set("n", "<leader>sy", function()
    trt.builtin.symbols(trt.telescope_ivy)
  end, { desc = "[s]earch s[y]mbols" })

  vim.keymap.set("n", "\\m", function()
    trt.builtin.marks(trt.telescope_ivy)
  end, { desc = "search [m]arks" })

  vim.keymap.set("n", "\\r", function()
    trt.builtin.registers(trt.telescope_ivy)
  end, { desc = "search [r]egisters" })

  vim.keymap.set("n", "\\k", function()
    trt.builtin.keymaps(trt.telescope_ivy)
  end, { desc = "search [k]eymaps" })
end

---@param trt VvnTelescopeRuntime
local setup_favourite_location_keymaps = function(trt)
  -- User-specific frequently visited locations (`<leader>e*` and `<leader>z*`).
  trt.which_key.add({ "e", group = "+Edit config" })
  trt.which_key.add({ "z", group = "+Live grep config" })

  local favourite_edit_grep = function(key, path, prompt_part, desc_part)
    local expanded_path = vim.fn.expand(path)
    if not vim.fn.isdirectory(expanded_path) then
      return
    end

    vim.keymap.set("n", "<leader>e" .. key, function()
      trt.builtin.find_files({
        prompt_title = "Search " .. prompt_part .. " files",
        cwd = expanded_path,
      })
    end, { desc = "[e]dit " .. desc_part .. " files" })

    vim.keymap.set("n", "<leader>z" .. key, function()
      trt.builtin.live_grep({
        prompt_title = "Live grep " .. prompt_part .. " files",
        cwd = expanded_path,
      })
    end, { desc = "[z]ive grep " .. desc_part .. " files" })
  end

  favourite_edit_grep("a", "~/.config/alacritty/", "Alacritty", "[a]lacritty")
  favourite_edit_grep("b", "~/dot-bash/", "bash", "[b]ash")
  favourite_edit_grep("c", "~/.local/share/chezmoi/", "Chezmoi", "[c]hezmoi")
  favourite_edit_grep("d", "~/Dropbox", "Dropbox", "[d]ropbox")
  favourite_edit_grep("f", "~/.config/fish/", "Fish", "[f]ish")
  favourite_edit_grep("g", "~/.config/ghostty/", "Ghostty", "[g]hostty")
  favourite_edit_grep("h", "~/.config/hypr/", "Hyprland", "[h]yprland")
  favourite_edit_grep("l", "~/.config/lazygit/", "LayzGit", "[l]azygit")
  favourite_edit_grep("n", vim.fn.stdpath("config"), "Neovim", "[n]vim")
  favourite_edit_grep("m", "~/code/mine/", "My code", "[m]y code")
  favourite_edit_grep("o", "~/obsidian/", "Obsidian", "[o]bsidian")
  favourite_edit_grep("t", "~/dot-tmux/", "tmux", "[t]mux")
  favourite_edit_grep("v", "~/.config/vvnraman/", "vvnraman config", "[v]vnraman config")
  favourite_edit_grep("w", "~/.config/waybar/", "Waybar", "[w]aybar")
end

local telescope_setup = function()
  -- Compose setup from small focused sections to keep this file maintainable
  -- while staying in a single module.
  local trt = build_telescope_runtime()
  local A = create_telescope_actions(trt)

  setup_telescope_plugin(trt, A)
  setup_uncategorized_keymaps(trt)
  setup_standard_keymaps(trt, A)
  setup_favourite_location_keymaps(trt)
end

local M = {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    -- this keeps in the indentation in check in the config.
    config = telescope_setup,
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
      {
        -- spec elsewhere
        "folke/trouble.nvim",
      },
      {
        "nvim-tree/nvim-web-devicons",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
      {
        "stevearc/oil.nvim",
      },
      {
        -- https://github.com/fdschmidt93/telescope-egrepify.nvim
        "fdschmidt93/telescope-egrepify.nvim",
      },
    },
  },
}

return M
