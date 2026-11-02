-- P2: Neovim 0.11 deprecated APIs must not be used in live config code.
local bad = {
  { "vim.diagnostic.goto_next", "diagnostic.goto_next" },
  { "vim.diagnostic.goto_prev", "diagnostic.goto_prev" },
  { "inlay_hint(0", "lsp.buf.inlay_hint(0, ...)" },
  { "vim.lsp.buf.inlay_hint(", "lsp.buf.inlay_hint" },
  { "root_pattern", "lspconfig root_pattern" },
  { "tsserver", "tsserver server name" },
  { "williamboman/mason", "williamboman/mason repo name" },
}
for _, s in ipairs(T.sources()) do
  for _, b in ipairs(bad) do
    if s.code:find(b[1], 1, true) then
      T.fail(s.path .. ": uses " .. b[2])
    end
  end
end
