-- P0: every file in lua/plugins must return a spec table; lazy.nvim must not report invalid spec modules.
if T.MSGS:find("Invalid spec module") then
  for mod in T.MSGS:gmatch("Invalid spec module: `([^`]+)`") do
    T.fail("invalid spec module " .. mod)
  end
end
if T.MSGS:find("Failed to load") or T.MSGS:find("Error detected") then
  T.fail("startup errors in :messages")
end
