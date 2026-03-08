************************
2026 Docker test harness
************************

2026-02
=======

We have added a docker based end-to-end testing harness to ensure that our
neovim config actually works on the OS we use it on.

The neovim version is pinned so in theory it is possible to update the version
and test if everything will still work as intended.

See also:

- :doc:`../explanation/docker-setup`
- :doc:`../how-to/test-in-docker`

Behavioral model
----------------

We can use the harness to run either manual validation or automated smoke
checks for specific OS/profile targets (for example, Arch standard or Ubuntu
minimal) without changing your local setup.

- There is an **Interactive workflow** for manually verifying that the config
  works as intended. It launches Neovim in a Docker container for visual
  validation and is useful for debugging.

- There is a **Smoke-test workflow** for fast, non-interactive checks. It runs
  one or more targets in a single command, which is useful when comparing
  ``standard`` and ``minimal`` behavior.

We can use the profile targets to verify expected behavior directly: run
``standard`` when we want the full setup path, and run ``minimal`` when we
want to confirm clean startup and core editing behavior without automatic
Neovim-managed installs.
