-- https://github.com/AckslD/nvim-neoclip.lua
local ok, neoclip = pcall(require, "neoclip")
if not ok then
    print("'AckslD/nvim-neoclip.lua' not available")
    return
end

local function is_whitespace(line)
    return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
    for _, entry in ipairs(tbl) do
        if not check(entry) then
            return false
        end
    end
    return true
end

neoclip.setup({
    enable_persistent_history = true,
    filter = function(data)
        return not all(data.event.regcontents, is_whitespace)
    end,
})

if OK_TELESCOPE then
    -- TELESCOPE.load_extension("neoclip")
    VIM_KEYMAP_SET({ "n" }, "<leader>cl", "<Cmd>Telescope neoclip<Cr>")
end
