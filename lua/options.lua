vim.opt.belloff = "all"
-- Specifies for which events the bell will not be rung. It is a comma-
-- separated list of items. For each item that is present, the bell will be
-- silenced. This is most useful to specify specific events in insert mode to
-- be silenced.
-------------------------------------------------------------------------------

vim.wildmode = { "full", "longest", "lastused" }
-- Completion mode that is used for the character specified with 'wildchar'
-- "full"
--    Complete the next full match.  After the last match, the original string
--    is used and then the first match again.  Will also start 'wildmenu' if it
--    is enabled.
-- "longest"
--    Complete till longest common string.  If this doesn't result in a longer
--    string, use the next part.
-- "lastused"
--    When completing buffer names and more than one buffer matches, sort
--    buffers by time last used (other than the current buffer).
-------------------------------------------------------------------------------

vim.wildoptions = "pum"
-- Display the completion matches using the popupmenu in the same style as the
-- |ins-completion-menu|.
-------------------------------------------------------------------------------

vim.opt.cmdheight = 2
-- Number of screen lines to use for the command-line.  Helps avoiding
-------------------------------------------------------------------------------

vim.opt.completeopt = { "menuone", "preview", "noselect" }
-- A comma-separated list of options for Insert mode completion
-- |ins-completion|.
-- menuone
--    Use the popup menu also when there is only one match. Useful when there
--    is additional information about the match, e.g., what file it comes from.
-- preview  Show extra information about the currently selected
--    completion in the preview window.  Only works in
--    combination with "menu" or "menuone".
-- noselect
--    Do not select a match in the menu, force the user to select one from the
--    menu. Only works in combination with "menu" or "menuone".
-------------------------------------------------------------------------------

vim.opt.conceallevel = 0
-- Determine how text with the "conceal" syntax attribute |:syn-conceal| is
-- shown:
-- 0		Text is shown normally
-------------------------------------------------------------------------------

vim.opt.virtualedit = "block"
-- Virtual editing means that the cursor can be positioned where there is
-- no actual character.  This can be halfway into a tab or beyond the end
-- of the line.  Useful for selecting a rectangle in Visual mode and
-- editing a table.
-------------------------------------------------------------------------------

-- vim.opt.fileencoding = "utf-8"
-- 2023-12-17
--  - E5113 - modifiable is off, while loading after lazy.nvim
-------------------------------------------------------------------------------

vim.o.clipboard = "unnamedplus"
-- Still not too sure about this one. I have to test how this works with my QMK
-- config on the ZSA keyboards
-------------------------------------------------------------------------------

vim.opt.hlsearch = true
-- When there is a previous search pattern, highlight all its matches.
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Override the 'ignorecase' option if the search pattern contains upper
-- case characters.  Only used when the search pattern is typed and
-- 'ignorecase' option is on.  Used for the commands "/", "?", "n", "N",
-- ":g" and ":s".  Not used for "*", "#", "gd", tag search, etc.  After
-- "*" and "#" you can make 'smartcase' used by doing a "/" command,
-- recalling the search pattern from history and hitting <Enter>.
-- This I don't understand
-------------------------------------------------------------------------------

vim.opt.mouse = "a"
-------------------------------------------------------------------------------

vim.opt.wildignore = { "*.o", "*~", "*.pyc", "*pycache*" }
-- A list of file patterns.  A file that matches with one of these patterns is
-- ignored when expanding |wildcards|, completing file or directory names, and
-- influences the result of |expand()|, |glob()| and |globpath()| unless a flag
-- is passed to disable this.
-------------------------------------------------------------------------------

vim.opt.pumblend = 20
vim.opt.pumheight = 15
-- Popup menu options
-- pumblend - Enables pseudo-transparency for the |popup-menu|
-- pumheight - Popup menu height
-------------------------------------------------------------------------------

vim.opt.showtabline = 2
-------------------------------------------------------------------------------

vim.opt.smartindent = true

-------------------------------------------------------------------------------
--[[
formatoptions default: "tcqj"

"t" Auto-wrap text using textwidth

"c" Auto-wrap comments using textwidth, inserting the current comment leader
automatically.

"q" Allow formatting of comments with "gq".

"j" Where it makes sense, remove a comment leader when joining lines.

For more, see `:help fo-table`
]]

vim.opt.formatoptions:append("r")
--  "r" Automatically insert the current comment leader after hitting <Enter>
--  in Insert mode.

vim.opt.formatoptions:append("n")
--  "n" When formatting text, recognize numbered lists.

vim.opt.formatoptions:append("1")
--  "1" Don't break a line after a one-letter word. It's broken before it
--  instead (if possible).

vim.opt.formatoptions:append("2")
--  "2" When formatting text, use the indent of the second line of a paragraph
--  for the rest of the paragraph, instead of the indent of the first line.
--  This supports paragraphs in which the first line has a

vim.opt.formatoptions:remove("a")
--  "a" -- Automatic formatting of paragraphs. Every time text is inserted or
--  deleted the paragraph will be reformatted. See |auto-format|.
--
--  It is VERY VERY IMPORTANT to always keep a blankline between two paragraphs
--  with "a" set. Otherwise it leads to a very annoying battle with the editor.
--  Since that is something one would NOT do naturally, it seems wise to
--  disable auto-formatting.
--
--  Use `gww` to auto-format current line, while preserving cursor position, or
--  use `gw2j` to format the current and next line, while preserving cursor
--  position.

vim.opt.formatoptions:remove("o")
-- "o" Automatically insert the current comment leader after hitting 'o' or
-- 'O' in Normal mode. In case comment is unwanted in a specific place.
--
-- I do this as I typically add a comment before a set of C++ headers to place
-- them in a group. Then I press `o` or `O` to add the header, and hence
-- I don't want the next or previous line start with the comment.

