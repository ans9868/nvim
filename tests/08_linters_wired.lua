-- P1: a lint-only tool installed through Mason must be wired to a linter/formatter, or not installed.
require("lazy").load({ plugins = { "conform.nvim", "nvim-lint" } })
local plugin = require("lazy.core.config").plugins["mason.nvim"]
local opts = require("lazy.core.plugin").values(plugin, "opts", false)
local installed = opts.ensure_installed or {}
local wired = {}
for _, list in pairs(require("lint").linters_by_ft) do
  for _, n in ipairs(list) do
    wired[n] = true
  end
end
for _, list in pairs(require("conform").formatters_by_ft) do
  if type(list) == "table" then
    for _, n in ipairs(list) do
      wired[n] = true
    end
  end
end
for _, tool in ipairs({ "flake8", "mypy", "pydocstyle", "cpplint", "luacheck", "shellcheck", "autopep8" }) do
  if T.has(installed, tool) and not wired[tool] then
    T.fail(tool .. " is installed by Mason but not wired")
  end
end
