-- Entry point run inside headless nvim by tests/run.sh.
-- Env: NVIM_TESTS = this folder, TEST_FILE = the test to run.
local H = dofile(vim.env.NVIM_TESTS .. "/harness.lua")
_G.T = H

vim.defer_fn(function()
  H.MSGS = vim.api.nvim_exec2("messages", { output = true }).output
  local ok, err = pcall(dofile, vim.env.TEST_FILE)
  if not ok then
    H.fail("test crashed: " .. tostring(err))
  end
  if #H.fails == 0 then
    io.stdout:write("\nRESULT PASS\n")
  else
    io.stdout:write("\nRESULT FAIL: " .. table.concat(H.fails, " | ") .. "\n")
  end
  vim.cmd("qa!")
end, 6000)
