.. _test-in-docker:

**************
Test in Docker
**************

See :ref:`docker-setup`.

Interactive workflow
====================

.. tabs::

   .. group-tab:: Arch

      Start shell with the script:

      * ``./docker/run-workflow.sh arch,standard``

      Start shell with Make:

      * ``make docker-shell-arch``

   .. group-tab:: Ubuntu

       Start shell with the script:

       * ``./docker/run-workflow.sh ubuntu,standard``
       * ``./docker/run-workflow.sh ubuntu,minimal``

       Start shell with Make:

       * ``make docker-shell-ubuntu``
       * ``make docker-shell-ubuntu-minimal``

Inside the container shell, run ``nvim``.


Smoke test workflow
===================

.. tabs::

   .. group-tab:: Arch

      Run smoke test:

      * ``./docker/run-workflow.sh --workflow smoke-test arch,standard``

   .. group-tab:: Ubuntu

       Run smoke test:

       * ``./docker/run-workflow.sh --workflow smoke-test ubuntu,standard``
       * ``./docker/run-workflow.sh --workflow smoke-test ubuntu,minimal``
