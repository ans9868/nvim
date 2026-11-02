-- P0: the fzf-lua file command set in init.lua must actually list files.
local cfg = require("fzf-lua.config")
local cmd = cfg.globals and cfg.globals.files and cfg.globals.files.cmd
if type(cmd) ~= "string" then
  return
end
local out = vim.fn.system("cd " .. vim.env.NVIM_TESTS .. "/samples && " .. cmd)
if vim.v.shell_error ~= 0 then
  T.fail("fzf-lua files cmd exits " .. vim.v.shell_error .. ": " .. vim.trim(out):sub(1, 80))
elseif not out:find("t.py", 1, true) then
  T.fail("fzf-lua files cmd printed no files")
end
