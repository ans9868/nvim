return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        --fullstack development
        "javascript",
        "typescript",
        "tsx",
        "css",
        "gitignore",
        "graphql",
        "http",
        "json",
        "scss",
        "sql",
        "vim",
        "lua",
        --other
        "python",
        "c",
        "cpp",
      },
      ignore_install = { "xml", "printf" },
    },
  },
}
