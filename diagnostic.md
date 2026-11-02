# Neovim diagnostic report

Generated 2026-11-02. Neovim v0.11.1, LazyVim, 65 plugins. **Nothing in the config was changed**; this file is the only thing written.

How this was produced: headless `nvim` startup messages, `:checkhealth` (full output, 358 lines), a per-filetype probe (opened 12 sample files and recorded LSP clients, treesitter, formatters and diagnostics), a static scan of all of `init.lua` and `lua/`, and a check of installed command-line tools.

Legend: **P0** breaks something now, **P1** a feature silently doesn't work, **P2** cleanup / deprecation, **P3** optional.

---

## 0. Summary (read this first)

| # | Pri | Problem | Easiest fix |
|---|-----|---------|-------------|
| 1 | P0 | `plugins/comment.lua` and `plugins/endhints.lua` return nothing, so lazy.nvim prints "Invalid spec module" at every startup | Add `return {}` at the end of each file (or delete both; the same plugins are already set up in `config/lazy.lua`) |
| 2 | P0 | `ripgrep`, `fd`, `lazygit`, `coreutils` and `findutils` are not installed | `brew install ripgrep fd lazygit coreutils findutils` |
| 3 | P0 | `init.lua` runs fzf-lua with `gfind`, which does not exist (GNU findutils missing), so fzf-lua file search fails | Same brew install as #2 (gives you `gfind`) |
| 4 | P1 | `tsserver` settings in `lsp.lua` and `react.lua` are never applied (LazyVim uses `vtsls`) | Rename the key to `vtsls` or delete the blocks (see §3.4) |
| 5 | P1 | `<leader>d` (DB UI) runs `NvimTreeClose`, a command that does not exist | Change `NvimTreeClose` to `Neotree close` in `ui.lua:110` |
| 6 | P1 | Duplicate keymaps: `<leader>tt`, `<leader>tf/tn/to/ts`, `<leader>db/dc/di/do/dr/dq`, `<leader>cd`, `<leader>Q`, `<C-j>` | Remove the copies in `react.lua` / keymaps (see §4) |
| 7 | P1 | Neotest python path is hard-coded to `./venv/bin/python` | Use venv-selector's python, or delete the `python = function()` override |
| 8 | P1 | `shellcheck`, `mypy`, `flake8`, `cpplint` are installed by Mason but no linter is wired to them (`lint=[]` for every filetype) | Remove them from Mason's list, or add `nvim-lint` linters |
| 9 | P2 | Deprecated Neovim 0.11 APIs: `vim.diagnostic.goto_next`, `vim.lsp.buf.inlay_hint(0,true)`, `lspconfig.util.root_pattern` | Replace with `vim.diagnostic.jump`, `vim.lsp.inlay_hint.enable()`, `vim.fs.root` |
| 10 | P2 | Two copies of the dadbod spec in `ui.lua`; a 170-line commented-out duplicate in `editor.lua` | Delete the second copy and the commented block |
| 11 | P2 | Treesitter pinned to `tag = "v0.9.1"` | Remove the `tag` line |
| 12 | P2 | Stray PDFs and an untracked PDF in the config repo | Move them out of `~/.config/nvim` |
| 13 | P3 | Image / mermaid / provider warnings from `:checkhealth` | Ignore, or install the optional tools in §6 |

Fixing #1 to #3 alone removes every startup error and makes the pickers and git UI work.

---

## 1. Startup errors (P0)

Every `nvim` launch prints:

```
Invalid spec module: `plugins.comment`
Expected a `table` of specs, but a `nil` was returned instead
Invalid spec module: `plugins.endhints`
Expected a `table` of specs, but a `nil` was returned instead
```

**Cause.** `lua/plugins/` is imported as a lazy.nvim spec directory (`{ import = "plugins" }`), so every file in it must `return` a table. These two call `require(...).setup()` directly and return nothing.

- `lua/plugins/comment.lua` (13 lines): calls `require("Comment").setup(...)` with `extra = false`.
- `lua/plugins/endhints.lua` (19 lines): calls `require("lsp-endhints").setup(...)` with icon and label options.

**Side effect, worse than the message.** Because they run as top-level code at import time (before plugins load), the `setup` calls either fail or run too early. The `lsp-endhints` icons and `truncateAtChars = 20` options may never apply.

