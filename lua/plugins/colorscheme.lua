return {
  "folke/tokyonight.nvim", -- GitHub repo for tokyonight colorscheme
  priority = 1000, -- Ensure it loads before other plugins
  config = function()
    require("tokyonight").setup({
      style = "night", -- Set the style to "night" (options: night, storm, day, moon)
      transparent = false, -- Disable transparent background
      terminal_colors = true, -- Enable terminal colors
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { bold = true },
        variables = {},
      },
      sidebars = { "qf", "help" }, -- Apply special styling to sidebars
      dim_inactive = false, -- Do not dim inactive windows
    })
    -- Apply the colorscheme
    vim.cmd("colorscheme tokyonight")
  end,
}
