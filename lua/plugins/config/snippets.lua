local M = {}

M.setup = function()
  local luasnip = require("luasnip")
  luasnip.config.set_config({
    -- Remember to keep around the last snippet, so that we can jump back into it
    -- even if we move outside of the selection
    history = true,

    -- Updates as we type, useful for dynamic snippets
    updateevents = "TextChanged,TextChangedI",
  })

  -- TODO Watch tj's video again on luasnip and add some custom snippets
end

return M
