-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- to ensure that fzf uses gnu find and not macos find
vim.env.PATH = "/usr/local/opt/coreutils/libexec/gnubin:" .. vim.env.PATH
vim.env.PATH = "/opt/homebrew/opt/coreutils/libexec/gnubin:" .. vim.env.PATH
vim.env.PATH = "/opt/homebrew/opt/findutils/libexec/gnubin:" .. vim.env.PATH
require("fzf-lua").setup({
  files = {
    cmd = "gfind . -type f -printf '%P\n'",
  },
})
