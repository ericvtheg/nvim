return {
  'timelapse.nvim',
  dir = vim.fn.stdpath('config') .. '/lua/timelapse',
  config = function()
    require('timelapse').setup()
  end,
  cmd = { 'TimeLapse', 'TimeLapseStop', 'TimeLapsePause' },
}