**Easiest fix (pick one).**
1. Minimal: put `return {}` as the last line of both files. Silences the error, setup still runs eagerly.
2. Proper: wrap each in a spec, for example
   ```lua
   return { "chrisgrieser/nvim-lsp-endhints", event = "LspAttach", opts = { ...same table... } }
   ```
   and the same for `numToStr/Comment.nvim`. Note `config/lazy.lua` already declares both plugins with `opts = {}` / a `config` function, so the files can also simply be deleted (this is the least code).

---

## 2. Missing command-line tools (P0)

Checked with `command -v` and `brew list`. (Inside my own shell `rg` and `find` were wrapper functions, so I confirmed with `:checkhealth`, which reports `rg` and `fd` missing.)

| Tool | Status | Who needs it | Symptom |
|------|--------|--------------|---------|
| `rg` (ripgrep) | missing | Snacks picker grep, LazyVim live grep, telescope live_grep | Live grep fails |
| `fd` | missing | Snacks picker files/explorer | File picker errors (`fd v8.4 required`) |
| `lazygit` | missing | `lazygit.nvim` (`;c`), Snacks lazygit | `:LazyGit` fails |
| `coreutils` (`/opt/homebrew/opt/coreutils`) | missing | `init.lua` PATH prepend | Prepend points at a nonexistent dir |
| `findutils` (`gfind`) | missing | `init.lua` fzf-lua `cmd = "gfind . -type f -printf '%P\n'"` | fzf-lua `files` fails. Health also shows `find: illegal option -- -` because macOS BSD `find` is used |
| `jq` | present (`/usr/bin/jq`) | rest.nvim JSON formatter | OK |
| `tidy` | present | rest.nvim HTML formatter | OK |
| `tmux` | present | vim-tmux-navigator | OK |
| `node` 22, `python3`, `go`, `uv`, `tree-sitter`, `docker`, `git` | present | various | OK |
| `cargo`, `stylua`, `ruff`, `pyright` on PATH | missing from the shell | Mason installs its own copies inside nvim | OK inside nvim; only matters from a terminal |

**Easiest fix (one command):**

```bash
brew install ripgrep fd lazygit coreutils findutils
```

That fixes grep, file pickers, lazygit, fzf-lua and the `init.lua` PATH lines in one go.

---

## 3. Per-filetype results (live probe)

Opened a sample file of each type for 9 seconds in headless nvim:

| File | ft | LSP attached | Treesitter | Formatter | Notes |
|------|----|--------------|-----------|-----------|-------|
| `.py` | python | ruff, pyright | yes | black, isort | Works. Both ruff and pyright report diagnostics (3 found on the broken sample) |
| `.ts` | typescript | vtsls, emmet_ls | yes | prettier | Works (2 diagnostics on the broken sample) |
| `.tsx` | typescriptreact | vtsls, emmet_ls | yes | prettier | Works |
| `.lua` | lua | lua_ls | yes | stylua | Works |
| `.json` | json | jsonls | yes | prettier | Works (caught the trailing comma) |
| `.yaml` | yaml | yamlls | yes | prettier | Works |
| `.md` | markdown | none | yes | prettier | Fine; no markdown LSP is configured. Formatting only |
| `Dockerfile` | dockerfile | dockerls | yes | none | Works; no formatter exists for Dockerfiles |
| `.sh` | sh | **none** | yes | shfmt | No LSP and **no shellcheck** (see 3.2) |
| `.c` | c | clangd | yes | **none** | `clang-format` is installed but not hooked into conform (see 3.3) |
| `.css` | css | cssls, emmet_ls | yes | prettier | Works |
| `.html` | html | emmet_ls, html | yes | prettier | Works |

Overall: **language servers, treesitter and formatters work for every language you use.** The problems are in the linting layer and in config that is silently ignored.

### 3.1 Linters are not wired up (P1)

`linters_by_ft` is empty for every filetype, so nvim-lint runs nothing. The Mason list in `lsp.lua` installs `flake8`, `mypy`, `luacheck`, `shellcheck`, `pydocstyle`, `cpplint`, but nothing calls them. Python diagnostics come from ruff and pyright (LSP), which is already enough.

Easiest fix: delete the unused linters from the `ensure_installed` list in `lsp.lua` (`flake8`, `mypy`, `pydocstyle`, `cpplint`, `luacheck`). If you do want shellcheck, add in a plugin spec:

