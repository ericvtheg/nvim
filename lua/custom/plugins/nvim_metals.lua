local Path = require 'plenary.path'

return {
  'scalameta/nvim-metals',
  ft = { 'scala', 'sbt', 'java' },
  opts = function()
    local metals_config = require('metals').bare_config()

    metals_config.settings = {
      showImplicitArguments = true,
      fallbackScalaVersion = '2.13.16',
      defaultBspToBuildTool = true,
      enableBestEffort = true,
      inlayHintsOptions = {
        byNameParameters = { enable = true },
        hintsInPatternMatch = { enable = true },
        implicitArguments = { enable = true },
        implicitConversions = { enable = true },
        inferredTypes = { enable = true },
        typeParameters = { enable = true },
      },
      superMethodLensesEnabled = true,
    }

    metals_config.server_properties = {
      -- Memory allocation for Metals
      '-Xms2G',
      '-Xmx6G',
    }

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
