local M = {}

M.setup = function()
  local vanilla = require("plugins.config.lsp.vanilla")

  local on_attach = function(client, bufnr)
    vanilla.setup_native_buffer_mappings(client, bufnr)
    vanilla.setup_plugin_buffer_mappings(client, bufnr)
    vanilla.setup_autocmds(client, bufnr)
  end

  require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    capabilities = vanilla.capabilities,
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

return M
