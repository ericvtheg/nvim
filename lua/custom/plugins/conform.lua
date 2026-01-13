return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {},
  opts = {
    notify_on_error = false,
    format_on_save = {
      lsp_format = 'fallback',
      timeout_ms = 10000,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      typescript = { 'prettierd', 'eslint_d' },
      typescriptreact = { 'prettierd', 'eslint_d' },
      javascript = { 'prettierd', 'eslint_d' },
      javascriptreact = { 'prettierd', 'eslint_d' },
      -- yaml = { 'yamlfmt' }, -- Disabled: too opinionated, reformats entire file
      -- yml = { 'yamlfmt' },  -- Disabled: too opinionated, reformats entire file
      json = { 'prettierd' },
    },
  },
}
