-- https://github.com/kosayoda/nvim-lightbulb
local ok, nvim_lightbulb = pcall(require, "nvim-lightbulb")
if not ok then
    return
end

nvim_lightbulb.setup({
    sign = {
        enabled = true,
        priority = 10,
    },
    float = {
        enabled = false,
    },
    virtual_text = {
        enabled = true,
        hl_mode = "blend",
    },
    status_text = {
        enabled = true,
        text_unavailable = "",
    },
})
