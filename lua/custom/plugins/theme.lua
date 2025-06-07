return {
  'scottmckendry/cyberdream.nvim',
  lazy = false,
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    vim.cmd.colorscheme 'gruvbox-material'

    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

    -- Show which line your cursor is on
    vim.opt.cursorline = true

    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'

    vim.opt.cursorlineopt = 'number'
    -- Get a bright color from your theme
    local error_hl = vim.api.nvim_get_hl(0, { name = 'Error' })
    if error_hl.fg then
      vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = error_hl.fg, bold = true })
    end
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
