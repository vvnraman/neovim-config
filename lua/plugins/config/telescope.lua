local M = {}

M.setup = function()
  local telescope = require("telescope")
  local telescope_builtin = require("telescope.builtin")
  local which_key = require("which-key")
  local trouble_telescope = require("trouble.sources.telescope")

  pcall(telescope.load_extension, "fzf")
  telescope.load_extension("luasnip")
  telescope.load_extension("file_browser")

  local file_browser = telescope.extensions.file_browser

  telescope.setup({
    defaults = {
      file_ignore_patterns = {
        "^.git/",
      },
      mappings = {
        i = { ["<C-q>"] = trouble_telescope.open },
        n = { ["<C-q>"] = trouble_telescope.open },
      },
    },
    extensions = {
      fzf = {},
      file_browser = {},
    },
  })

  --[[==========================================================================
  Find project root directory
  - If the current buffer is inside a git repo, then this is root of the repo
  - Otherwise, this is the current working directory.

  I use git worktrees extensively for version control. So this means that if I
  navigate to a file in another worktree inside of the same git project, this
  will give me the root of that worktree. This is expected behaviour, as I
  would like to navigate to files inside of the other worktree.
  --]]
  --------------------------------------------------------------------------

  local get_project_root = function()
    -- code adapted from nvim-kickstart.nvim

    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == "" then
      current_dir = cwd
    else
      -- Extract the directory from the current file's path
      current_dir = vim.fn.fnamemodify(current_file, ":h")
    end

    -- find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist(
      "git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel"
    )[1]
    if vim.v.shell_error == 0 then
      local is_git_true = true
      return git_root, is_git_true
    else
      local is_git_false = false
      print("Using current working directory, no git repo found")
      return cwd, is_git_false
    end
  end

  local get_prompt = function(prefix, is_git)
    if is_git then
      return "Git " .. prefix
    else
      return "CWD " .. prefix
    end
  end

  ------------------------------------------------------------------------------

  --[[==========================================================================
  Uncategorized search mappings
  --]]
  --------------------------------------------------------------------------
  vim.keymap.set({ "n" }, "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      winblend = 10,
      previewer = false,
      skip_empty_lines = true,
    }))
  end, NOREMAP("[/] Fuzzy search current buffer"))

  vim.keymap.set({ "n" }, "<leader>cl", function()
    telescope_builtin.colorscheme(require("telescope.themes").get_ivy({
      enable_preview = true,
      winblend = 30,
    }))
  end, NOREMAP("Chose [c]o[l]ourschemes"))

  vim.keymap.set({ "n" }, "<leader>ss", function()
    telescope_builtin.resume()
  end, NOREMAP("Re[s]ume telescope"))
  ------------------------------------------------------------------------------

  --[[==========================================================================
  Standard fuzzy search and file browser mappings
  --]]
  --------------------------------------------------------------------------

  -- TODO: There seems to be an abstraction here between the highlighted letters
  -- in the description and the keymaps. I would like to automatically obtain
  -- the keymap, given a description with highlighted letters.

  vim.keymap.set("n", "<leader>b", function()
    telescope_builtin.find_files({
      prompt_title = "Current buffer directory",
      cwd = require("telescope.utils").buffer_dir(),
      hidden = true,
    })
  end, { desc = "search files in [b]uffer's directory" })

  which_key.add({ "s", group = "+Search fuzzy" })
  vim.keymap.set("n", "<leader>sf", function()
    local cwd, is_git = get_project_root()
    -- if is_git then
    --   telescope_builtin.git_files({
    --     show_untracked = true,
    --   })
    --   return
    -- end

    -- FIXME: I don't want '.git' contents to be shown, but I do want all
    --        hidden files to be shown. Using `find_files` with
    --        `hidden = true` shows '.git' folder contents as well. For now
    --        I'm using `file_ignore_patterns` configuration to ignore '.git'.
    --        I'd like to find out a more local way to do this in this method
    --        itself.
    --        The `git_files` block above was one way to deal with it.
    telescope_builtin.find_files({
      prompt_title = get_prompt("Files ", is_git),
      cwd = cwd,
      hidden = true,
    })
  end, { desc = "[s]earch [f]iles in project (cwd/git)" })
  vim.keymap.set("n", "<leader>sg", function()
    telescope_builtin.git_files({
      show_untracked = true,
      hidden = true,
    })
  end, { desc = "[s]earch [g]it files, also see [s][f]" })
  vim.keymap.set("n", "<leader>sl", function()
    local cwd, is_git = get_project_root()
    telescope_builtin.live_grep({
      prompt_title = get_prompt("Live Grep ", is_git),
      cwd = cwd,
      hidden = true,
    })
  end, { desc = "[s]earch pattern [l]ive in project" })
  vim.keymap.set("n", "\\b", telescope_builtin.buffers, { desc = "[s]earch [b]uffers" })
  vim.keymap.set(
    "n",
    "<leader>so",
    telescope_builtin.oldfiles,
    { desc = "[s]earch [o]ld files" }
  )
  vim.keymap.set("n", "<leader>sc", function()
    telescope_builtin.command_history(require("telescope.themes").get_dropdown({
      winblend = 20,
      skip_empty_lines = true,
    }))
  end, { desc = "[s]earch [c]ommands in history" })
  vim.keymap.set("n", "<leader>st", function()
    telescope_builtin.search_history(require("telescope.themes").get_dropdown({
      winblend = 20,
      skip_empty_lines = true,
    }))
  end, { desc = "[s]earch his[t]ory" })
  vim.keymap.set(
    "n",
    "<leader>sh",
    telescope_builtin.help_tags,
    { desc = "[s]earch [h]elp tags" }
  )

  vim.keymap.set("n", "<leader>sm", function()
    telescope_builtin.marks(require("telescope.themes").get_ivy({
      winblend = 20,
      skip_empty_lines = true,
    }))
  end, { desc = "[s]earch [m]arks" })
  vim.keymap.set("n", "<leader>sr", function()
    telescope_builtin.registers(require("telescope.themes").get_dropdown({
      winblend = 20,
      skip_empty_lines = true,
    }))
  end, { desc = "[s]earch [r]egisters" })
  vim.keymap.set("n", "<leader>sk", function()
    telescope_builtin.keymaps(require("telescope.themes").get_dropdown({
      winblend = 20,
      skip_empty_lines = true,
    }))
  end, { desc = "[s]earch [k]eymaps" })

  ------------------------------------------------------------------------------

  --[[==========================================================================
  find_files` and `file_browser` for custom locations which I need to visit
  often
  - `z` - fuzzy files in location
  - `e` - explore location
  --]]
  --------------------------------------------------------------------------

  which_key.add({ "e", group = "+Edit configs" })
  vim.keymap.set("n", "<leader>en", function()
    telescope_builtin.find_files({
      prompt_title = "Neovim config fuzzy",
      cwd = vim.fn.stdpath("config"),
      hidden = true,
    })
  end, { desc = "[e]dit [n]vim config" })
  vim.keymap.set("n", "<leader>ej", function()
    telescope_builtin.find_files({
      prompt_title = "Journal files fuzzy",
      cwd = "~/code/notes/journal/journal/",
      hidden = true,
    })
  end, { desc = "fu[z]zy find in [j]ournal" })
  vim.keymap.set("n", "<leader>eb", function()
    telescope_builtin.find_files({
      prompt_title = "bash config fuzzy",
      cwd = "~/dot-bash/",
      hidden = true,
    })
  end, { desc = "fu[z]zy find [b]ash config" })
  vim.keymap.set("n", "<leader>et", function()
    telescope_builtin.find_files({
      prompt_title = "tmux config fuzzy",
      cwd = "~/dot-tmux/",
      hidden = true,
    })
  end, { desc = "fu[z]zy find [t]mux config" })

  ------------------------------------------------------------------------------
end

return M
