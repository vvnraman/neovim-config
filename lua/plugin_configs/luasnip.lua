-- 'L3MON4D3/LuaSnip'
local ok_luasnip, luasnip = pcall(require, "luasnip")
if not ok_luasnip then
    print('"L3MON4D3/LuaSnip" not available')
    return
end

local types = require("luasnip.util.types")
local from_lua = require("luasnip.loaders.from_lua")

luasnip.config.set_config({
    -- Remember to keep around the last snippet, so that we can jump back into it
    -- even if we move outside of the selection
    history = true,

    -- Updates as we type, useful for dynamic snippets
    updateevents = "TextChanged,TextChangedI",
})

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })

-- LuaSnip choice nodes selection
vim.keymap.set({ "i" }, "<C-l>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end, { silent = true })

-- Quickly edit filetype specific snippet file
vim.keymap.set({ "n" }, "<leader>ls", function()
    from_lua.edit_snippet_files()
end)

-- Load our custom snippets
from_lua.load({ paths = "~/code/langs/luasnip_snippets" })
