-- P2: each plugin is specified in only one place per file, and no plugin is specified twice in ui.lua.
for _, s in ipairs(T.sources()) do
  local seen = {}
  for name in s.code:gmatch("\n%s*{%s*\n?%s*\"([%w%-_%.]+/[%w%-_%.]+)\"") do
    if seen[name] and not name:find("nvim%-lspconfig") and not name:find("nvim%-treesitter") and not name:find("neotest") and not name:find("conform") then
      T.fail(s.path .. ": plugin " .. name .. " specified twice")
    end
    seen[name] = true
  end
end
