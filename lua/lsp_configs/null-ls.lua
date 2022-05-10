-- https://github.com/jose-elias-alvarez/null-ls.nvim
local ok, null_ls = pcall(require, "null-ls")
if not ok then
    return
end

local null_ls_formatting = null_ls.builtins.formatting
local null_ls_diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    sources = {
        -- lua
        -- https://github.com/johnnymorganz/stylua
        null_ls_formatting.stylua,

        -- pipx install black
        null_ls_formatting.black,

        -- pipx install isort
        null_ls_formatting.isort,

        -- pipx install flake8
        null_ls_diagnostics.flake8,
    },
})
