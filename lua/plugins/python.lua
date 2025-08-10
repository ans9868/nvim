return {
  -- Python language support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                inlayHints = {
                  functionReturnTypes = true,
                  variableTypes = true,
                  parameterTypes = true,
                },
              },
              linting = {
                enabled = true,
                flake8Enabled = true,
                mypyEnabled = true,
                ruffEnabled = true,
              },
              formatting = {
                provider = "black",
              },
            },
          },
        },

      },
    },
  },

  -- Python virtual environment detection
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
        "ENV",
        "env.bak",
        ".venv.bak",
      },
      auto_refresh = true,
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select Virtual Environment" },
    },
  },

  -- Python testing support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = function()
            return vim.fn.getcwd() .. "/venv/bin/python"
          end,
        },
      },
    },
    keys = {
      { "<leader>tt", "<cmd>Neotest run<cr>", desc = "Run Tests" },
      { "<leader>tf", "<cmd>Neotest run_file<cr>", desc = "Run File Tests" },
      { "<leader>tn", "<cmd>Neotest run nearest<cr>", desc = "Run Nearest Test" },
      { "<leader>to", "<cmd>Neotest output<cr>", desc = "Test Output" },
      { "<leader>ts", "<cmd>Neotest summary<cr>", desc = "Test Summary" },
    },
  },

  -- Python docstring generation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      snippet_engine = "luasnip",
    },
    keys = {
      { "<leader>cd", "<cmd>Neogen<cr>", desc = "Generate Docstring" },
    },
  },

  -- Python file associations
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "python", "toml" })
      end
    end,
  },

  -- Python formatting and linting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
      },
      formatters = {
        black = {
          prepend_args = { "--line-length", "88" },
        },
        isort = {
          prepend_args = { "--profile", "black" },
        },
      },
    },
  },

  -- Python debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      require("dap-python").setup("python")
      require("dap-python").test_runner = "pytest"
    end,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<cr>", desc = "Continue Debug" },
      { "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
      { "<leader>do", "<cmd>DapStepOver<cr>", desc = "Step Over" },
      { "<leader>dr", "<cmd>DapRestart<cr>", desc = "Restart Debug" },
      { "<leader>dq", "<cmd>DapTerminate<cr>", desc = "Terminate Debug" },
    },
  },
} 