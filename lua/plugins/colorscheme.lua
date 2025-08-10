return {
  -- Monokai Pro colorscheme for Neovim (Spectrum filter)
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        terminal_colors = true,
        devicons = true, -- highlight the icons of `nvim-web-devicons`
        styles = {
          comment = { italic = true },
          keyword = { italic = true }, -- any other keyword
          type = { italic = true }, -- (preferred) int, long, char, etc
          storageclass = { italic = true }, -- static, register, volatile, etc
          structure = { italic = true }, -- struct, union, enum, etc
          parameter = { italic = true }, -- parameter pass in function
          annotation = { italic = true },
          tag_attribute = { italic = true }, -- attribute of tag in reactjs
          ["function"] = { bold = true }, -- function names
        },
        filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        -- Enable this will disable filter option
        day_night = {
          enable = false, -- turn off by default
          day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
          night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        },
        inc_search = "background", -- underline | background
        background_clear = {
          -- "float_win",
          "toggleterm",
          "telescope",
          -- "which-key",
          "renamer",
          "notify",
          -- "nvim-tree",
          -- "neo-tree",
          -- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
        },
        plugins = {
          bufferline = {
            underline_selected = false,
            underline_visible = false,
          },
          indent_blankline = {
            context_highlight = "default", -- default | pro
            context_start_underline = false,
          },
        },
        ---@param c Colorscheme
        override = function(c)
          return {
            -- Match your previous styling preferences
            Comment = { italic = true },
            Keyword = { italic = true },
            Function = { bold = true },
            Identifier = {},
            -- Treesitter overrides
            ["@keyword"] = { italic = true },
            ["@function"] = { bold = true },
            ["@comment"] = { italic = true },
            ["@variable"] = {},
            -- Custom background color: #1E1E1E (30, 30, 30)
            Normal = { bg = "#1E1E1E" },
            NormalFloat = { bg = "#1E1E1E" },
            FloatBorder = { bg = "#1E1E1E" },
            -- Ensure other UI elements also use the custom background
            SignColumn = { bg = "#1E1E1E" },
            LineNr = { bg = "#1E1E1E" },
            CursorLine = { bg = "#1E1E1E" },
            CursorLineNr = { bg = "#1E1E1E" },
            StatusLine = { bg = "#1E1E1E" },
            StatusLineNC = { bg = "#1E1E1E" },
            TabLine = { bg = "#1E1E1E" },
            TabLineFill = { bg = "#1E1E1E" },
            TabLineSel = { bg = "#1E1E1E" },
            VertSplit = { bg = "#1E1E1E" },
            WinSeparator = { bg = "#1E1E1E" },
          }
        end,
      })
    end,
  },

  -- Commented out Dracula theme (previous configuration)
  --[[
  {
    "Mofiqul/dracula.nvim",
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
      local dracula = require("dracula")
      dracula.setup({
        -- customize dracula color palette
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
          white = "#ABB2BF",
          black = "#191A21",
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- use transparent background
        transparent_bg = false, -- default false (set to false to match your current setup)
        -- set custom lualine background color
        lualine_bg_color = "#44475a", -- default nil
        -- set italic comment
        italic_comment = true, -- default false
        -- overrides the default highlights to match your current styling
        overrides = function(colors)
          return {
            -- Comments: italic
            Comment = { italic = true },
            -- Keywords: italic
            Keyword = { italic = true },
            -- Functions: bold
            Function = { bold = true },
            -- Variables: normal
            Identifier = {},
            -- Sidebars styling
            NormalFloat = { bg = colors.menu },
            FloatBorder = { bg = colors.menu, fg = colors.menu },
            -- Match your current Tokyo Night styling
            ["@keyword"] = { italic = true },
            ["@function"] = { bold = true },
            ["@comment"] = { italic = true },
            ["@variable"] = {},
          }
        end,
      })
      -- Apply the colorscheme
      vim.cmd("colorscheme dracula")
    end,
  },
  --]]

  -- Commented out Tokyo Night theme (original configuration)
  --[[
  {
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
  },
  --]]
}
