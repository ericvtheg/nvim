local Path = require 'plenary.path'

return {
  'scalameta/nvim-metals',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- Make sure this is included since your bindings use it
    {
      'j-hui/fidget.nvim',
      opts = {},
    },
    {
      'mfussenegger/nvim-dap',
      config = function(self, opts)
        -- Debug settings if you're using nvim-dap
        local dap = require 'dap'

        dap.configurations.scala = {
          {
            type = 'scala',
            request = 'launch',
            name = 'Run or Test Target',
            metals = {
              runType = 'runOrTestFile',
            },
          },
          {
            type = 'scala',
            request = 'launch',
            name = 'Test Target',
            metals = {
              runType = 'testTarget',
            },
          },
          {
            type = 'scala',
            request = 'attach',
            name = 'Attach to Localhost',
            hostName = 'localhost',
            port = 5005,
            buildTarget = 'root',
          },
        }
      end,
    },
  },
  ft = { 'scala', 'sbt', 'java' },
  opts = function()
    local metals_config = require('metals').bare_config()

    -- Example of settings
    metals_config.settings = {
      showImplicitArguments = true,
      fallbackScalaVersion = '2.12.18',
    }

    -- *READ THIS*
    -- I *highly* recommend setting statusBarProvider to either "off" or "on"
    --
    -- "off" will enable LSP progress notifications by Metals and you'll need
    -- to ensure you have a plugin like fidget.nvim installed to handle them.
    --
    -- "on" will enable the custom Metals status extension and you *have* to have
    -- a have settings to capture this in your statusline or else you'll not see
    -- any messages from metals. There is more info in the help docs about this
    metals_config.init_options.statusBarProvider = 'off'

    -- Set this to a reasonable value based on your deepest nesting
    metals_config.find_root_dir_max_project_nesting = 10

    -- Custom root directory finder that prioritizes the current directory
    metals_config.find_root_dir = function(patterns, startpath)
      -- First try using the startpath directly if it contains any of the patterns
      local direct_match = vim.fn.getcwd()
      for _, pattern in ipairs(patterns) do
        local target = direct_match .. '/' .. pattern
        if vim.fn.filereadable(target) == 1 or vim.fn.isdirectory(target) == 1 then
          return direct_match
        end
      end

      -- Fall back to traversing upward if direct match fails
      local path = Path:new(startpath)
      for _, parent in ipairs(path:parents()) do
        for _, pattern in ipairs(patterns) do
          local target = Path:new(parent, pattern)
          if target:exists() then
            return parent
          end
        end
      end

      -- If nothing found, use vim's current working directory
      return vim.fn.getcwd()
    end
    -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
    metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

    metals_config.on_attach = function(client, bufnr)
      require('metals').setup_dap()
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = self.ft,
      callback = function()
        require('metals').initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
