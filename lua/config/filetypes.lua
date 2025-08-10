-- File type associations for Docker and YAML files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "docker-compose*.yml",
    "docker-compose*.yaml",
    "*.docker-compose.yml",
    "*.docker-compose.yaml",
    "docker-compose.yml",
    "docker-compose.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})

-- Associate .yml and .yaml files with YAML filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yml", "*.yaml" },
  callback = function()
    vim.bo.filetype = "yaml"
  end,
})

-- Dockerfile associations
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "Dockerfile*", "*.dockerfile" },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})

-- Python file associations
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.py", "*.pyw", "*.pyi", "*.pyx", "*.pxd", "*.pxi" },
  callback = function()
    vim.bo.filetype = "python"
  end,
})

-- Python configuration files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "requirements*.txt", "setup.py", "pyproject.toml", "Pipfile", "poetry.lock" },
  callback = function()
    vim.bo.filetype = "toml"
  end,
})

-- React/JavaScript file associations
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.mjs", "*.cjs" },
  callback = function()
    if vim.fn.expand("%:e") == "tsx" then
      vim.bo.filetype = "typescriptreact"
    elseif vim.fn.expand("%:e") == "jsx" then
      vim.bo.filetype = "javascriptreact"
    elseif vim.fn.expand("%:e") == "ts" then
      vim.bo.filetype = "typescript"
    elseif vim.fn.expand("%:e") == "js" then
      vim.bo.filetype = "javascript"
    end
  end,
})

-- React configuration files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "package.json", "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "tsconfig.json", "jsconfig.json" },
  callback = function()
    vim.bo.filetype = "json"
  end,
}) 