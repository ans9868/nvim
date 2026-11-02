return {
  "folke/which-key.nvim",
  opts = function(_, opts)
    -- show ctrl keys in lowercase everywhere in the popup, e.g. "<C-d>/<C-u> scroll" instead of "<C-D>/<C-U>"
    opts.replace = opts.replace or {}
    opts.replace.key = {
      function(key)
        local out = require("which-key.view").format(key)
        local ctrl = vim.pesc(require("which-key.config").icons.keys.C or "C-")
        for letter in key:gmatch("<[Cc]%-(%a)>") do
          out = out:gsub(ctrl .. letter:upper(), function(m)
            return m:sub(1, -2) .. letter:lower()
          end)
        end
        return out
      end,
    }

    -- keep "split below" (<leader>-) and "split right" (<leader>|) next to each other in the menu
    opts.sort = {
      "local",
      "order",
      "group",
      "alphanum",
      function(item)
        return (item.key == "-" or item.key == "|") and 0 or 1
      end,
      "mod",
    }
  end,
}
