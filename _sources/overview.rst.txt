###############
Config overview
###############

Pre-requisites
==============

`ripgrep`_ and `fd`_ are installed on the system

* `ripgrep`_ - ``grep`` replacement

* `fd`_ - ``find`` replacement

.. _ripgrep: https://github.com/BurntSushi/ripgrep
.. _fd: https://github.com/sharkdp/fd

Config as a sphinx project
==========================

This is also a python project, primarily for generating sphinx docs, with `uv`_
driving the workflow.

.. _`uv`: https://docs.astral.sh/uv/

* Run ``uv sync`` to create a python virtual environment with all dependencies
  installed.

* Run ``uv run nvim-config --help`` to see available commands for generating docs.

  .. code-block:: console

     $ uv run nvim-config --help
     Usage: nvim-config [OPTIONS] COMMAND [ARGS]...

     Options:
       --install-completion [bash|zsh|fish|powershell|pwsh]
                                       Install completion for the specified shell.
       --show-completion [bash|zsh|fish|powershell|pwsh]
                                       Show completion for the specified shell, to
                                       copy it or customize the installation.
       --help                          Show this message and exit.

     Commands:
       info
       docs
       live
       clean
       init-docs

* A wrapper ``Makefile`` is present to keep the typing to a minimum

  .. code-block:: console

     $ make
     clean                          Clean generated docs
     docs                           Generate docs
     format                         Run stylua for all files in the lua directores
     help                           Show this help
     live                           Generate live docs
