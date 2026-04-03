-- [[ Highlight on yank ]]
---@return nil
local setup_highlight_on_yank = function()
  -- See `:help vim.highlight.on_yank()`
  local augroup = vim.api.nvim_create_augroup("vvn.YankHighlight", { clear = true })
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = augroup,
    pattern = "*",
  })
end

---@return nil
local highlight_active_buffer_cursor_line = function()
  local augroup = vim.api.nvim_create_augroup("vvn.cursor_line", { clear = true })
  vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    desc = "Highlight cursor line in active window",
    pattern = "*",
    command = "setlocal cursorline",
    group = augroup,
  })

  vim.api.nvim_create_autocmd("WinLeave", {
    desc = "Clear cursor line highlight when leaving window",
    pattern = "*",
    command = "if &bt != 'quickfix' | setlocal nocursorline | endif",
    group = augroup,
  })
end

---@return nil
local setup_sudo_write = function()
  vim.api.nvim_create_user_command("Wudo", function()
    local confirm =
      vim.fn.input("Write with sudo (use fingerprint in no password prompt shown)? (y/n): ")
    if confirm:lower() ~= "y" and confirm:lower() ~= "yes" then
      print("Not continuing to write")
      return
    end

    -- `--remove-timestamp` to always prompt for a password
    -- - This helps with fingerprint integration as there is no "GUI" to indicate to the user
    --   that they should scan their fingerprint.
    local success, result = pcall(vim.cmd, "w !sudo --reset-timestamp tee % >/dev/null")
    if success then
      print("Write successful with sudo")
      vim.cmd("edit!")
    else
      print("Failed to write with sudo : " .. vim.inspect(result))
    end
  end, { desc = "Write file with sudo" })
end

---@return nil
local setup_keymap_docs_command = function()
  vim.api.nvim_create_user_command("GenerateKeymapDocs", function()
    require("keymap_docs").generate()
  end, { desc = "Generate keymap documentation (docs/reference/keymaps.rst)" })
end

---@return nil
local setup_vvn_log_command = function()
  vim.api.nvim_create_user_command("VvnLog", function()
    local log_file = vim.fs.joinpath(vim.fn.stdpath("cache"), "vvn.log")
    vim.cmd("tabedit " .. vim.fn.fnameescape(log_file))
  end, { desc = "Open vvn log file in new tab" })
end

---@return nil
local setup_shared_lazy_root_update_warning = function()
  local profile = require("vvn.profile")
  if not profile.is_shared_lazy_install_root_enabled() then
    return
  end

  local augroup = vim.api.nvim_create_augroup("vvn.shared_lazy_root_warning", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = augroup,
    pattern = { "LazyUpdatePre", "LazySyncPre" },
    desc = "Block shared lazy root updates without explicit override",
    callback = function()
      local lazy_root = profile.get_lazy_install_root_dir()
      local lockfile = vim.fs.joinpath(vim.fn.stdpath("config"), "lazy-lock.json")
      local message = string.format(
        "Blocked plugin update for shared lazy root '%s'. Set VVN_NVIM_ALLOW_SHARED_LAZY_UPDATE=1 to allow updating shared plugin clones and writing '%s'.",
        lazy_root,
        lockfile
      )

      if not profile.is_shared_lazy_update_allowed() then
        vim.notify(message, vim.log.levels.ERROR, { title = "Shared lazy root" })
        error(message)
      end

      vim.notify(
        string.format(
          "Updating plugins from shared lazy root '%s'. This may drift '%s' from other Neovim configs using the same plugin checkout set.",
          lazy_root,
          lockfile
        ),
        vim.log.levels.WARN,
        { title = "Shared lazy root" }
      )
    end,
  })
end

setup_highlight_on_yank()
highlight_active_buffer_cursor_line()
setup_sudo_write()
setup_keymap_docs_command()
setup_vvn_log_command()
setup_shared_lazy_root_update_warning()
