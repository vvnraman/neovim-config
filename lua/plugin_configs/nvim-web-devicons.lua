-- 'kyazdani42/nvim-web-devicons'
local ok, nvim_web_devicons = pcall(require, "nvim-web-devicons")
if not ok then
    print('"kyazdani42/nvim-web-devicons" not available')
    return
end
nvim_web_devicons.setup()
