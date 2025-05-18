-- Set the default tab width to 2 spaces
vim.o.tabstop = 2

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Set the number of spaces for each indentation level
vim.o.shiftwidth = 2

-- Set the number of spaces to use for auto-indentation
vim.o.softtabstop = 2

-- views can only be fully collapsed with the global statusline (for avante nvim)
vim.opt.laststatus = 3

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true
vim.opt.briopt = 'shift:2'
vim.opt.linebreak = true

-- Help height
vim.opt.helpheight = 99999

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- sync buffers automatically
vim.opt.autoread = true
-- disable neovim generating a swapfile and showing the error
vim.opt.swapfile = false

vim.opt_global.shortmess:remove 'F'

-- Set GIT_EDITOR to use nvr if Neovim and nvr are available
if vim.fn.has 'nvim' == 1 and vim.fn.executable 'nvr' == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })

-- Git
vim.keymap.set('n', '<leader>gi', function()
  vim.cmd 'LazyGit'
end, { desc = 'Open [g]it [i]nterface', noremap = true })

vim.keymap.set('n', '<leader>go', function()
  vim.cmd 'GBrowse'
end, { desc = '[g]it [o]pen remote', noremap = true })

vim.keymap.set('n', '<leader>gb', function()
  vim.cmd 'Git blame'
end, { desc = '[g]it [b]lame', noremap = true })

-- Buffers
vim.keymap.set('n', '<leader>bp', function()
  vim.cmd 'b#'
end, { desc = '[b]uffer [p]rev', noremap = true })

-- Add this new keymap to close all buffers
vim.keymap.set('n', '<leader>bX', function()
  vim.cmd '%bd|e#|bd#'
end, { desc = 'Close [B]uffer All', noremap = true })

-- Map Ctrl+s to save
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
vim.keymap.set('c', '<C-s>', '<C-c>:w<CR>', { noremap = true, silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- Buffer diagnostics
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev { wrap = false }
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next { wrap = false }
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Workspace diagnostics
vim.keymap.set('n', '<leader>wa', vim.diagnostic.setqflist, { desc = 'Show [W]orkspace [A]ll diagnostics' })
vim.keymap.set('n', '<leader>we', function()
  vim.diagnostic.setqflist { severity = vim.diagnostic.severity.ERROR }
end, { desc = 'Show [W]orkspace [E]rror diagnostics' })
vim.keymap.set('n', '<leader>ww', function()
  vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
end, { desc = 'Show [W]orkspace [W]arning diagnostics' })

-- Terminal toggle function
vim.api.nvim_set_keymap('t', '<C-n>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<C-\\>', [[<C-\><C-n>]], { noremap = true, silent = true })

local function ToggleTerminal()
  -- Find a terminal buffer
  local term_bufnr = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      term_bufnr = buf
      break
    end
  end

  if term_bufnr then
    -- Terminal buffer exists, toggle its visibility
    local term_win = vim.fn.bufwinnr(term_bufnr)
    if term_win ~= -1 then
      -- Terminal is visible, close it
      vim.api.nvim_win_close(vim.fn.win_getid(term_win), true)
    else
      -- Terminal exists but is not visible, show it
      vim.cmd 'botright split'
      vim.api.nvim_win_set_buf(0, term_bufnr)
      vim.cmd 'resize 15'
    end
  else
    -- No terminal buffer exists, create a new one
    vim.cmd 'botright 15split | terminal'
    term_bufnr = vim.api.nvim_get_current_buf()
    -- Set buffer-local options
    vim.api.nvim_buf_set_option(term_bufnr, 'buflisted', false)
    vim.api.nvim_buf_set_option(term_bufnr, 'filetype', 'term')
  end
end

-- Set up keymappings

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `config` key, the configuration only runs
  -- after the plugin has been loaded:
  --  config = function() ... end

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ebug', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]erminal', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
        ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
        ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
    end,
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  { import = 'custom.plugins' },
}, {
  change_detection = {
    enabled = false,
    notify = false,
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
