-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true -- Show line numbers in the editor
vim.opt.title = true -- Set the terminal title to the filename
vim.opt.autoindent = true -- Enable automatic indentation
vim.opt.smartindent = true -- Enable smarter automatic indentation based on syntax
vim.opt.hlsearch = true -- Highlight search results
vim.opt.backup = false -- Do not create backup files
vim.opt.showcmd = true -- Show incomplete commands in the status line
vim.opt.cmdheight = 0 -- Set the command line height to 0 (requires a plugin or modern Vim)
vim.opt.laststatus = 0 -- Disable the status line
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below the cursor when scrolling
vim.opt.inccommand = "split" -- Show command input in a split window (requires modern Vim)
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smarttab = true -- Enable smart tab behavior (align based on context)
vim.opt.breakindent = true -- Maintain indentation for wrapped lines
vim.opt.shiftwidth = 2 -- Number of spaces to use for auto-indenting
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.wrap = false -- Disable line wrapping
vim.opt.backspace = { "start", "eol", "indent" } -- Allow backspacing over everything in insert mode
vim.opt.path:append({ "**" }) -- Allow searching for files in subdirectories with `:find`
vim.opt.wildignore:append({ "*/node_modules/*" }) -- Ignore files in `node_modules` when using wildcards
vim.opt.splitbelow = true -- Force horizontal splits to open below the current window
vim.opt.splitright = true -- Force vertical splits to open to the right of the current window
-- vim.opt.splitkeep = "cursor" -- Keep the cursor position when opening splits (modern Vim feature)
-- vim.opt.mouse = ""                  -- Disable mouse support
vim.opt.formatoptions:append({ "r" }) -- Automatically insert a comment leader when pressing Enter
