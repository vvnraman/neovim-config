-- [[ Highlight on yank ]]
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

local setup_keymap_docs_command = function()
  vim.api.nvim_create_user_command("GenerateKeymapDocs", function()
    require("keymap_docs").generate()
  end, { desc = "Generate keymap documentation (docs/reference/keymaps.rst)" })
end

setup_highlight_on_yank()
highlight_active_buffer_cursor_line()
setup_sudo_write()
setup_keymap_docs_command()
