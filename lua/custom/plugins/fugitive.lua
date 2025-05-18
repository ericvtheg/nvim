return {
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  config = function()
    vim.keymap.set('n', '<leader>go', function()
      vim.cmd 'GBrowse'
    end, { desc = '[g]it [o]pen remote', noremap = true })

    vim.keymap.set('n', '<leader>gb', function()
      vim.cmd 'Git blame'
    end, { desc = '[g]it [b]lame', noremap = true })
  end,
}
