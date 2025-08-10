return {
  -- Docker language support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },
      },
    },
  },

  -- File type associations for Docker files
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dockerfile", "yaml" })
      end
    end,
  },

  -- Additional Docker file associations
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.filesystem.filtered_items = opts.filesystem.filtered_items or {}
      opts.filesystem.filtered_items.visible = opts.filesystem.filtered_items.visible or true
      opts.filesystem.filtered_items.hide_dotfiles = opts.filesystem.filtered_items.hide_dotfiles or false
      opts.filesystem.filtered_items.hide_gitignored = opts.filesystem.filtered_items.hide_gitignored or false
    end,
  },
} 