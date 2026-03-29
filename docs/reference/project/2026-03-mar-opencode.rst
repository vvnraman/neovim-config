.. _changelog-2026-03-mar-opencode-plugin:

*******************************
2026-03 March - OpenCode plugin
*******************************

2026-03-07 - Saturday
=====================

Added `opencode.nvim`_ to interact with OpenCode instances running in
a separate tmux pane within the same cwd.

.. _opencode.nvim: https://github.com/nickjvandyke/opencode.nvim

Change summary
--------------

Keymaps

.. list-table::
   :header-rows: 1

   * - Mode
     - Key
     - Description
   * - n, x
     - \<leader\>ai
     - [a]i ask about @this
   * - n, x
     - \<leader\>aa
     - [a]i [a]ppend @this with a new line
   * - n
     - \<leader\>as
     - [a]i [s]ubmit prompt
   * - n
     - \<leader\>ac
     - [a]i [c]lear prompt
   * - n
     - \<leader\>al
     - [a]i [s]elect action
   * - n, x
     - \<leader\>ae
     - [a]i [e]xplain @this
   * - n
     - \<leader\>af
     - [a]i [f]ix diagnostics
   * - n, x
     - go
     - opencode add range
   * - n
     - goo
     - opencode add line

Future work
-----------

- I have a ``:VvnYank`` to allow for batch selecting items. I should tie it to review all changes using ``"<leader>ar"``.

- Add ``gl`` and ``gll`` to immediately send ``:VvnYank`` selection to OpenCode.
