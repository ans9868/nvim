-- OPEN: samples/t.ts
-- P1: the TS format/inlay settings from lsp.lua must reach the TypeScript server that actually runs (vtsls).
local b = vim.api.nvim_get_current_buf()
T.wait_clients(b, { "vtsls" }, 25000)
local c = vim.lsp.get_clients({ bufnr = b, name = "vtsls" })[1]
if not c then
  T.fail("vtsls not attached")
  return
end
if #vim.lsp.get_clients({ bufnr = b, name = "tsserver" }) > 0 then
  T.fail("tsserver should not be configured")
end
local ts = c.config.settings and c.config.settings.typescript
if not (ts and ts.format and ts.format.indentSize == 2) then
  T.fail("typescript.format.indentSize=2 did not reach vtsls")
end
local js = c.config.settings and c.config.settings.javascript
if not (js and js.format and js.format.indentSize == 2) then
  T.fail("javascript.format.indentSize=2 did not reach vtsls")
end
