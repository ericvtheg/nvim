return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {},
  ft = { 'markdown', 'codecompanion' },
  config = function(_, opts)
    require('render-markdown').setup(opts)

    -- Ensure treesitter highlighting is enabled for markdown
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown', 'codecompanion' },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- Ensure treesitter is loaded
  },
}
