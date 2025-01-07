-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x') -- saves delete 1 character to underlying character i.e. nowhere

-- Increment/decrement an integer
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Save file quit file
-- keymap.set("n", "<Leader>w", ":update<Return>") --same as ':w'
keymap.set("n", "<Leader>q", ":quit<Return>") -- quit with some special options
keymap.set("n", "<Leader>W", ":wa<Return>") -- write to all open buffers ie files neovim is editing
keymap.set("n", "<Leader>Q", ":qa<Return>") -- quit all open buffers ie files neovim is editing

--  sellect all
keymap.set("n", "<C-a>", "gg0<S-v>G")

keymap.set("n", "dummy", "$")

-- Tabs

keymap.set("n", "te", ":tabedit") -- open and edit new tab tab
-- keymap.set("n", "tc", ":tabclose<Return> | bdelete %<CR>", opts) -- close current tab
keymap.set("n", "<tab>", ":tabnext<Return>", opts) -- go to next tab
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts) -- go to previous tab

keymap.set("n", "tc", function() -- close current tab, buffer or window
  local buf = vim.api.nvim_get_current_buf() -- Get the current buffer ID
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.cmd("tabclose") -- Close the current tab if more than one tab exists
  elseif #vim.api.nvim_list_wins() > 1 then
    vim.cmd("close") -- Close the current window if more than one exists
  else
    vim.api.nvim_buf_delete(buf, { force = true }) -- Otherwise, delete the buffer
  end
end, opts)

--Dadbod keymap i.e. sql database explorer
vim.keymap.set("n", "<leader>Q", "<cmd>tabnew<cr><bar><bar><cmd>DBUI<cr>", { noremap = true, silent = true })

-- Neotree keymaps
-- <Leader>e --> open neotree rootDir
-- <Leader>E --> open neotree cwd
vim.api.nvim_set_keymap(
  "n",
  "<leader>D",
  ":Neotree toggle_hidden<CR>",
  { noremap = true, silent = true, desc = "Toggle hidden files in NeoTree" }
)

--LazyTree shortcuts, removed and replaced with neo-tree ?
--[[
keymap.set("n", "<Leader>t", ":NvimTreeToggle<Return>", opts)
keymap.set("n", "<Leader>f", ":NvimTree<Return>", opts)
-- Allow dotfiles in nvim tree ie file explorer that pops up on the left
vim.keymap.set("n", "<leader>d", ":NvimTreeToggleDotfiles<CR>", { desc = "Toggle Dotfiles in Nvim-Tree" })
]]

-- Split window
keymap.set("n", "ss", ":split<Return>", opts) -- split current window into 2 horizontally
keymap.set("n", "sv", ":vsplit<Return>", opts) -- split current window into 2 vertically

-- Move window
keymap.set("n", "wh", "<C-w>h") -- Changefocus window to be the left window
keymap.set("n", "wk", "<C-w>k")
keymap.set("n", "wj", "<C-w>j")
keymap.set("n", "wl", "<C-w>l")

-- Resize Window
keymap.set("n", "<C-S-l>", "<C-w>>") -- Increase window width
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-k>", "<C-w>+") -- Increase window height
keymap.set("n", "<C-S-j>", "<C-w>-")

-- Diagnostic / error check, goes to next error, *notice* ";e" will open new window with all error commands

keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)
