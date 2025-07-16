return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {},
  opts = {
    notify_on_error = false,
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 500,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettierd', 'prettier', 'eslint_d' },
      typescriptreact = { 'prettierd', 'prettier', 'eslint_d' },
      javascript = { 'prettierd', 'prettier', 'eslint_d' },
      javascriptreact = { 'prettierd', 'prettier', 'eslint_d' },
      yaml = { 'prettierd', 'prettier' },
      yml = { 'prettierd', 'prettier' },
      json = { 'prettierd', 'prettier' },
    },
  },
}
