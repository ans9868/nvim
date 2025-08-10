return {
  -- React/JavaScript language support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          settings = {
            typescript = {
              inlayHints = {
                semicolons = "remove",
                includeInlayParameterNameHints = "literal",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText = true,
              },
              format = {
                indentSize = 2,
                tabSize = 2,
                convertTabsToSpaces = true,
              },
            },
            javascript = {
              inlayHints = {
                semicolons = "remove",
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                includeCompletionsWithSnippetText = true,
              },
              format = {
                indentSize = 2,
                tabSize = 2,
                convertTabsToSpaces = true,
              },
            },
            completions = {
              includeCompletionsForModuleExports = true,
              includeCompletionsWithSnippetText = true,
            },
          },
        },
        eslint = {
          settings = {
            workingDirectory = { mode = "auto" },
          },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
        },
      },
    },
  },

  -- React component navigation
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx" })
      end
    end,
  },

  -- React snippets and autocompletion
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      enable_autosnippets = true,
    },
  },

  -- React component file creation
  {
    "adelarsq/neofsharp.vim",
    keys = {
      { "<leader>cr", "<cmd>Neofsharp<cr>", desc = "Create React Component" },
    },
  },

  -- React debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "microsoft/vscode-js-debug",
    },
    config = function()
      local dap = require("dap")
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript
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

  -- React testing support
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-jest",
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
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

  -- React formatting and linting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier", "eslint_d" },
        javascriptreact = { "prettier", "eslint_d" },
        typescript = { "prettier", "eslint_d" },
        typescriptreact = { "prettier", "eslint_d" },
        json = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
      },
      formatters = {
        prettier = {
          prepend_args = { "--single-quote", "--trailing-comma", "es5" },
        },
      },
    },
  },

  -- React development server integration
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>cd", "<cmd>!npm run dev<cr>", desc = "Start Dev Server" },
      { "<leader>cb", "<cmd>!npm run build<cr>", desc = "Build Project" },
      { "<leader>ci", "<cmd>!npm install<cr>", desc = "Install Dependencies" },
    },
  },
} 