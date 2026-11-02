-- P1: settings that are silently ignored must not stay in the config.
for _, s in ipairs(T.sources()) do
  if s.code:find("linting%s*=%s*{") then
    T.fail(s.path .. ": pyright `linting` block (not a pyright option)")
  end
  if s.code:find("python%s*=%s*{[^}]-formatting%s*=%s*{") or s.code:find("provider%s*=%s*\"black\"") then
    T.fail(s.path .. ": pyright `formatting` block (not a pyright option)")
  end
  if s.code:find("/venv/bin/python", 1, true) then
    T.fail(s.path .. ": hard-coded ./venv/bin/python")
  end
end
