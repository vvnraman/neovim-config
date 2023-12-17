-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
-- https://github.com/p00f/clangd_extensions.nvim
local M = {}

M.should_install = function() end

local root_files = {
  "compile_commands.json",
}
local root_dir_func = function(fname)
  return require("lspconfig.util").root_pattern(unpack(root_files))(fname)
end

local setup_clangd_mappings = function(_, bufnr)
  local which_key = require("which-key")

  -- https://github.com/p00f/clangd_extensions.nvim

  which_key.register({
    ["<leader>s"] = {
      "<Cmd>ClangdSwitchSourceHeader<Cr>",
      "Clangd: Switch Cpp/Header file",
    },
  }, { prefix = "<leader>", buffer = bufnr })

  require("clangd_extensions.inlay_hints").setup_autocmd()
  require("clangd_extensions.inlay_hints").set_inlay_hints()
end

M.setup = function()
  local vanilla = require("plugins.config.lsp.vanilla")

  local opts = {
    on_attach = function(client, bufnr)
      vanilla.setup_native_buffer_mappings(client, bufnr)
      vanilla.setup_plugin_buffer_mappings(client, bufnr)
      vanilla.setup_autocmds(client, bufnr)
      setup_clangd_mappings(client, bufnr)
    end,
    capabilities = vanilla.capabilities,
    root_dir = root_dir_func,
    single_file_support = false,
  }

  require("lspconfig").clangd.setup(opts)
end

return M
