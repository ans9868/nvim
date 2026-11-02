return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- show which key is <leader> at the left of the statusline
    local leader = vim.g.mapleader == " " and "SPC" or (vim.g.mapleader or "\\")
    table.insert(opts.sections.lualine_b, 1, function()
      return "󰌌 leader=" .. leader
    end)

    -- put the file name before the diagnostics counts
    local c = opts.sections.lualine_c
    for i, comp in ipairs(c) do
      if type(comp) == "table" and comp[1] == "diagnostics" then
        table.remove(c, i)
        table.insert(c, comp)
        break
      end
    end
  end,
}
