-- 'akinsho/bufferline.nvim'
local ok, bufferline = pcall(require, "bufferline")
if not ok then
    print('"akinsho/bufferline.nvim" not available')
    return
end
bufferline.setup({
    options = {
        mode = "tabs",
        diagnostics = "nvim_lsp",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
            },
        },
        separator_style = "slant",
        enforce_regular_tabs = true,
    },
})
