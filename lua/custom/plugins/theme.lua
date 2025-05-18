return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    vim.cmd.colorscheme 'kanagawa-wave'

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'
  end,
  -- all color schemes
  dependencies = {
    'folke/tokyonight.nvim',
    'navarasu/onedark.nvim',
    'sainnhe/gruvbox-material',
    'catppuccin/nvim',
    'rebelot/kanagawa.nvim',
    'scottmckendry/cyberdream.nvim',
  },
}
