-- Shared helpers for the headless tests in tests/lua. Loaded by harness_run.lua.
local H = { fails = {}, MSGS = "" }

local ROOT = vim.fn.stdpath("config")

function H.fail(msg)
  table.insert(H.fails, msg)
end

function H.read(path)
  local f = io.open(path, "r")
  if not f then
    return ""
  end
  local s = f:read("*a")
  f:close()
  return s
end

-- Remove Lua comments (line and block) while leaving string contents intact.
function H.strip(s)
  local out, i, n = {}, 1, #s
  while i <= n do
    local c = s:sub(i, i)
    local lvl = s:match("^%-%-%[(=*)%[", i)
    if lvl then
      local close = "]" .. lvl .. "]"
      local e = s:find(close, i, true)
      local stop = e and (e + #close - 1) or n
      out[#out + 1] = string.rep("\n", select(2, s:sub(i, stop):gsub("\n", "")))
      i = stop + 1
    elseif s:sub(i, i + 1) == "--" then
      local e = s:find("\n", i, true)
      i = e or (n + 1)
    elseif c == '"' or c == "'" then
      local j = i + 1
      while j <= n do
        local d = s:sub(j, j)
        if d == "\\" then
          j = j + 2
        elseif d == c then
          break
        else
          j = j + 1
        end
      end
      out[#out + 1] = s:sub(i, j)
      i = j + 1
    else
      local long = s:match("^%[(=*)%[", i)
      if long then
        local close = "]" .. long .. "]"
        local e = s:find(close, i, true) or n
        out[#out + 1] = s:sub(i, e + #close - 1)
        i = e + #close
      else
        out[#out + 1] = c
        i = i + 1
      end
    end
  end
  return table.concat(out)
end

-- All config sources with comments stripped: { { path = "lua/plugins/x.lua", code = "..." }, ... }
function H.sources()
  local files = { ROOT .. "/init.lua" }
  vim.list_extend(files, vim.fn.globpath(ROOT, "lua/**/*.lua", false, true))
  table.sort(files)
  local res = {}
  for _, p in ipairs(files) do
    res[#res + 1] = { path = p:sub(#ROOT + 2), code = H.strip(H.read(p)) }
  end
  return res
end

-- Index of the brace matching the `{` at position i (strings are skipped).
function H.match_brace(s, i)
  local depth, j, n = 0, i, #s
  while j <= n do
    local c = s:sub(j, j)
    if c == '"' or c == "'" then
      local k = j + 1
      while k <= n do
        local d = s:sub(k, k)
        if d == "\\" then
          k = k + 2
        elseif d == c then
          break
        else
          k = k + 1
        end
      end
      j = k
    elseif c == "{" then
      depth = depth + 1
    elseif c == "}" then
      depth = depth - 1
      if depth == 0 then
        return j
      end
    end
    j = j + 1
  end
  return n
end

-- Every key mapping defined in live config code: { mode, lhs, rhs, file } (lhs normalised to lower case).
function H.keymaps()
  local res = {}
  local function add(mode, lhs, rhs, file)
    mode = (mode or "n"):gsub("[\"'{ ]", ""):sub(1, 1)
    if mode == "" then
      mode = "n"
    end
    res[#res + 1] = { mode = mode, lhs = lhs:gsub("<[^>]+>", string.lower), rhs = rhs or "", file = file }
  end
  for _, src in ipairs(H.sources()) do
    local code = src.code
    for _, pat in ipairs({ "keymap%.set%(%s*([^,]+),%s*\"([^\"]+)\"%s*,%s*([^\n]*)", "nvim_set_keymap%(%s*([^,]+),%s*\"([^\"]+)\"%s*,%s*([^\n]*)" }) do
      for mode, lhs, rest in code:gmatch(pat) do
        add(mode, lhs, rest:match('^"([^"]*)"') or "", src.path)
      end
    end
    -- lazy.nvim `keys = { { "lhs", "rhs", mode = "v" }, ... }`
    local pos = 1
    while true do
      local s, e = code:find("keys%s*=%s*{", pos)
      if not s then
        break
      end
      local close = H.match_brace(code, e)
      local body = code:sub(e + 1, close - 1)
      local p2 = 1
      while true do
        local es = body:find("{", p2, true)
        if not es then
          break
        end
        local ee = H.match_brace(body, es)
        local entry = body:sub(es, ee)
        local lhs = entry:match("^{%s*\"([^\"]+)\"")
        if lhs then
          local rhs = entry:match("^{%s*\"[^\"]+\"%s*,%s*\"([^\"]*)\"") or ""
          local mode = entry:match("mode%s*=%s*\"(%a)\"") or entry:match("mode%s*=%s*{%s*\"(%a)\"") or "n"
          add(mode, lhs, rhs, src.path)
        end
        p2 = ee + 1
      end
      pos = close + 1
    end
  end
  return res
end

-- Wait until the buffer has all the named LSP clients (or the timeout passes).
function H.wait_clients(bufnr, names, ms)
  vim.wait(ms or 20000, function()
    for _, name in ipairs(names) do
      if #vim.lsp.get_clients({ bufnr = bufnr, name = name }) == 0 then
        return false
      end
    end
    return true
  end, 200)
end

function H.has(list, item)
  return vim.tbl_contains(list, item)
end

return H
