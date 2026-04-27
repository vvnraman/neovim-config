Scripting neovim config
=======================

An excellent `lua crash course`_ for ``Neovim`` is TJ's YouTube video
"Everything You Need To Start Writing Lua".

.. _`lua crash course`: https://www.youtube.com/watch?v=CuWfgiwI73Q

In Neovim, the `lua scripting API`_ consists of 3 layers

.. _`lua scripting API`: https://neovim.io/doc/user/lua-guide.html

1. The "Vim API", inherited from Vim.

   These are accessed through `vim.cmd`_ and ``vim.fn`` respectively.

.. _`vim.cmd`: https://neovim.io/doc/user/lua.html#vim.cmd()

2. The `Nvim API`_ written in C for use in remote plugins and GUIs.

   These are accessed through `vim.api`_.

.. _`Nvim API`: https://neovim.io/doc/user/api.html
.. _`vim.api`: https://neovim.io/doc/user/lua.html#vim.api

3. The "Lua API" written in and specifically for Lua. These are any other functions
   accessible through ``vim.*`` not mentioned already. See `lua-stdlib`_ for more.

.. _`lua-stdlib`: https://neovim.io/doc/user/lua.html#lua-stdlib


The `lua-guide` is worth reading through in its entirety and is pretty good.

.. _`lua-guide`: https://neovim.io/doc/user/lua-guide.html

Logging during plugin development
---------------------------------

Neovim has a built-in way to log thing which show up in ``:messages`` by
default. We use ``nvim-lua/plenary.nvim`` to log things specific to something
as follows

.. code-block:: lua
   :caption: lua/vvn/log.lua

   return require("plenary.log").new({
     plugin = "vvn.precious",
     level = "info",
   })

Then use it as follows

.. code-block:: lua

   local log = require("vvn.log")
   -- log.info("something")

The contents will show up in ``:messages`` as well as the log file ``vvn.precious.log`` in the ``log`` directory of ``stdpath``, which is ``~/.local/state/nvim/vvn.precious.log``.

.. tip:: 

   To see where ``stdpath`` is, run ``:=vim.fn.stdpath("log")``.
