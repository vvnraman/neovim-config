local rg_cmd = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
local fd_cmd = { "fd", "--type", "file", "--hidden", "--exclude", ".git/" }
local fd_cmd_dir = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/" }
local fd_cmd_d1 = fd_cmd
table.insert(fd_cmd_d1, "--max-depth")
table.insert(fd_cmd_d1, "1")

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
  -- If the buffer is not associated with a file, return cwd
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

local buffer_dir = function()
  return vim.fn.expand("%:p:h")
end

local get_prompt = function(prefix, is_git)
  if is_git then
    return "Git " .. prefix
  else
    return "CWD " .. prefix
  end
end

------------------------------------------------------------------------------

local telescope_setup = function()
  local telescope = require("telescope")
  local telescope_builtin = require("telescope.builtin")
  local which_key = require("which-key")
  local telescope_config = require("telescope.config")

  ---@diagnostic disable-next-line: unused-local
  local telescope_dropdown = require("telescope.themes").get_dropdown({
    winblend = 20,
    skip_empty_lines = true,
  })
  local telescope_ivy = require("telescope.themes").get_ivy({
    enable_preview = true,
    winblend = 30,
  })
  pcall(telescope.load_extension, "fzf")
  pcall(telescope.load_extension, "egrepify")

  -- Show hidden files, but ignore git files always
  -- Clone default telescope vimgrep config
  local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
  table.insert(vimgrep_arguments, "--hidden")
  table.insert(vimgrep_arguments, "--glob")
  table.insert(vimgrep_arguments, "!**/.git/*")

  -- Open a floating oil window at the location of the current selection.
  local open_oil = function(prompt_bufnr)
    ---@diagnostic disable-next-line: unused-local
    local log = require("vvn.log")

    local action_state = require("telescope.actions.state")
    local selection = action_state.get_selected_entry()

    if not selection then
      Snacks.notifier.notify("Open oil <C-o>: No entry selected", "warn")
      return
    end

    -- log.info(vim.inspect(selection))
    -- { "home/dot-vim/plugins.vim",
    --   index = 30,
    --   <metatable> = {
    --     __index = <function 1>,
    --     cwd = "/home/vvnraman/.local/share/chezmoi",
    --     display = <function 2>
    --   }
    -- }

    -- log.info(vim.inspect(selection.path))
    local dir = require("vvn.path").dir_or_parent(selection.path)
    -- log.info(vim.inspect(dir))
    if not dir then
      Snacks.notifier.notify(
        "Open oil <C-o>:" .. selection.path .. " could not be resolved as a directory.",
        "warn"
      )
      return
    end
    require("telescope.actions").close(prompt_bufnr)
    require("oil").open_float(dir)
  end

  telescope.setup({
    defaults = {
      vimgrep_arguments = vimgrep_arguments,
      mappings = {
        n = {
          ["<C-q>"] = require("trouble.sources.telescope").open,
          ["<C-o>"] = open_oil,
        },
        i = {
          ["<C-q>"] = require("trouble.sources.telescope").open,
          ["<C-o>"] = open_oil,
          ["<C-e>"] = require("telescope._extensions.egrepify.actions").toggle_prefixes,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = rg_cmd,
      },
    },
    extensions = {
      fzf = {},
    },
  })

  --[[==========================================================================
  Uncategorized search mappings
  --]]
  --------------------------------------------------------------------------
  vim.keymap.set({ "n" }, "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    telescope_builtin.current_buffer_fuzzy_find(require("telescope.themes").get_ivy({
      winblend = 10,
      previewer = false,
      skip_empty_lines = true,
    }))
  end, NOREMAP("[/] Fuzzy search current buffer"))

  vim.keymap.set({ "n" }, "<leader>cl", function()
    telescope_builtin.colorscheme()
  end, NOREMAP("Chose [c]o[l]ourschemes"))

  vim.keymap.set({ "n" }, "<leader>ss", function()
    telescope_builtin.resume()
  end, NOREMAP("Re[s]ume telescope"))
  ------------------------------------------------------------------------------

  --[[==========================================================================
  Standard fuzzy search and file browser mappings
  --]]
  --------------------------------------------------------------------------

  vim.keymap.set("n", "<leader>b", function()
    telescope_builtin.find_files({
      prompt_title = "Files in buffer dir",
      cwd = buffer_dir(),
      find_command = fd_cmd_d1,
    })
  end, { desc = "Search [b]uffer's directory" })

  vim.keymap.set("n", "<leader>sb", function()
    telescope_builtin.find_files({
      prompt_title = "Files in buffer dir recursively",
      cwd = buffer_dir(),
      find_command = fd_cmd,
    })
  end, { desc = "Search [b]uffer's directory recursively" })

  which_key.add({ "s", group = "+Search fuzzy" })

  vim.keymap.set("n", "<leader>sf", function()
    local cwd, is_git = get_project_root()
    telescope_builtin.find_files({
      prompt_title = get_prompt("Files ", is_git),
      cwd = cwd,
    })
  end, { desc = "[s]earch [f]iles in project (cwd/git)" })

  vim.keymap.set("n", "<leader>se", function()
    local cwd, is_git = get_project_root()
    telescope_builtin.find_files({
      prompt_title = get_prompt("Folders ", is_git),
      cwd = cwd,
      find_command = fd_cmd_dir,
    })
  end, { desc = "[s]earch files in [e]xplorer (cwd/git)" })

  vim.keymap.set("n", "<leader>sp", function()
    telescope_builtin.git_files({
      show_untracked = true,
    })
  end, { desc = "[s]earch [p]roject files, (also [s][f])" })

  vim.keymap.set("n", "<leader>sl", function()
    local cwd, is_git = get_project_root()
    telescope_builtin.live_grep({
      prompt_title = get_prompt("Live Grep ", is_git),
      cwd = cwd,
    })
  end, { desc = "[s]earch [l]ive in project" })

  vim.keymap.set("n", "<leader>sr", function()
    local cwd, is_git = get_project_root()
    telescope.extensions.egrepify.egrepify({
      prompt_title = get_prompt("Enhanced Grep ", is_git),
      cwd = cwd,
    })
  end, { desc = "Enhanced [s]search with [r]ipgrep flags" })

  vim.keymap.set("n", "\\b", telescope_builtin.buffers, { desc = "[s]earch [b]uffers" })

  vim.keymap.set(
    "n",
    "<leader>so",
    telescope_builtin.oldfiles,
    { desc = "[s]earch [o]ld files" }
  )

  vim.keymap.set("n", "<leader>sc", function()
    telescope_builtin.command_history(telescope_ivy)
  end, { desc = "[s]earch [c]ommands in history" })

  vim.keymap.set("n", "<leader>st", function()
    telescope_builtin.search_history(telescope_ivy)
  end, { desc = "[s]earch his[t]ory" })

  vim.keymap.set(
    "n",
    "<leader>sh",
    telescope_builtin.help_tags,
    { desc = "[s]earch [h]elp tags" }
  )

  vim.keymap.set("n", "<leader>sy", function()
    telescope_builtin.symbols(telescope_ivy)
  end, { desc = "[s]earch s[y]mbols" })

  vim.keymap.set("n", "\\m", function()
    telescope_builtin.marks(telescope_ivy)
  end, { desc = "search [m]arks" })

  vim.keymap.set("n", "\\r", function()
    telescope_builtin.registers(telescope_ivy)
  end, { desc = "search [r]egisters" })

  vim.keymap.set("n", "\\k", function()
    telescope_builtin.keymaps(telescope_ivy)
  end, { desc = "search [k]eymaps" })

  ------------------------------------------------------------------------------

  --[[==========================================================================
  `find_files` and `live_grep` for custom locations which I need to visit
  often
  - `e` - explore location
  - `z` - fuzzy files in location
  --]]
  --------------------------------------------------------------------------

  which_key.add({ "e", group = "+Edit config" })
  which_key.add({ "z", group = "+Live grep config" })

  local favourite_edit_grep = function(key, path, prompt_part, desc_part)
    vim.keymap.set("n", "<leader>e" .. key, function()
      telescope_builtin.find_files({
        prompt_title = "Search " .. prompt_part .. " config",
        cwd = path,
      })
    end, { desc = "[e]dit " .. desc_part .. " config" })

    vim.keymap.set("n", "<leader>z" .. key, function()
      telescope_builtin.live_grep({
        prompt_title = "Live grep " .. prompt_part .. " config",
        cwd = path,
      })
    end, { desc = "[z]ive grep " .. desc_part .. " config" })
  end

  -- <leader>en, <leader>zn
  favourite_edit_grep("n", vim.fn.stdpath("config"), "Neovim", "[n]vim")
  -- <leader>ec, <leader>zc
  favourite_edit_grep("c", "~/.local/share/chezmoi/", "Chezmoi", "[c]hezmoi")
  -- <leader>ef, <leader>zf
  favourite_edit_grep("f", "~/.config/fish/", "Fish", "[f]ish")
  -- <leader>eb, <leader>zb
  favourite_edit_grep("b", "~/dot-bash/", "bash", "[b]ash")
  -- <leader>et, <leader>zt
  favourite_edit_grep("t", "~/dot-tmux/", "tmux", "[t]mux")
end

local M = {
  {
    -- https://github.com/nvim-telescope/telescope.nvim
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    branch = "0.1.x",
    -- this keeps in the indentation in check in the config.
    config = telescope_setup,
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
      },
      {
        -- spec elsewhere
        "folke/which-key.nvim",
      },
      {
        -- spec elsewhere
        "folke/trouble.nvim",
      },
      {
        "nvim-tree/nvim-web-devicons",
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      {
        "nvim-telescope/telescope-symbols.nvim",
      },
      {
        "stevearc/oil.nvim",
      },
      {
        -- https://github.com/fdschmidt93/telescope-egrepify.nvim
        "fdschmidt93/telescope-egrepify.nvim",
      },
    },
  },
}

return M
