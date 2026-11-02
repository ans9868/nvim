-- P1: every :Command used by a live keymap must exist (or be provided lazily by a plugin's `cmd`).
local lazy_cmds = {}
for _, p in pairs(require("lazy.core.config").plugins) do
  local cmd = p.cmd
  if type(cmd) == "string" then
    cmd = { cmd }
  end
  for _, c in ipairs(type(cmd) == "table" and cmd or {}) do
    lazy_cmds[c] = true
  end
end
local lazy_dir = vim.fn.stdpath("data") .. "/lazy"
-- A command is real if some installed plugin defines it (plugins load lazily, so :exists() is not enough).
local function installed(name)
  vim.fn.system({ "grep", "-rlw", "--include=*.lua", "--include=*.vim", name, lazy_dir })
  return vim.v.shell_error == 0
end
local seen = {}
for _, k in ipairs(T.keymaps()) do
  local names = {}
  for n in k.rhs:gmatch("<[cC][mM][dD]>(%u[%w_]*)") do
    names[#names + 1] = n
  end
  local lead = k.rhs:match("^:(%u[%w_]*)")
  if lead then
    names[#names + 1] = lead
  end
  for _, n in ipairs(names) do
    if vim.fn.exists(":" .. n) == 0 and not lazy_cmds[n] and not seen[n] then
      seen[n] = true
      if not installed(n) then T.fail(("%s: key %s runs unknown command :%s"):format(k.file, k.lhs, n)) end
    end
  end
end