```lua
{ "mfussenegger/nvim-lint", opts = { linters_by_ft = { sh = { "shellcheck" } } } },
```

### 3.2 Shell scripts get no LSP (P3)

Optional: add `bash-language-server` to the Mason list and `bashls = {}` to the servers.

### 3.3 C/C++ formatting (P3)

`clang-format` is installed but conform has no entry for `c`/`cpp`. Optional fix in `lsp.lua` or a new spec: `formatters_by_ft = { c = { "clang-format" }, cpp = { "clang-format" } }`.

### 3.4 `tsserver` blocks are dead config (P1)

`lua/plugins/lsp.lua` (about lines 52 to 115) and `lua/plugins/react.lua` (line 7) configure a server named `tsserver`. The lspconfig name has been `ts_ls` for a long time, and your LazyVim TypeScript extra actually runs **`vtsls`** (confirmed by the probe: `lsp=[vtsls,...]`). So none of your TS/JS inlay-hint, completion or 2-space format settings are applied. The `root_pattern(".git")` override is ignored too.

Easiest fix: rename `tsserver` to `vtsls` in both files, and move the settings under `settings.typescript` / `settings.javascript` (vtsls uses the same shape). Or delete both blocks and rely on the LazyVim defaults.

---

## 4. Keymap conflicts (P1)

Found by scanning all live (non-commented) key definitions.

| Key | Defined in | What happens |
|-----|-----------|--------------|
| `<leader>tt` | `keymaps.lua:119` (toggle truncation), `python.lua:79` (Neotest run), `react.lua:176` (Neotest run) | Truncation toggle shadows or is shadowed by Neotest. Pick one |
| `<leader>tf/tn/to/ts` | `python.lua:80-83` and `react.lua:177-180` | Identical duplicates; harmless but redundant |
| `<leader>db/dc/di/do/dr/dq` | `python.lua:138-143` and `react.lua:148-153` | Identical duplicates |
| `<leader>cd` | `python.lua:95` (Neogen docstring) vs `react.lua:210` (`npm run dev`) | Conflict; whichever loads last wins. Rename the npm one (e.g. `<leader>cN`) |
| `<leader>d` | `ui.lua:109` (DBUI) | Also the prefix for all the debug keys (`<leader>db`, ...). Pressing `<leader>d` waits for the timeout. Move DBUI to e.g. `<leader>D`-free key like `<leader>uD` |
| `<leader>Q` | `keymaps.lua:52` (quit all) and `keymaps.lua:55` / `ui.lua:155` (open DBUI) | Quit-all is overridden by DBUI. Rename one |
| `<C-a>` | `keymaps.lua:12` (`+` → increment is not `<C-a>`) and `keymaps.lua:22` (select all) | Select-all hides the built-in increment; that is why you remapped `+`/`-`. Intentional, fine |
| `<C-j>` | `keymaps.lua:90` (next diagnostic), `editor.lua` (telescope), vim-tmux-navigator | tmux-navigator also maps `<C-j>`; whichever registers last wins. Use another key for diagnostics (LazyVim already has `]d`) |

Easiest fix: delete the Neotest and DAP key blocks from `react.lua` (python.lua keeps them), rename the `npm` keys, and drop your `<C-j>` and `<leader>Q` DBUI map.

### 4.1 Wrong command in a live key (P1)

`ui.lua:110`: `<leader>d` runs `<cmd>NvimTreeClose<cr><cmd>tabnew<cr>...<cmd>DBUI<cr>`. `NvimTreeClose` is from the nvim-tree plugin, which is only present inside a commented-out block. The key therefore errors with `E492: Not an editor command` before DBUI opens. Fix: change `NvimTreeClose` to `Neotree close` (or remove it).

### 4.2 Not a bug, but worth knowing

The `NvimTree` mappings at `keymaps.lua:65-70` and the `nvim-tree` spec at `ui.lua:161-223` are inside `--[[ ... ]]` block comments, so they are inert. Same for the second half of `editor.lua` (lines 160-333, a commented-out copy of the telescope and hipatterns specs). They are clutter, not errors.

---

## 5. Deprecated or incorrect APIs (P2)

