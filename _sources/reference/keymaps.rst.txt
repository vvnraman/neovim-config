Keymaps Reference
=================

This document lists all keybindings defined in this Neovim configuration.
It is auto-generated from the Lua configuration files.

keymaps.lua
-----------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - i
     - jk
     - Alias for \<Esc\> key
     - keymaps.lua:27
   * - x
     - \<leader\>p
     - Put selection in black hole before pasting
     - keymaps.lua:30
   * - i
     - \<C-j\>
     - Move lines down
     - keymaps.lua:38
   * - i
     - \<C-k\>
     - Move lines up
     - keymaps.lua:39
   * - n
     - \<C-j\>
     - Move lines down
     - keymaps.lua:40
   * - n
     - \<C-k\>
     - Move lines up
     - keymaps.lua:41
   * - v
     - \<C-j\>
     - Move lines down
     - keymaps.lua:42
   * - v
     - \<C-k\>
     - Move lines up
     - keymaps.lua:43
   * - n, x
     - \<Up\>
     - Move \<Up\> in wrapped lines
     - keymaps.lua:46
   * - i
     - \<Up\>
     - Move \<Up\> in wrapped lines
     - keymaps.lua:47
   * - n, x
     - \<Down\>
     - Move \<Down\> in wrapped lines
     - keymaps.lua:48
   * - i
     - \<Down\>
     - Move \<Down\> in wrapped lines
     - keymaps.lua:49
   * - n
     - \<C-u\>
     - Scroll half-up with centered screen
     - keymaps.lua:52
   * - n
     - \<C-d\>
     - Scroll half-up with centered screen
     - keymaps.lua:53
   * - n
     - \\if
     - Show current buffer path
     - keymaps.lua:57
   * - n
     - \<C-Up\>
     - Resize window ⬆️ by 4
     - keymaps.lua:68
   * - n
     - \<C-Down\>
     - Resize window ⬇️ by 4
     - keymaps.lua:69
   * - n
     - \<C-Left\>
     - Resize window ⬅️ by 4
     - keymaps.lua:70
   * - n
     - \<C-Right\>
     - Resize window ➡️ by 4
     - keymaps.lua:76
   * - n
     - \<Tab\>
     - Next window in tab
     - keymaps.lua:86
   * - n
     - \<S-Tab\>
     - Previous window in tab
     - keymaps.lua:87
   * - n
     - ]t
     - → Next Tab
     - keymaps.lua:89
   * - n
     - [t
     - ← Prev Tab
     - keymaps.lua:90
   * - n
     - \<leader\>th
     - ↝ Move Tab Left
     - keymaps.lua:92
   * - n
     - \<leader\>tl
     - ↜ Move Tab Right
     - keymaps.lua:93
   * - n
     - \<leader\>\<leader\>n
     - Config: reload current lua file
     - keymaps.lua:101
   * - n
     - \<leader\>nr
     - Config: reload current line
     - keymaps.lua:107
   * - v
     - \<leader\>nr
     - Config: reload current line
     - keymaps.lua:108
   * - n
     - \<leader\>es
     - Open starship config
     - keymaps.lua:113
   * - n
     - \<leader\>cs
     - [c]olor [s]hades
     - keymaps.lua:123
   * - n
     - \<leader\>ch
     - [c]olor [h]ues
     - keymaps.lua:129

plugins/ai/opencode.lua
-----------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n, x
     - \<leader\>ai
     - [a]i ask about @this
     - plugins/ai/opencode.lua:28
   * - n, x
     - \<leader\>aa
     - [a]i [a]ppend @this with a new line
     - plugins/ai/opencode.lua:32
   * - n
     - \<leader\>as
     - [a]i [s]ubmit prompt
     - plugins/ai/opencode.lua:36
   * - n
     - \<leader\>ac
     - [a]i [c]lear prompt
     - plugins/ai/opencode.lua:40
   * - n
     - \<leader\>al
     - [a]i [s]elect action
     - plugins/ai/opencode.lua:44
   * - n, x
     - \<leader\>ae
     - [a]i [e]xplain @this
     - plugins/ai/opencode.lua:48
   * - n
     - \<leader\>af
     - [a]i [f]ix diagnostics
     - plugins/ai/opencode.lua:57
   * - n, x
     - go
     - opencode add range
     - plugins/ai/opencode.lua:62
   * - n
     - goo
     - opencode add line
     - plugins/ai/opencode.lua:67

plugins/expedition/cardio.lua
-----------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n, o, x
     - s
     - Flash forward
     - plugins/expedition/cardio.lua:27
   * - n, o, x
     - S
     - Flash backward
     - plugins/expedition/cardio.lua:30
   * - n, o, x
     - \<C-m\>
     - Flash current word
     - plugins/expedition/cardio.lua:33
   * - n, o, x
     - \<C-t\>
     - Flash Treesitter
     - plugins/expedition/cardio.lua:36
   * - n, o, x
     - \<C-h\>
     - Flash lines
     - plugins/expedition/cardio.lua:39
   * - o
     - r
     - Remote Flash
     - plugins/expedition/cardio.lua:46
   * - o, x
     - R
     - Treesitter Search
     - plugins/expedition/cardio.lua:49
   * - c
     - \<C-s\>
     - Toggle Flash Search
     - plugins/expedition/cardio.lua:52

plugins/expedition/rucking.lua
------------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>o
     - Oil: Toggle float
     - plugins/expedition/rucking.lua:58
   * - n
     - \<leader\>\<leader\>o
     - Oil: Open
     - plugins/expedition/rucking.lua:61

plugins/expedition/telescope.lua
--------------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>/
     - [/] Fuzzy search current buffer
     - plugins/expedition/telescope.lua:205
   * - n
     - \<leader\>cl
     - Chose [c]o[l]ourschemes
     - plugins/expedition/telescope.lua:214
   * - n
     - \<leader\>ss
     - Re[s]ume telescope
     - plugins/expedition/telescope.lua:218
   * - n
     - \<leader\>b
     - Search [b]uffer's directory
     - plugins/expedition/telescope.lua:228
   * - n
     - \<leader\>sb
     - Search [b]uffer's directory recursively
     - plugins/expedition/telescope.lua:236
   * - n
     - \<leader\>sf
     - [s]earch [f]iles in project (cwd/git)
     - plugins/expedition/telescope.lua:246
   * - n
     - \<leader\>se
     - [s]earch files in [e]xplorer (cwd/git)
     - plugins/expedition/telescope.lua:254
   * - n
     - \<leader\>sp
     - [s]earch [p]roject files, (also [s][f])
     - plugins/expedition/telescope.lua:263
   * - n
     - \<leader\>sl
     - [s]earch [l]ive in project
     - plugins/expedition/telescope.lua:269
   * - n
     - \<leader\>sr
     - Enhanced [s]search with [r]ipgrep flags
     - plugins/expedition/telescope.lua:277
   * - n
     - \\b
     - [s]earch [b]uffers
     - plugins/expedition/telescope.lua:285
   * - n
     - \<leader\>so
     - [s]earch [o]ld files
     - plugins/expedition/telescope.lua:287
   * - n
     - \<leader\>sc
     - [s]earch [c]ommands in history
     - plugins/expedition/telescope.lua:294
   * - n
     - \<leader\>st
     - [s]earch his[t]ory
     - plugins/expedition/telescope.lua:298
   * - n
     - \<leader\>sh
     - [s]earch [h]elp tags
     - plugins/expedition/telescope.lua:302
   * - n
     - \<leader\>sy
     - [s]earch s[y]mbols
     - plugins/expedition/telescope.lua:309
   * - n
     - \\m
     - search [m]arks
     - plugins/expedition/telescope.lua:313
   * - n
     - \\r
     - search [r]egisters
     - plugins/expedition/telescope.lua:317
   * - n
     - \\k
     - search [k]eymaps
     - plugins/expedition/telescope.lua:321
   * - n
     - ?
     - [no description]
     - plugins/expedition/telescope.lua:344

plugins/git.lua
---------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - ]c
     - Git hunk: next
     - plugins/git.lua:11
   * - n
     - [c
     - Git hunk: previous
     - plugins/git.lua:20
   * - n
     - \<leader\>hs
     - [s]tage
     - plugins/git.lua:36
   * - n
     - \<leader\>hr
     - [r]reset
     - plugins/git.lua:37
   * - n
     - \<leader\>hu
     - [u]ndo
     - plugins/git.lua:38
   * - n
     - \<leader\>hS
     - [S]tage buffer
     - plugins/git.lua:39
   * - n
     - \<leader\>hR
     - [R]eset buffer
     - plugins/git.lua:40
   * - n
     - \<leader\>hp
     - [p]review
     - plugins/git.lua:41
   * - n
     - \<leader\>hi
     - [i]nline preview
     - plugins/git.lua:42
   * - n
     - \<leader\>hb
     - [b]lame
     - plugins/git.lua:43
   * - n
     - \<leader\>hd
     - [d]iff - index
     - plugins/git.lua:46
   * - n
     - \<leader\>hD
     - [D]iff - commit
     - plugins/git.lua:47
   * - n
     - \<leader\>hl
     - toggle [l]ine blame
     - plugins/git.lua:52
   * - n
     - \<leader\>hL
     - toggle [L]ine highlight
     - plugins/git.lua:53
   * - o, x
     - ih
     - [i]nside hunk
     - plugins/git.lua:57
   * - n
     - \<leader\>gd
     - [g]it [d]iff index
     - plugins/git.lua:85
   * - n
     - \<leader\>gf
     - [g]it diff [f]ile
     - plugins/git.lua:88
   * - n
     - \<leader\>gm
     - [g]it diff [m]aster
     - plugins/git.lua:91
   * - n
     - \<leader\>gn
     - [g]it diff mai[n]
     - plugins/git.lua:94

plugins/hotkeys.lua
-------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>\<leader\>w
     - Which Key
     - plugins/hotkeys.lua:25

plugins/pde/attach.lua
----------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>lh
     - [h]over docs
     - plugins/pde/attach.lua:11
   * - n
     - \<leader\>lk
     - [k] - signature help
     - plugins/pde/attach.lua:12
   * - n
     - \<leader\>ld
     - [d]efinition
     - plugins/pde/attach.lua:13
   * - n
     - \<leader\>lD
     - [D]eclaration
     - plugins/pde/attach.lua:14
   * - n
     - \<leader\>lt
     - [t]ype definition
     - plugins/pde/attach.lua:15
   * - n
     - \<leader\>li
     - [i]mplementation
     - plugins/pde/attach.lua:16
   * - n
     - \<leader\>lr
     - [r]ename identifier
     - plugins/pde/attach.lua:17
   * - n
     - \<leader\>ll
     - in[l]ay hints
     - plugins/pde/attach.lua:19
   * - n, v
     - \<leader\>\<leader\>f
     - [f]ormat buffer
     - plugins/pde/attach.lua:28
   * - n
     - \<leader\>lf
     - re[f]erences
     - plugins/pde/attach.lua:40
   * - n
     - \<leader\>sd
     - lsp: [s]ymbols in [d]ocument
     - plugins/pde/attach.lua:46
   * - n, x
     - \<leader\>la
     - code [a]ctions
     - plugins/pde/attach.lua:63
   * - n
     - \\s
     - Clangd: [s]witch Cpp/Header file
     - plugins/pde/attach.lua:112
   * - n
     - \<leader\>\<leader\>s
     - Clangd: [s]ymbol info
     - plugins/pde/attach.lua:118

plugins/pde/lsp.lua
-------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - ]d
     - Next [d]iagnostic
     - plugins/pde/lsp.lua:20
   * - n
     - [d
     - Prev [d]iagnostic
     - plugins/pde/lsp.lua:24
   * - n
     - \\d
     - [d]iagnostics under cursor
     - plugins/pde/lsp.lua:28

plugins/pde/nifty.lua
---------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - {
     - Aerial Previous
     - plugins/pde/nifty.lua:75
   * - n
     - }
     - Aerial Next
     - plugins/pde/nifty.lua:81
   * - n
     - \\a
     - Aerial Toggle
     - plugins/pde/nifty.lua:89

plugins/persona/outfit.lua
--------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>\<leader\>t
     - tab: [t]ab list
     - plugins/persona/outfit.lua:27
   * - n
     - \\t
     - tab: [t]oggle
     - plugins/persona/outfit.lua:30

plugins/persona/physique.lua
----------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>zm
     - Toggle ZenMode
     - plugins/persona/physique.lua:8
   * - n
     - \<C-p\>
     - illuminate: [p]rev
     - plugins/persona/physique.lua:68
   * - n
     - \<C-n\>
     - illuminate: [n]ext
     - plugins/persona/physique.lua:69
   * - n
     - \<leader\>cc
     - [c]olorizer [c]olour toggle
     - plugins/persona/physique.lua:86
   * - n
     - \<leader\>cb
     - [c]olorizer [b]ackground
     - plugins/persona/physique.lua:93
   * - n
     - \<leader\>cf
     - [c]olorizer [f]oreground
     - plugins/persona/physique.lua:97
   * - n
     - \<leader\>cd
     - [c]olorizer [d]etach
     - plugins/persona/physique.lua:101

plugins/quagmire/quicker.lua
----------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \\q
     - Toggle quickfix
     - plugins/quagmire/quicker.lua:10
   * - n
     - \\l
     - Toggle loclist
     - plugins/quagmire/quicker.lua:15

plugins/session.lua
-------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \\st
     - [no description]
     - plugins/session.lua:73
   * - n
     - \\ss
     - Save current session.
     - plugins/session.lua:80
   * - n
     - \\sh
     - Search sessions
     - plugins/session.lua:81

plugins/snacks.lua
------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>nh
     - Show notification history
     - plugins/snacks.lua:38
   * - n
     - \<leader\>ne
     - Show error history
     - plugins/snacks.lua:42
   * - n
     - \<leader\>.
     - Toggle Scratch buffer
     - plugins/snacks.lua:46
   * - n
     - \<leader\>S
     - Select Scratch buffer
     - plugins/snacks.lua:49

plugins/treesitter/config.lua
-----------------------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - [c
     - Go to context
     - plugins/treesitter/config.lua:99

vvn/yank.lua
------------

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
     - Source
   * - n
     - \<leader\>yf
     - Yank current file path
     - vvn/yank.lua:498
   * - n
     - \<leader\>yr
     - Yank current file's cwd relative path
     - vvn/yank.lua:504
   * - n, x
     - \<leader\>yy
     - [y]ank current file and line(s)
     - vvn/yank.lua:510
   * - n, x
     - \<leader\>ya
     - [y]ank [a]ppend current file and line(s)
     - vvn/yank.lua:516
   * - n
     - \<leader\>dd
     - [d]ump [d]iagnostics to clipboard
     - vvn/yank.lua:522
   * - n
     - \<leader\>yd
     - [y]ank file, line and [d]iagnostics
     - vvn/yank.lua:528
   * - n
     - \<leader\>ys
     - [y]ank file and line [s]imple
     - vvn/yank.lua:534
