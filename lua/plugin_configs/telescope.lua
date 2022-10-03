-- https://github.com/nvim-telescope/telescope.nvim
OK_TELESCOPE, TELESCOPE = pcall(require, "telescope")
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

TELESCOPE_BUILTIN = require("telescope.builtin")
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
    },
})

-- Extensions
TELESCOPE.load_extension("fzf")
TELESCOPE.load_extension("luasnip")
TELESCOPE.load_extension("file_browser")
TELESCOPE.load_extension("packer")

local project_files = function()
    local ok_git_files = pcall(
        TELESCOPE_BUILTIN.git_files,
        { show_untracked = true }
    )
    if not ok_git_files then
        TELESCOPE_BUILTIN.find_files({})
    end
end

-- Builtins
vim.keymap.set({ "n" }, "<leader>ff", function()
    TELESCOPE_BUILTIN.find_files()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fp", function()
    project_files()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fg", function()
    TELESCOPE_BUILTIN.live_grep()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>ls", function()
    TELESCOPE_BUILTIN.buffers()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>ft", function()
    TELESCOPE_BUILTIN.builtin()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<C-_>", function()
    TELESCOPE_BUILTIN.current_buffer_fuzzy_find({
        previewer = false,
        skip_empty_lines = true,
    })
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>ht", function()
    TELESCOPE_BUILTIN.help_tags()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>ch", function()
    TELESCOPE_BUILTIN.command_history()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>sh", function()
    TELESCOPE_BUILTIN.search_history()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fo", function()
    TELESCOPE_BUILTIN.oldfiles()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fb", function()
    telescope_extensions.file_browser.file_browser()
end, NOREMAP_SILENT)

-- `find_files` and `file_browser` for custom locations which I need to visit
-- often
-- `fz` - Find fuzzy
--      - This is different from `ff` to avoid the `timeoutlen` delay
-- `fe` - File explorer
--      - This is different from `fb` to avoid the `timeoutlen` delay

-- Neovim
vim.keymap.set({ "n" }, "<leader>fzv", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/.config/nvim/",
    })
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fev", function()
    telescope_extensions.file_browser.file_browser({
        path = "~/.config/nvim/",
        cwd_to_path = true,
    })
end, NOREMAP_SILENT)

-- Chezmoi
vim.keymap.set({ "n" }, "<leader>fzc", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/.local/share/chezmoi/",
    })
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fec", function()
    telescope_extensions.file_browser.file_browser({
        path = "~/.local/share/chezmoi/",
        cwd_to_path = true,
    })
end, NOREMAP_SILENT)

-- Journal
vim.keymap.set({ "n" }, "<leader>fzj", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/code/notes/journal/journal/",
    })
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fej", function()
    telescope_extensions.file_browser.file_browser({
        path = "~/code/notes/journal/journal/",
        cwd_to_path = true,
    })
end, NOREMAP_SILENT)

-- Chezmoi
vim.keymap.set({ "n" }, "<leader>fzn", function()
    TELESCOPE_BUILTIN.find_files({
        cwd = "~/code/notes/notebook/notebook",
    })
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fen", function()
    telescope_extensions.file_browser.file_browser({
        path = "~/code/notes/notebook/notebook/",
        cwd_to_path = true,
    })
end, NOREMAP_SILENT)

-- Extensions
vim.keymap.set({ "n" }, "<leader>fq", function()
    telescope_extensions.frecency.frecency()
end, NOREMAP_SILENT)
vim.keymap.set({ "n" }, "<leader>fs", function()
    telescope_extensions.luasnip.luasnip()
end, NOREMAP_SILENT)