| Where | Code | Replacement (Neovim 0.11) |
|-------|------|---------------------------|
| `keymaps.lua:91` | `vim.diagnostic.goto_next()` | `vim.diagnostic.jump({ count = 1, float = true })` |
| `keymaps.lua:114` | `vim.lsp.buf.inlay_hint(0, true)` | `vim.lsp.inlay_hint.enable(true, { bufnr = 0 })` (the current call errors when you press `<leader>tt`) |
| `lsp.lua:49,54` | `require("lspconfig.util").root_pattern(".git")` | `vim.fs.root(0, ".git")` |
| `lsp.lua:4` | `williamboman/mason.nvim` | Repo moved to `mason-org/mason.nvim` (old name still redirects) |
| `python.lua` pyright `settings.python.linting` / `formatting` | Not real pyright settings (they were pylance/vscode options), silently ignored | Delete these blocks; use `python.analysis` only |
| `python.lua` neotest `python = function() ... "/venv/bin/python"` | Hard-coded venv path | Delete; neotest-python picks up the active env |
| `treesitter.lua` `tag = "v0.9.1"` | Pins an old release; LazyVim expects newer parsers | Remove the `tag` line |
| `treesitter.lua` `query_linter` | Needs `nvim-treesitter/playground`, which is not installed | Remove |
| `lazy.lua` | `{ import = "lazyvim.plugins.extras.linting.eslint" }` etc. | Fine; consider moving them to `lazyvim.json` extras |

---

## 6. `:checkhealth` findings

**Errors**
- `fzf-lua`: `'find' find: illegal option -- --` caused by BSD find. Fixed by the findutils install in §2.
- `lazy`: the two invalid spec modules (§1).
- `snacks`: `rg` missing, `fd` missing (v8.4 required), `lazygit` missing, `vim.ui.input` not set to `Snacks.input`, notifier "is not ready", dashboard "setup did not run", image tools missing. The first three are fixed by §2; the rest are optional Snacks features that are simply disabled (`setup {disabled}` for picker, explorer, image, statuscolumn).
- `terminal`: `infocmp -L` failed because `TERM` was not set. That is an artifact of running headless, not a real problem.

**Warnings (all optional)**
- `fzf-lua`: `viu`, `chafa`, `ueberzugpp` (image preview) missing.
- Snacks image: `magick`, `mmdc`, no kitty-protocol terminal, treesitter parsers `latex norg svelte typst vue` missing. Ignore unless you want inline images and mermaid; `brew install imagemagick mermaid-cli` if you do.
- LuaSnip: `jsregexp` not installed (needed for snippet transformations). Optional: `luarocks install jsregexp`.
- Providers: no `neovim` npm package, no Python `neovim` module, no perl or ruby host. Only needed for old remote plugins. Ignore, or `npm i -g neovim` and `pip install pynvim` if you want the warnings gone.

---

## 7. Repo hygiene (P2)

`~/.config/nvim` is a git repo (HEAD `19311c1`, remote `ans9868/nvim`). It contains three PDFs (`Untitled.pdf`, `testLaptop - Environment.pdf`, `Spark to Ray ….pdf`, the last one untracked) that are unrelated to the config, a `LICENSE` copied from the starter, and `lazy-lock.json` (correct to keep). Easiest fix: move the PDFs to `~/Documents` and `git rm --cached` the tracked ones. The README still points at the video it was copied from; fine.

---

## 8. Recommended order of fixes (one at a time, re-test after each)

1. `brew install ripgrep fd lazygit coreutils findutils` (no config edit; fixes pickers, lazygit, fzf-lua).
2. Add `return {}` to `comment.lua` and `endhints.lua` (kills the startup error).
3. Fix `ui.lua:110` (`NvimTreeClose` → `Neotree close`).
4. Remove duplicate Neotest / DAP keys from `react.lua`; rename `<leader>cd` npm key; free `<leader>d` and `<leader>Q`.
5. Rename `tsserver` → `vtsls` in `lsp.lua` and `react.lua`.
6. Replace the three deprecated API calls (§5).
7. Trim the Mason list and the dead pyright / neotest settings.
8. Delete commented-out blocks and the duplicate dadbod spec; unpin treesitter; move PDFs.

After each step, rerun: `nvim --headless "+checkhealth lazy" "+qa"` and reopen one sample of each filetype. A savepoint already exists at commit `19311c1`, so `git diff` shows exactly what each step changed.
