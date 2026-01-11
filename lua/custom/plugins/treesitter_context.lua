return {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    max_lines = 1,           -- Only show innermost context (the function)
    min_window_height = 20,  -- Don't show if window is too small
    separator = nil,         -- No separator line (subtle)
    mode = 'cursor',         -- Show context based on cursor position
  },
}
