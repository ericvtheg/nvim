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
      typescript = { 'prettierd', 'eslint_d' },
      typescriptreact = { 'prettierd', 'eslint_d' },
      javascript = { 'prettierd', 'eslint_d' },
      javascriptreact = { 'prettierd', 'eslint_d' },
      yaml = { 'prettierd', 'prettier' },
      yml = { 'prettierd', 'prettier' },
      json = { 'prettierd', 'prettier' },
    },
  },
}
