-- https://github.com/nvim-treesitter/nvim-treesitter
local ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not ok then
    print('"nvim-treesitter.configs" not available')
    return
end

treesitter_configs.setup({
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cmake",
        "cpp",
        "go",
        "json",
        "lua",
        "rust",
        "toml",
        "typescript",
        "vim",
        "yaml",
        "zig",
        "norg",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(lang, bufnr)
            return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 5000
        end,
    },
    incremental_selection = {
        enable = true,
        -- These are the default keymaps, which I can lookup via help, but still putting
        -- them here for easier access.
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>A"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
})
