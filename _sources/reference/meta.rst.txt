.. _documentation-meta:

******************
Documentation Meta
******************

This page is the source of truth for how this repository writes and maintains
documentation.

Source of truth and structure
=============================

- Docs source lives under ``docs/`` as ``.rst`` files.
- Keep the toctree structure coherent across:

  - ``docs/how-to/``
  - ``docs/explanation/``
  - ``docs/reference/``

- Do not hand-edit generated output under ``docs/_build/``.
- Under ``docs/reference/project/``, keep ``index.rst``, ``changelog.rst``,
  and ``plan.rst`` maintained.
- Keep project changelog entries concise with 3-5 word summaries and links to
  dated files.

Tense and history rules
=======================

- Only changelog pages describe what changed, what was removed, or how behavior
  used to work.
- Changelog pages may use past tense when they record project history.
- How-to, explanation, and reference pages describe the current behavior only.
- When behavior changes, describe the current behavior and link the relevant
  changelog entry instead of describing the older behavior.

How-to and reference writing preferences
========================================

- Prefer task-first runbook style: show runnable commands first, then short
  context.
- Keep pages concise and scannable: short sections, direct headings, minimal
  prose.
- Include operational guardrails explicitly, such as dry-run vs destructive
  behavior and branch or worktree preconditions.
- Include practical defaults and real-world usage notes when they affect
  command choice.
- For CLI reference pages, prefer generated command output snapshots under
  ``docs/generated/`` and include them with ``literalinclude``.
- Exclude non-essential narrative, long rationale, abstract architecture, and
  generic commentary from how-to and reference pages.

Project changelog file conventions
==================================

- Use dated filename format ``YYYY-MM-mmm-<slug>.rst``.
- In ``docs/reference/project/changelog.rst``, visible labels use month-key
  style ``YYYY-MM-mmm - ...``.
- In ``docs/reference/project/changelog.rst``, keep sections in reverse
  chronological order: newest year first, then older years.
- Within each year section, insert new entries at the top so newer month-key
  entries appear before older ones.
- In each dated changelog page:

  - The title stays ``YYYY-MM mmm - <summary>``.
  - The first subsection heading is ``YYYY-MM-DD - Day``.
  - Immediately after that heading, add exactly one plain sentence line.
  - Use section heading ``Change summary``.
  - Use ``:ref:`` links to connect changelog entries to explanation pages and
    explanation pages back to changelog entries.

- Changelog entries are historical artifacts. When removing large code or doc
  sections, do not delete or rewrite historical changelog summaries.
- If a changelog ``:ref:`` target is removed, keep the historical mention and
  replace only the broken ``:ref:`` item with plain text under ``Related
  docs``. Use a ``code-block:: text`` list of removed doc paths.

Explanation docs: writing style
===============================

Write explanation pages as operational runbooks for maintainers.

Required style:

- Prefer procedural wording with verbs like ``loads``, ``sources``,
  ``includes``, and ``resolves``.
- Use present tense to describe behavior.
- Focus on runtime behavior and include order, not abstract architecture
  claims.
- Do not over-explain. Keep explanation pages lean and focused on how the
  config works.
- Prefer plain, non-technical language. Use technical terms only when they name
  a file, command, API, setting, or behavior the reader needs.
- Remove non-essential narrative, long rationale, and repeated path
  explanations.
- Keep sections compact and scannable. Use lists when they read better than
  paragraphs.
- Keep list formatting consistent. Add one blank line between numbered lists
  and bullet lists.
- Use short, explicit bullets.
- Replace vague shorthand with concrete behavior. State what the code loads,
  skips, compares, or writes, and why that step exists.
- When introducing a code-specific term, define it in the same section or
  rephrase it in plain language.

Do not:

- Repeat full relative paths in bullets when the path already appears in a file
  tree.
- Add broad statements that cannot be verified from config files.
- Keep sections that do not help a maintainer trace behavior.
- Copy large code blocks into explanation pages when the surrounding text does
  not add useful context.

Explanation docs: structure pattern
===================================

For module pages such as file navigation, Treesitter, and LSP, use this order
unless a tool-specific exception is requested:

1. One concise intro stating intent and scope.
2. ``High-level structure`` with a compact tree block.
3. Short bullets that describe the high-level flow.
4. Focused flow sections only where they add value.
5. ``Relevant changelogs`` with links to project entries.

Omit sections that only duplicate code, restate nearby bullets, or add no clear
payoff for the reader.

Literal include requirements
============================

When documenting source or include edges, use ``literalinclude`` snippets from
actual config files.

Each such snippet must include:

- ``:lineno-match:``
- ``:emphasize-lines:`` highlighting the include, source, or resolve lines
- ``:caption:`` with basename only

Additional rules:

- Keep snippet ranges tight. Include only the lines needed to show the
  behavior.
- Ensure emphasized line numbers match the displayed snippet range.
- Do not include more than 2-3 emphasized blocks.
- Rebuild docs after edits and resolve warnings before finishing.

Explanation docs: layout generation and section conventions
===========================================================

Preserve the current explanation-page layout workflow for tool pages.

Tree layout section rules:

- Use heading ``Directory layout``, ``Overall structure``, or ``Logical flow``
  as appropriate.
- Keep this section layout-only. Do not add explanatory prose under the
  heading.
- Wrap the layout include in a ``sphinx-design`` dropdown.
- The dropdown label is exactly ``Show layout``.
- Use generated layout files from ``docs/generated/`` when they are available.
- For generated layout includes, use ``:caption:`` with the relative config
  directory path.
- Render generated layout includes with ``:language: sh``.

Sphinx-generated layout implementation rules:

- Implement layout generation in Sphinx hooks within ``docs/conf.py``.
- Generate snapshots into ``docs/generated/``.
- Command preference order is:

  1. ``lsd --almost-all --tree``
  2. ``tree``
  3. ``ls -al <config-dir>/*``

- Resolve the available tool choice once per build when possible.
- Write generated files only when content changes to prevent live-reload loops.
- Keep generated layout artifact extension as ``.txt``.
