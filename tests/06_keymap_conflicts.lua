-- P1: no key is defined twice (same mode), and no key is a prefix of another (it would wait for timeoutlen).
local maps = T.keymaps()
local by = {}
for _, k in ipairs(maps) do
  local id = k.mode .. " " .. k.lhs
  by[id] = by[id] or {}
  table.insert(by[id], k.file)
end
for id, files in pairs(by) do
  if #files > 1 then
    T.fail(("%s defined %dx (%s)"):format(id, #files, table.concat(files, ",")))
  end
end
for _, a in ipairs(maps) do
  for _, b in ipairs(maps) do
    if a.mode == b.mode and a.lhs ~= b.lhs and #a.lhs >= 4 and b.lhs:sub(1, #a.lhs) == a.lhs and a.lhs:find("^<leader>") then
      T.fail(("%s %s is a prefix of %s"):format(a.mode, a.lhs, b.lhs))
    end
  end
end
