return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- Set the environment variable for eslint_d
    vim.env.ESLINT_D_PPID = vim.fn.getpid()

    -- Configure linters for different filetypes
    require('lint').linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
    }

    -- Lint after saves or when leaving insert; skip BufRead to avoid stale diagnostics on open
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
