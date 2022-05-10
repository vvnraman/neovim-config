-- https://github.com/nvim-telescope/telescope.nvim
local OK_TELESCOPE, TELESCOPE = pcall(require, "telescope")
if not OK_TELESCOPE then
    print('"nvim-telescope/telescope.nvim" not available')
    return
end

local open_with_trouble = nil
local ok_trouble, trouble = pcall(require, "trouble")
if ok_trouble then
    open_with_trouble = trouble.open_with_trouble
else
    print(
        '"folke/trouble.nvim" not available, for use in "nvim-telescope/nvim-telescope"'
    )
end

local TELESCOPE_BUILTIN = require("telescope.builtin")
local telescope_extensions = TELESCOPE.extensions

TELESCOPE.setup({
    defaults = {

        prompt_prefix = " ",
        selection_caret = "📌 ",
        path_display = { "smart" },

        mappings = {
            i = { ["<C-t>"] = open_with_trouble },
            n = { ["<C-t>"] = open_with_trouble },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        frecency = {
            show_scores = true,
            db_safe_mode = false,
        },
    },
})

-- Extensions
TELESCOPE.load_extension("fzf")
TELESCOPE.load_extension("frecency")
TELESCOPE.load_extension("luasnip")
TELESCOPE.load_extension("file_browser")
TELESCOPE.load_extension("packer")

local project_files = function()
    local opts = {}
    local ok_git_files = pcall(TELESCOPE_BUILTIN.git_files, opts)
    if not ok_git_files then
        TELESCOPE_BUILTIN.find_files(opts)
    end
end

-- Builtins
vim.keymap.set({ "n" }, "<leader>ff", function()
    TELESCOPE_BUILTIN.find_files()
end)
vim.keymap.set({ "n" }, "<leader>fp", function()
    project_files()
end)
vim.keymap.set({ "n" }, "<leader>fl", function()
    TELESCOPE_BUILTIN.live_grep()
end)
vim.keymap.set({ "n" }, "<leader>fb", function()
    TELESCOPE_BUILTIN.buffers()
end)
vim.keymap.set({ "n" }, "<leader>fh", function()
    TELESCOPE_BUILTIN.help_tags()
end)
vim.keymap.set({ "n" }, "<leader>ft", function()
    TELESCOPE_BUILTIN.builtin()
end)
vim.keymap.set({ "n" }, "<C-/>", function()
    TELESCOPE_BUILTIN.current_buffer_fuzzy_find()
end)
vim.keymap.set({ "n" }, "<leader>fo", function()
    TELESCOPE_BUILTIN.oldfiles()
end)
vim.keymap.set({ "n" }, "<leader>ch", function()
    TELESCOPE_BUILTIN.command_history()
end)
vim.keymap.set({ "n" }, "<leader>sh", function()
    TELESCOPE_BUILTIN.search_history()
end)

-- Custom locations
vim.keymap.set({ "n" }, "<leader>nv", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/.config/nvim/",
    })
end)
vim.keymap.set({ "n" }, "<leader>cz", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/.local/share/chezmoi/",
    })
end)

-- Extensions
vim.keymap.set({ "n" }, "<leader>fe", function()
    telescope_extensions.file_browser.file_browser()
end)
vim.keymap.set({ "n" }, "<leader>fq", function()
    telescope_extensions.frecency.frecency()
end)
vim.keymap.set({ "n" }, "<leader>fs", function()
    telescope_extensions.luasnip.luasnip()
end)
vim.keymap.set({ "n" }, "<leader>nd", function()
    telescope_extensions.file_browser.file_browser({
        path = "~/.config/nvim/",
        cwd_to_path = true,
    })
end)
