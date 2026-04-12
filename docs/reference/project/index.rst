#######
Project
#######

.. toctree::
   :maxdepth: 1

   changelog
   plan

******
Vision
******

- Keep the Neovim config usable as a daily editor while larger changes are
  validated in separate worktrees and Docker images.
- Keep runtime behavior, verification workflows, and project history documented
  as the config evolves.

************
Current work
************

Prepare Neovim 0.12 rollout
===========================

- Keep host usage on the stable binary until Docker smoke tests and docs stay
  clean for Arch and Ubuntu.
- Track the current migration checklist in :ref:`project-plan`.

----

****
Next
****

- Continue host-side validation with a repo-local ``nvim-appimage`` before the
  distro-provided ``/usr/bin/nvim`` changes.
- Keep the Docker harness catching both first-run bootstrap failures and delayed
  startup/runtime failures.
