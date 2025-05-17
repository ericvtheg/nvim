-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      use_libuv_file_watcher = true, -- use os file watchers
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<C-d>'] = { 'scroll_preview', config = { direction = -10 } },
          ['y'] = function(state)
            local node = state.tree:get_node()
            local filename = node.name
            vim.fn.setreg('"', filename)
            vim.notify('Copied: ' .. filename)
          end,
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg('"', filepath)
            vim.notify('Copied: ' .. filepath)
          end,
        },
      },
      group_empty_dirs = true,
      scan_mode = 'deep',
    },
  },
}
