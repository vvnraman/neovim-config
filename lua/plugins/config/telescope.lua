local M = {}

M.setup = function()
  local telescope = require("telescope")
  local telescope_builtin = require("telescope.builtin")
  local which_key = require("which-key")
  local trouble_telescope = require("trouble.providers.telescope")

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
        i = { ["<C-q>"] = trouble_telescope.open_with_trouble },
        n = { ["<C-q>"] = trouble_telescope.open_with_trouble },
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
      "git -C "
        .. vim.fn.escape(current_dir, " ")
        .. " rev-parse --show-toplevel"
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
      return prefix .. "In Project Root (git)"
    else
      return prefix .. "In Current Working Dir"
    end
  end

  ------------------------------------------------------------------------------

  --[[==========================================================================
  Custom search functions using telescope
  --]]
  --------------------------------------------------------------------------

  -- fuzzy find file functions
  local find_files_in_cwd = function()
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
  end

  local find_files_in_buffer_dir = function()
    telescope_builtin.find_files({
      prompt_title = "Current buffer directory",
      cwd = require("telescope.utils").buffer_dir(),
      hidden = true,
    })
  end

  local find_files_under_git = function()
    telescope_builtin.git_files({
      show_untracked = true,
      hidden = true,
    })
  end

  -- grep functions
  local live_grep_in_project = function()
    local cwd, is_git = get_project_root()
    telescope_builtin.live_grep({
      prompt_title = get_prompt("Live Grep ", is_git),
      cwd = cwd,
      hidden = true,
    })
  end

  local grep_current_word_in_project = function()
    local cwd, is_git = get_project_root()
    telescope_builtin.grep_string({
      prompt_title = get_prompt("Current Word ", is_git),
      cwd = cwd,
      word_match = "-w",
    })
  end

  -- File browser functions
  local browse_files_in_cwd = function()
    local cwd, is_git = get_project_root()
    file_browser.file_browser({
      prompt_title = get_prompt("Browse Files ", is_git),
      cwd = cwd,
      prompt_path = true,
      hidden = true,
    })
  end

  local browse_files_in_buffer_dir = function()
    local cwd, is_git = get_project_root()
    file_browser.file_browser({
      prompt_title = get_prompt("Browse Files in ", is_git),
      cwd = cwd,
      prompt_path = true,
      hidden = true,
    })
  end

  local current_buffer_fuzzy_find = function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    telescope_builtin.current_buffer_fuzzy_find(
      require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        skip_empty_lines = true,
      })
    )
  end

  ------------------------------------------------------------------------------

  --[[==========================================================================
  Uncategorized search mappings
  --]]
  --------------------------------------------------------------------------
  vim.keymap.set({ "n" }, "<leader>/", function()
    current_buffer_fuzzy_find()
  end, NOREMAP("[/] Fuzzy search current buffer"))

  vim.keymap.set({ "n" }, "<leader>cl", function()
    telescope_builtin.colorscheme(require("telescope.themes").get_ivy({
      enable_preview = true,
      winblend = 30,
    }))
  end, NOREMAP("Chose [c]o[l]ourschemes"))

  vim.keymap.set({ "n" }, "\\s", function()
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

  -- leader is set at prefix at the end, just to avoid additional indentation
  which_key.register({
    ["b"] = {
      function()
        find_files_in_buffer_dir()
      end,
      "search files in [b]uffer's directory",
    },
  }, { prefix = "<leader>" })

  which_key.register({
    s = {
      name = "+Search fuzzy",
      f = {
        function()
          find_files_in_cwd()
        end,
        "[s]earch [f]iles in project (cwd/git)",
      },
      g = {
        function()
          find_files_under_git()
        end,
        "[s]earch [g]it files, also see [s][f]",
      },
      l = {
        function()
          live_grep_in_project()
        end,
        "[s]earch pattern [l]ive in project",
      },
      w = {
        function()
          grep_current_word_in_project()
        end,
        "[s]earch current [w]ord in project",
      },
      b = { telescope_builtin.buffers, "[s]earch open [b]uffers" },
      o = { telescope_builtin.oldfiles, "[s]earch [o]ld files" },
      c = {
        function()
          telescope_builtin.command_history(
            require("telescope.themes").get_dropdown({
              winblend = 20,
              skip_empty_lines = true,
            })
          )
        end,
        "[s]earch [c]ommands in history",
      },
      s = {
        function()
          telescope_builtin.search_history(
            require("telescope.themes").get_dropdown({
              winblend = 20,
              skip_empty_lines = true,
            })
          )
        end,
        "[s]earch [s]search history",
      },
      h = { telescope_builtin.help_tags, "[s]earch [h]elp tags" },
      m = {
        function()
          telescope_builtin.marks(require("telescope.themes").get_ivy({
            winblend = 30,
            skip_empty_lines = true,
          }))
        end,
        "[s]earch [m]arks",
      },
      r = {
        function()
          telescope_builtin.registers(require("telescope.themes").get_dropdown({
            winblend = 20,
            skip_empty_lines = true,
          }))
        end,
        "[s]earch [r]egisters",
      },
      k = {
        function()
          telescope_builtin.keymaps(require("telescope.themes").get_dropdown({
            winblend = 20,
            skip_empty_lines = true,
          }))
        end,
        "[s]earch [k]eymaps",
      },
    },
    e = {
      name = "+File [e]xplorer",
      w = {
        function()
          browse_files_in_cwd()
        end,
        "browser files in c[w]d",
      },
      e = {
        function()
          browse_files_in_buffer_dir()
        end,
        -- `b` would have been better here but `ee` is quicker to type
        "browse files in buff[e]r dir",
      },
    },
  }, { prefix = "<leader>" })

  ------------------------------------------------------------------------------

  --[[==========================================================================
  find_files` and `file_browser` for custom locations which I need to visit
  often
  - `z` - fuzzy files in location
  - `e` - explore location
  --]]
  --------------------------------------------------------------------------

  which_key.register({
    z = {
      name = "+Favourite locations fuzzy",
      n = {
        function()
          telescope_builtin.find_files({
            prompt_title = "Neovim config fuzzy",
            cwd = "~/.config/nvim",
            hidden = true,
          })
        end,
        "fu[z]zy find [n]eovim config",
      },
      j = {
        function()
          telescope_builtin.find_files({
            prompt_title = "Journal files fuzzy",
            cwd = "~/code/notes/journal/journal/",
            hidden = true,
          })
        end,
        "fu[z]zy find in [j]ournal",
      },
      b = {
        function()
          telescope_builtin.find_files({
            prompt_title = "bash config fuzzy",
            cwd = "~/dot-bash/",
            hidden = true,
          })
        end,
        "fu[z]zy find [b]ash config",
      },
      t = {
        function()
          telescope_builtin.find_files({
            prompt_title = "tmux config fuzzy",
            cwd = "~/dot-tmux/",
            hidden = true,
          })
        end,
        "fu[z]zy find [t]mux config",
      },
    },
    v = {
      name = "+Fa[v]ourite locations explore",
      n = {
        function()
          file_browser.file_browser({
            prompt_title = "Explore Neovim config",
            cwd = "~/.config/nvim",
            prompt_path = true,
            hidden = true,
          })
        end,
        "fa[v]: [n]eovim config folder",
      },
      j = {
        function()
          file_browser.file_browser({
            prompt_title = "Explore Journal",
            cwd = "~/code/notes/journal/journal/",
            prompt_path = true,
            hidden = true,
          })
        end,
        "fa[v]: [j]ournal folder",
      },
      b = {
        function()
          file_browser.file_browser({
            prompt_title = "Explore bash config",
            cwd = "~/dot-bash/",
            hidden = true,
          })
        end,
        "fa[v]: [b]ash config",
      },
      t = {
        function()
          file_browser.file_browser({
            prompt_title = "Explore tmux config",
            cwd = "~/dot-tmux/",
            hidden = true,
          })
        end,
        "fa[v]: [t]mux config",
      },
    },
  }, { prefix = "<leader>" })

  ------------------------------------------------------------------------------
end

return M
