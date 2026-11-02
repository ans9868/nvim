-- P2: treesitter must not be pinned to an old tag, and the playground-only query_linter must go.
for _, s in ipairs(T.sources()) do
  if s.code:find("tag%s*=%s*\"v0%.9%.1\"") then
    T.fail(s.path .. ": nvim-treesitter pinned to v0.9.1")
  end
  if s.code:find("query_linter", 1, true) then
    T.fail(s.path .. ": query_linter needs the playground plugin")
  end
end
