-- Regression guard: every language keeps its LSP, treesitter parser and formatter.
T_SAMPLES = vim.env.NVIM_TESTS .. "/samples"local expect = {
  ["t.py"] = { lsp = { "pyright", "ruff" }, fmt = { "black" } },
  ["t.ts"] = { lsp = { "vtsls" }, fmt = { "prettier" } },
  ["t.tsx"] = { lsp = { "vtsls" }, fmt = { "prettier" } },
  ["t.lua"] = { lsp = { "lua_ls" }, fmt = { "stylua" } },
  ["t.json"] = { lsp = { "jsonls" }, fmt = { "prettier" } },
  ["t.yaml"] = { lsp = { "yamlls" }, fmt = { "prettier" } },
  ["t.md"] = { lsp = {}, fmt = { "prettier" } },
  ["Dockerfile"] = { lsp = { "dockerls" }, fmt = {} },
  ["t.sh"] = { lsp = {}, fmt = { "shfmt" } },
  ["t.c"] = { lsp = { "clangd" }, fmt = {} },
  ["t.css"] = { lsp = { "cssls" }, fmt = { "prettier" } },
  ["t.html"] = { lsp = { "html" }, fmt = { "prettier" } },
}
require("lazy").load({ plugins = { "conform.nvim" } })
local conform = require("conform")
for name, e in pairs(expect) do
  vim.cmd("edit " .. T_SAMPLES .. "/" .. name)
  local b = vim.api.nvim_get_current_buf()
  T.wait_clients(b, e.lsp, 25000)
  for _, lsp in ipairs(e.lsp) do
    if #vim.lsp.get_clients({ bufnr = b, name = lsp }) == 0 then
      T.fail(name .. ": LSP " .. lsp .. " not attached")
    end
  end
  if not pcall(vim.treesitter.get_parser, b) then
    T.fail(name .. ": no treesitter parser")
  end
  local fmts = {}
  for _, f in ipairs(conform.list_formatters(b)) do
    fmts[#fmts + 1] = f.name
  end
  for _, f in ipairs(e.fmt) do
    if not T.has(fmts, f) then
      T.fail(name .. ": formatter " .. f .. " missing")
    end
  end
end