vim.opt.joinspaces = false
-- Insert two spaces after a '.', '?' and '!' with a join command.
-- Otherwise only one space is inserted.

-- Concept credit: https://github.com/tjdevries
-------------------------------------------------------------------------------

vim.opt.splitbelow = true
-- When on, splitting a window will put the new window below the current one.
vim.opt.splitright = true
-- When on, splitting a window will put the new window right of the current
-- one.
-------------------------------------------------------------------------------

vim.opt.swapfile = false
-------------------------------------------------------------------------------

vim.opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}
-- Characters to fill the statuslines, vertical separators and special
-- lines in the window.
-------------------------------------------------------------------------------

vim.opt.termguicolors = true
-- Enables 24-bit RGB color in the |TUI|. Uses "gui" |:highlight|
-------------------------------------------------------------------------------

vim.opt.updatetime = 250
-- If this many milliseconds nothing is typed the swap file will be written to
-- disk (see |crash-recovery|). Also used for the |CursorHold| autocommand
-- event.
vim.opt.timeoutlen = 300
-- Time in milliseconds to wait for a mapped sequence to complete.
-------------------------------------------------------------------------------

vim.opt.undofile = true
-- When on, Vim automatically saves undo history to an undo file when
-- writing a buffer to a file, and restores undo history from the same
-- file on buffer read.
-------------------------------------------------------------------------------

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
-- Tab settings
-- expandtab
--  In Insert mode: Use the appropriate number of spaces to insert a tab
-- shiftwidth
--  Number of spaces to use for each step of (auto)indent
-- tabstop
--  Number of spaces that a <Tab> in the file counts for
-------------------------------------------------------------------------------

vim.opt.number = true
-- Print the line number in front of each line.
vim.opt.relativenumber = true
-- Show the line number relative to the line with the cursor in front of
-- each line.
-------------------------------------------------------------------------------

vim.opt.signcolumn = "yes"
-- When and how to draw the signcolumn.
--  "yes" always
-------------------------------------------------------------------------------

-- FIXME: This seems to be terribly slow
-- vim.opt.scrolloff = 5
-- Minimal number of screen lines to keep above and below the cursor.
-------------------------------------------------------------------------------

-- FIXME: This seems to be terribly slow
-- vim.opt.sidescrolloff = 8
-- The minimal number of screen columns to keep to the left and to the right of
-- the cursor if 'nowrap' is set.
-------------------------------------------------------------------------------

vim.opt.laststatus = 2
-- The value of this option influences when the last window will have a status
-- line:
--  0: never
-- 	1: only if there are at least two windows
-- 	2: always
-- 	3: always and ONLY the last window
-------------------------------------------------------------------------------

vim.opt.whichwrap = "bs<>[]"
--  b    <BS>	 Normal and Visual
--  s    <Space>	 Normal and Visual
--  <    <Left>	 Normal and Visual
--  >    <Right>	 Normal and Visual
--  [    <Left>	 Insert and Replace
--  ]    <Right>	 Insert and Replace
-- Allow specified keys that move the cursor left/right to move to the
-- previous/next line when the cursor is on the first/last character in
-- the line.  Concatenate characters to allow this for these keys:
-------------------------------------------------------------------------------

vim.opt.list = true
-- List mode: By default, show tabs as ">", trailing spaces as "-", and
-- non-breakable space characters as "+". Useful to see the difference between
-- tabs and spaces and for trailing blanks. Further changed by
-- set listchars=tab:»·,trail:·,extends:↪,precedes:↩
vim.opt.listchars = {
  tab = "»·",
  trail = "·",
  extends = "↪",
  precedes = "↩",
}
-------------------------------------------------------------------------------

vim.opt.shada = {
  "!", -- When included, save and restore global variables that start
  -- with an uppercase letter, and don't contain a lowercase
  -- letter.  Thus "KEEPTHIS and "K_L_M" are stored, but "KeepThis"
  -- and "_K_L_M" are not.  Nested List and Dict items may not be
  -- read back correctly, you end up with an empty item.
  "'1000",
  -- Maximum number of previously edited files for which the marks
  -- are remembered.  This parameter must always be included when
  -- 'shada' is non-empty.
  -- Including this item also means that the |jumplist| and the
  -- |changelist| are stored in the shada file.
  "<50", -- Maximum number of lines saved for each register.  If zero then
  -- registers are not saved.  When not included, all lines are
  "s100",
  -- Maximum size of an item contents in KiB.
  "h", -- Disable the effect of 'hlsearch' when loading the shada
  -- file. When not included, it depends on whether ":nohlsearch"
}
-- If you exit Vim and later start it again, you would normally lose a lot of
-- information.  The ShaDa file can be used to remember that information, which
-- enables you to continue where you left off.  Its name is the abbreviation of
-- SHAred DAta because it is used for sharing data between Neovim sessions.
--
-- This is introduced in section |21.3| of the user manual.
--
-- The ShaDa file is used to store:
-- - The command line history.
-- - The search string history.
-- - The input-line history.
-- - Contents of non-empty registers.
-- - Marks for several files.
-- - File marks, pointing to locations in files.
-- - Last search/substitute pattern (for 'n' and '&').
-- - The buffer list.
-- - Global variables.
-------------------------------------------------------------------------------

vim.opt.inccommand = "split"
-- When nonempty, shows the effects of |:substitute|, |:smagic|,
-- |:snomagic| and user commands with the |:command-preview| flag as you
-- type.
-------------------------------------------------------------------------------
