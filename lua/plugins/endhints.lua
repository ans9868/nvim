-- putting inlay-hints inlay hints endhints at the end of the line rather then in the line
require("lsp-endhints").setup({
  icons = {
    type = "󰜁", -- Icon for type hints
    parameter = "󰏪", -- Icon for parameter hints
    offspec = "", -- For hints not defined in the LSP spec
    unknown = "", -- For unknown hint kinds
  },
  label = {
    truncateAtChars = 20, -- Truncate long hints
    padding = 1, -- Add padding between the hint and code
    marginLeft = 0, -- Left margin before the hint
    sameKindSeparator = ", ", -- Separator for hints of the same kind
  },
  extmark = {
    priority = 50, -- Priority of the virtual text
  },
  autoEnableHints = true, -- Automatically enable hints on LSP attach
})
