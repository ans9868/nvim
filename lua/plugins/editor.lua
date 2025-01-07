-- -- editor stuff for lua
-- -- https://github.com/JazzyGrim/dotfiles/blob/master/.config/nvim/lua/plugins/editor.lua
return {
  -- highlight colors when put in hex
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  --enhanced telecsop for fzf and file browser extensions
  {
    "telescope.nvim",
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        ";f",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Lists files in current working directory and its subdirectories, respects .gitignore",
      },
      {
        ";r",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep()
        end,
        desc = "Search for a string in current working directory and its subdirectories, respects .gitignore",
      },
      {
        "\\\\",
        function()
          local builtin = require("telescope.builtin")
          builtin.buffers({ sort_mru = true })
        end,
        desc = "Lists open buffers ie files open in neovim; sorts by mru most recently used buffers",
      },
      {
        ";;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resumes previous Telescope pickers session (GPT)",
      },
      {
        ";e",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Lists diagnostics ie errors for all open buffers or a specific buffer",
      },
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Lists function names, variables using treesitter",
      },
      {
        "sf",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h", -- full absolute path
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open file browser form absolute path of current buffer, shows all files. 'sf' --> 'show files'",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = { -- Insert mode mappings
            ["<C-j>"] = require("telescope.actions").move_selection_next, -- Move to the next item
            ["<C-k>"] = require("telescope.actions").move_selection_previous, -- Move to the previous item
          },
          n = { -- Normal mode mappings
            ["<C-j>"] = require("telescope.actions").move_selection_next, -- Move to the next item
            ["<C-k>"] = require("telescope.actions").move_selection_previous, -- Move to the previous item
          },
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          -- disables netrw and use telescope file browser in its place
          hijack_netrw = true,
          mappings = {
            -- custom insert mode mappings
            ["n"] = {
              -- custom normal mode mappings
              ["N"] = fb_actions.create, -- create new file
              ["h"] = fb_actions.goto_parent_dir, -- go to parent directory
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do -- move up 10 entries in file browser
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do -- move back 10 entries in file browser
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
          layout_config = {
            prompt_position = "top",
          },
        },
      }
      telescope.setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end,
  },
}

--[[
return {
  -- highlight colors when put in hex
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },
  {

    "telescope.nvim",
    priority = 1000,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },

    keys = {
      {
        ";f",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Lists files in current working directory and its subdirectories, respects .gitignore",
      },
      {
        ";r",
        function()
          local builtin = require("telescope.builtin")
          builtin.live_grep()
        end,
        desc = "Search for a string in current working directory and its subdirectories, respects .gitignore",
      },
      {
        "\\\\",
        function()
          local builtin = require("telescope.builtin")
          builtin.buffers({ sort_mru = true })
        end,
        desc = "Lists open buffers ie files open in neovim; sorts by mru most recently used buffers",
      },
      {
        ";;",
        function()
          local builtin = require("telescope.builtin")
          builtin.resume()
        end,
        desc = "Resumes previous Telescope pickers session (GPT)",
      },
      {
        ";e",
        function()
          local builtin = require("telescope.builtin")
          builtin.diagnostics()
        end,
        desc = "Lists diagnostics ie errors for all open buffers or a specific buffer",
      },
      {
        ";s",
        function()
          local builtin = require("telescope.builtin")
          builtin.treesitter()
        end,
        desc = "Lists function names, variables using treesitter",
      },
      {
        "sf",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end
          telescope.extensions.file_browser.file_browser({
            path = "%:p:h", -- full absolute path
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "Open file browser form absolute path of current buffer, shows all files. 'sf' --> 'show files'",
      },
    },

    config = function(_, opts)
      local telescope = require("telescope") -- Fixed typo in 'telescope'

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        layout_strategy = "horizontal", -- Use horizontal layout
        layout_config = {
          prompt_position = "top", -- Place the search prompt at the top
        },
        sorting_strategy = "ascending", -- Show results from top to bottom
        winblend = 0, -- No transparency
      })

      -- Setup Telescope with the updated options
      telescope.setup(opts)

      -- Load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
    -- *** FULL CONFIG BUT SOMETHING FORCES THE TOP BAR WHERE WRITE STUFF TO BE IN THE BOTTOM
    -- config = function(_, opts)
    --    local telescope = require("telescope")
    --    local actions = require("telescope.actions")
    --    local fb_actions = require("telescope").extensions.file_browser.actions
    --
    --       opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
    --         wrap_results = true,
    --         layout_strategy = "horizontal",
    --         layout_config = { prompt_position = "top" },
    --         sorting_strategy = "ascending",
    --         winblend = 0,
    --         mappings = {
    --           n = {},
    --         },
    --       })
    --       opts.pickers = {
    --         diagnostics = {
    --           theme = "ivy",
    --           initial_mode = "normal",
    --           layout_config = {
    --             preview_cutoff = 9999,
    --           },
    --         },
    --       }
    --       opts.extensions = {
    --         file_browser = {
    --           theme = "dropdown",
    --           -- disables netrw and use telescope file browser in its place
    --           hijack_netrw = true,
    --           mappings = {
    --             -- custom insert mode mappings
    --             ["n"] = {
    --               -- custom normal mode mappings
    --               ["N"] = fb_actions.create, -- create new file
    --               ["h"] = fb_actions.goto_parent_dir, -- go to parent directory
    --               ["<C-u>"] = function(prompt_bufnr)
    --                 for i = 1, 10 do -- move up 10 entries in file browser
    --                   actions.move_selection_previous(prompt_bufnr)
    --                 end
    --               end,
    --               ["<C-d>"] = function(prompt_bufnr)
    --                 for i = 1, 10 do -- move back 10 entries in file browser
    --                   actions.move_selection_next(prompt_bufnr)
    --                 end
    --               end,
    --             },
    --           },
    --           layout_config = {
    --             prompt_position = "top",
    --           },
    --         },
    --       }
    --telescope.setup(opts)
    --require("telescope").load_extension("fzf")
    --require("telescope").load_extension("file_browser")
    -- end,
  },
}

]]
