return {
  -- tools
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        "tailwindcss-language-server",
        "typescript-language-server",
        "css-lsp",
        "eslint-lsp",
        "prettier",
        "emmet-ls",
        "dockerfile-language-server",
        "yaml-language-server",

        -- Python tools
        "pyright", -- Python language server
        "black", -- Python formatter
        "debugpy", -- Debugger for Python
        "ruff", -- Fast Python linter and formatter
        "isort", -- Import sorting

        -- C/C++ tools
        "clangd", -- C/C++ language server
        "clang-format", -- C/C++ formatter
        "codelldb", -- Debugger for C/C++
      })
    end,
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
      ---@type lspconfig.options
      servers = {
        cssls = {},
        tailwindcss = {
          root_dir = function(fname)
            return vim.fs.root(fname, ".git")
          end,
        },
        vtsls = {
          single_file_support = false,
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              suggest = {
                autoImports = true,
              },
              format = {
                indentSize = 2,
                tabSize = 2,
                convertTabsToSpaces = true,
              },
            },
            javascript = {
              inlayHints = {
                parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
              suggest = {
                autoImports = true,
              },
              format = {
                indentSize = 2,
                tabSize = 2,
                convertTabsToSpaces = true,
              },
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
        html = {},
        dockerls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yml",
                ["https://json.schemastore.org/docker-compose.json"] = "docker-compose*.yaml",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yaml",
                ["https://json.schemastore.org/kubernetes.json"] = "k8s*.yml",
                ["https://json.schemastore.org/kubernetes.json"] = "k8s*.yaml",
                ["https://json.schemastore.org/kubernetes.json"] = "*.k8s.yml",
                ["https://json.schemastore.org/kubernetes.json"] = "*.k8s.yaml",
              },
              format = {
                enable = true,
                singleQuote = false,
                bracketSpacing = true,
                proseWrap = "preserve",
              },
              validate = true,
              hover = true,
              completion = true,
            },
          },
        },
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
            },
          },
        },

        lua_ls = {
          -- enabled = false,
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  -- "--log-level=trace",
                },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
              doc = {
                privateName = { "^_" },
              },
              type = {
                castNumberToInteger = true,
              },
              diagnostics = {
                disable = { "incomplete-signature-doc", "trailing-space" },
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
      },
      setup = {},
    },
  },
  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
