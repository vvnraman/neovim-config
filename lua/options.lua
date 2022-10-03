local vimopt = vim.opt

vimopt.belloff = "all"
-- Specifies for which events the bell will not be rung. It is a comma-
-- separated list of items. For each item that is present, the bell will be
-- silenced. This is most useful to specify specific events in insert mode to
-- be silenced.
-------------------------------------------------------------------------------

vim.g.mapleader = " "
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

vimopt.backup = false
-- Make a backup before overwriting a file.  Leave it around after the
-------------------------------------------------------------------------------

vimopt.cmdheight = 2
-- Number of screen lines to use for the command-line.  Helps avoiding
-------------------------------------------------------------------------------

vimopt.completeopt = { "menuone", "noselect" }
-- A comma-separated list of options for Insert mode completion
-- |ins-completion|.
-- menuone
--    Use the popup menu also when there is only one match. Useful when there
--    is additional information about the match, e.g., what file it comes from.
-- noselect
--    Do not select a match in the menu, force the user to select one from the
--    menu. Only works in combination with "menu" or "menuone".
-------------------------------------------------------------------------------

vimopt.conceallevel = 0
-- Determine how text with the "conceal" syntax attribute |:syn-conceal| is
-- shown:
-- 0		Text is shown normally
-------------------------------------------------------------------------------

vimopt.fileencoding = "utf-8"
-------------------------------------------------------------------------------

vimopt.hlsearch = true
-- When there is a previous search pattern, highlight all its matches.
vimopt.ignorecase = false
vimopt.smartcase = true
-- This I don't understand
-------------------------------------------------------------------------------

vimopt.mouse = "a"
-------------------------------------------------------------------------------

vimopt.wildignore = { "*.o", "*~", "*.pyc", "*pycache*" }
-- A list of file patterns.  A file that matches with one of these patterns is
-- ignored when expanding |wildcards|, completing file or directory names, and
-- influences the result of |expand()|, |glob()| and |globpath()| unless a flag
-- is passed to disable this.
-------------------------------------------------------------------------------

vimopt.pumblend = 20
vimopt.pumheight = 15
-- Popup menu options
-- pumblend - Enables pseudo-transparency for the |popup-menu|
-- pumheight - Popup menu height
-------------------------------------------------------------------------------

vimopt.showtabline = 2
-------------------------------------------------------------------------------

vimopt.smartindent = true

-------------------------------------------------------------------------------
-- formatoptions default: "tcqj"
--  + "t" -- Auto-wrap text using textwidth
--  + "c" -- Auto-wrap comments using textwidth, inserting the current comment
--  -- leader automatically.
--  + "q" -- Allow formatting of comments with "gq".
--  + "j" -- Where it makes sense, remove a comment leader when joining lines.

vimopt.formatoptions:append("rn1")
--  + "r" -- Automatically insert the current comment leader after hitting
--  -- <Enter> in Insert mode.
--  + "n" -- When formatting text, recognize numbered lists.
--  + "1" -- Don't break a line after a one-letter word. It's broken before it
--  -- instead (if possible).

vimopt.formatoptions:remove("oa2")
--  - "o" -- Automatically insert the current comment leader after hitting 'o' or
--  -- 'O' in Normal mode. In case comment is unwanted in a specific place
--  - "a" -- Automatic formatting of paragraphs. Every time text is inserted or
--  -- deleted the paragraph will be reformatted. See |auto-format|.
--  - "2" -- When formatting text, use the indent of the second line of a
--  -- paragraph for the rest of the paragraph, instead of the indent of
--  -- the first line. This supports paragraphs in which the first line has
--  -- a

vimopt.joinspaces = false

-- Concept credit: https://github.com/tjdevries
-------------------------------------------------------------------------------

vimopt.splitbelow = true
-- When on, splitting a window will put the new window below the current one.
vimopt.splitright = true
-- When on, splitting a window will put the new window right of the current
-- one.
-------------------------------------------------------------------------------

vimopt.swapfile = false
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
-- Characters to fill the statuslines and vertical separators
-------------------------------------------------------------------------------

vimopt.termguicolors = true
-- Enables 24-bit RGB color in the |TUI|. Uses "gui" |:highlight|
-------------------------------------------------------------------------------

vimopt.timeoutlen = 800
-- Time in milliseconds to wait for a mapped sequence to complete.
-------------------------------------------------------------------------------

vimopt.undofile = true
-------------------------------------------------------------------------------

vimopt.updatetime = 300
-- If this many milliseconds nothing is typed the swap file will be written to
-- disk (see |crash-recovery|). Also used for the |CursorHold| autocommand
-- event.
-------------------------------------------------------------------------------

vimopt.expandtab = true
vimopt.shiftwidth = 2
vimopt.tabstop = 2
-- Tab settings
-- expandtab
--  In Insert mode: Use the appropriate number of spaces to insert a tab
-- shiftwidth
--  Number of spaces to use for each step of (auto)indent
-- tabstop
--  Number of spaces that a <Tab> in the file counts for
-------------------------------------------------------------------------------

vimopt.number = true
-- Print the line number in front of each line.  When the 'n' option is
vimopt.relativenumber = true
-- Show the line number relative to the line with the cursor in front of
-- each line. Relative line numbers help you use the |count| you can
-------------------------------------------------------------------------------

vimopt.signcolumn = "yes"
-- When and how to draw the signcolumn.
--  "yes" always
-------------------------------------------------------------------------------

vimopt.wrap = true
-- This option changes how text is displayed.  It doesn't change the text
-- in the buffer, see 'textwidth' for that.
-------------------------------------------------------------------------------

vimopt.scrolloff = 5
-- Minimal number of screen lines to keep above and below the cursor.
-------------------------------------------------------------------------------

vimopt.sidescrolloff = 8
-- The minimal number of screen columns to keep to the left and to the right of
-- the cursor if 'nowrap' is set.
-------------------------------------------------------------------------------

vimopt.laststatus = 2
-- The value of this option influences when the last window will have a status
-- line:
--  0: never
-- 	1: only if there are at least two windows
-- 	2: always
-- 	3: always and ONLY the last window
-------------------------------------------------------------------------------

vimopt.backspace = { "eol", "start", "indent" }
-- Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
--  indent
--    allow backspacing over autoindent
--  eol
--    allow backspacing over line breaks (join lines)
--  start
--    allow backspacing over the start of insert; CTRL-W and CTRL-U stop once
--    at the start of insert.
--  nostop
--    like start, except CTRL-W and CTRL-U do not stop at the start of insert.
-------------------------------------------------------------------------------

vimopt.whichwrap = vimopt.whichwrap
    + "<" -- <   <Left>    Normal and Visual
    + ">" -- >   <Right>   Normal and Visual
    + "h" -- h   "h"       Normal and Visual (not recommended)
    + "l" -- l   "l"       Normal and Visual (not recommended)
-- This was from my vimrc. I don't really know why these are there though.
-- The docs now say "h" and "l" are not recommended.
-------------------------------------------------------------------------------

vimopt.list = true
-- List mode: By default, show tabs as ">", trailing spaces as "-", and
-- non-breakable space characters as "+". Useful to see the difference between
-- tabs and spaces and for trailing blanks. Further changed by
-- set listchars=tab:»·,trail:·,extends:↪,precedes:↩
vimopt.listchars = {
    tab = "»·",
    trail = "·",
    extends = "↪",
    precedes = "↩",
}
-------------------------------------------------------------------------------

vimopt.shada = {
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

vim.opt.background = "dark"
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
