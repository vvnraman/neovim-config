-- https://github.com/folke/tokyonight.nvim
local ok_tokyonight, _ = pcall(require, "tokyonight")
if ok_tokyonight then
    vim.g.tokyonight_style = "night"
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }
    vim.g.tokyonight_colors = { hint = "orange", error = "#FF0000" }
    -- vim.cmd([[colorscheme tokyonight]])
end

-- https://github.com/marko-cerovac/material.nvim
local ok_material, material = pcall(require, "material")
if ok_material then
    -- darker
    -- lighter
    -- oceanic
    -- palenight
    -- deep ocean
    vim.g.material_style = "deep ocean"
    material.setup({})
    -- vim.cmd([[colorscheme material]])
end

-- https://github.com/sam4llis/nvim-tundra
local ok_tundra, tundra = pcall(require, "nvim-tundra")
if ok_tundra then
    tundra.setup({
        plugins = {
            cmp = true,
            telescope = true,
        },
    })
    vim.cmd([[colorscheme tundra]])
end
