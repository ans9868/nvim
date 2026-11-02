-- which-key menu: no zen mode, split below/right sit next to each other, ctrl keys shown in lowercase.
local C = require("which-key.config")
local V = require("which-key.view")

-- LazyVim maps <leader>uz only once the UI is attached, so a headless run cannot see it: check the removal is in the config.
local removed = false
for _, src in ipairs(T.sources()) do
  if src.code:find("keymap%.del") and src.code:find("<leader>uz", 1, true) then
    removed = true
  end
end
if not removed then
  T.fail("zen mode key <leader>uz is not removed in the config")
end

local shown = V.replace("key", "<C-D>")
if not shown:find("d$") then
  T.fail("scroll key shown as '" .. shown .. "' (expected lowercase d)")
end
-- the scroll hint passes both keys as one string
local hint = V.replace("key", "<C-D>/<C-U>")
if hint:find("D") or hint:find("U") then
  T.fail("scroll hint shown as '" .. hint .. "' (expected lowercase d/u)")
end

local items = {}
for _, k in ipairs({ ",", "-", ".", "/", ":", "?", "|", "`", "l", "Q" }) do
  items[#items + 1] = { key = k, raw_key = k, desc = k }
end
V.sort(items, C.sort)
local pos = {}
for i, it in ipairs(items) do
  pos[it.key] = i
end
if math.abs(pos["-"] - pos["|"]) ~= 1 then
  T.fail("'-' (split below) and '|' (split right) are not adjacent in the menu order")
end
