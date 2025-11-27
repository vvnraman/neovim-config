**************************
2025 Miscellaneous changes
**************************

Any set of changes which don't need their own dedicated page go here.

2025-03-24
==========

- Updated all plugins

- Fixed all breaks in the plugin APIs

- Set linelength for ``stylua`` to ``96`` to see most ``vim.keymap.set()``
  calls on a single line.

- Moved plugin spec from ``lua/plugins/spec/<filename>.lua`` to
  ``lua/plugins/<filename>.lua``

- Moved some spec inside folders as ``lua/plugins/<folder>/init.lua``

  - Did this for LSP config by moving ``lua/plugins/spec/lsp.lua`` to
    ``lua/plugins/lsp/init.lua``.

  - Moved config for ``lsp`` from ``lua/plugins/config/lsp/`` to here, moving
    all ``lua/plugins/config/lsp/init.lua`` code inside
    ``lua/plugins/lsp/init.lua``.

TODO
----

- Move configs for ``neorg``, ``snippets``, ``telescope`` and ``treesitter``
  from ``lua/plugins/config`` to the corresponding location at
  ``lua/plugins/<folder>``.

- Profiles: see TODOs in ``lua/plugins/lsp/init.lua``
