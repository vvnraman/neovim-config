.. _yank-enhanced:

*************
Yank Enhanced
*************

The yank-enhanced flow is implemented in ``lua/vvn/yank.lua`` and uses shared
helpers from ``lua/vvn/util.lua``.

Keymaps
=======

- Primary mappings:

  - ``<leader>yy``: yank current line (or visual-line selection) as
    file-and-lines markdown.
  - ``<leader>ya``: append file-and-lines output.
  - ``<leader>yd``: yank ``file:line`` + line content + diagnostics.

- Additional mappings:

  - ``<leader>yf``: yank absolute file path.
  - ``<leader>yr``: yank path relative to current working directory.
  - ``<leader>dd``: yank diagnostics for current line.
  - ``<leader>ys``: yank ``file:line:content`` compact format.

User command
============

``:VvnYank`` supports explicit options:

- ``mode=set|append``
- ``kind=filepath|relative_path|file_and_lines|diagnostics|file_line_diagnostics|file_line_simple``

Defaults are:

- ``mode=set``
- ``kind=file_and_lines``

The command validates unknown/duplicate/invalid options and has completion for
``mode=`` and ``kind=``.

Examples:

- Yank current file path relative to current working directory:

  ``:VvnYank kind=relative_path``

- Yank current line with file and diagnostics:

  ``:VvnYank kind=file_line_diagnostics``

- Append current line/selection as markdown file-and-lines block:

  ``:VvnYank mode=append kind=file_and_lines``

File-and-lines append compaction
================================

Append mode supports compaction for repeated yanks from the same file and
filetype:

- First yank stores fenced markdown with path and line annotation.
- Additional appends from the same file add blocks inside the same fenced
  section.
- If source context changes (file/filetype/register mismatch), append falls back
  to newline-concatenated clipboard output.

The intent is to keep multi-line references readable and easy to paste into
issues, chat, and notes.

Example flow (modern C++)
-------------------------

Assume we are in ``src/math/vector.cpp`` and the filetype is ``cpp``.

1. Initial multi-line copy

   - Cursor on line ``12``.
   - Enter Visual-line mode, select lines ``12-18``, press ``<leader>yy``.

   Source lines:

   .. code-block:: cpp
      :linenos:
      :lineno-start: 12

      auto dot(const Vec3& a, const Vec3& b) noexcept -> double {
        return std::fma(a.x, b.x, std::fma(a.y, b.y, a.z * b.z));
      }

      auto norm(const Vec3& v) noexcept -> double {
        return std::sqrt(dot(v, v));
      }

   Register ``+`` after this step:

   .. code-block:: text

      src/math/vector.cpp
      ```cpp
      // lines 12-18
      auto dot(const Vec3& a, const Vec3& b) noexcept -> double {
        return std::fma(a.x, b.x, std::fma(a.y, b.y, a.z * b.z));
      }

      auto norm(const Vec3& v) noexcept -> double {
        return std::sqrt(dot(v, v));
      }
      ```

2. Append another block from the same file

   - Cursor on line ``24``.
   - Enter Visual-line mode, select lines ``24-29``, press ``<leader>ya``.

   Source lines:

   .. code-block:: cpp
      :linenos:
      :lineno-start: 24

      auto normalized(const Vec3& v) -> std::optional<Vec3> {
        const auto n = norm(v);
        if (n <= std::numeric_limits<double>::epsilon()) {
          return std::nullopt;
        }
        return Vec3{v.x / n, v.y / n, v.z / n};
      }

3. Final register content (compacted)

   The second append stays in the same fenced block because file path and
   filetype match:

   .. code-block:: text

      src/math/vector.cpp
      ```cpp
      // lines 12-18
      auto dot(const Vec3& a, const Vec3& b) noexcept -> double {
        return std::fma(a.x, b.x, std::fma(a.y, b.y, a.z * b.z));
      }

      auto norm(const Vec3& v) noexcept -> double {
        return std::sqrt(dot(v, v));
      }

      // lines 24-29
      auto normalized(const Vec3& v) -> std::optional<Vec3> {
        const auto n = norm(v);
        if (n <= std::numeric_limits<double>::epsilon()) {
          return std::nullopt;
        }
        return Vec3{v.x / n, v.y / n, v.z / n};
      }
      ```
