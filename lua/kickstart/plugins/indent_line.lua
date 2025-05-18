return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  config = function()
    -- Set the highlight groups
    vim.cmd [[highlight IndentBlanklineIndent1 guifg=#30465d guibg=#14262b gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guifg=#30465d guibg=#09262e gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent3 guifg=#30465d guibg=#161e37 gui=nocombine]]

    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Ensure highlights persist across colorscheme changes
      vim.cmd [[highlight IndentBlanklineIndent1 guifg=#30465d guibg=#14262b gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent2 guifg=#30465d guibg=#09262e gui=nocombine]]
      vim.cmd [[highlight IndentBlanklineIndent3 guifg=#30465d guibg=#161e37 gui=nocombine]]
    end)

    require('ibl').setup {
      indent = {
        char = '▎',
        highlight = {
          'IndentBlanklineIndent1',
          'IndentBlanklineIndent2',
          'IndentBlanklineIndent3',
        },
      },
      whitespace = {
        highlight = {
          'IndentBlanklineIndent1',
          'IndentBlanklineIndent2',
          'IndentBlanklineIndent3',
        },
      },
      scope = { enabled = false }, -- Disable if you're not using scope highlighting
    }
  end,
}
