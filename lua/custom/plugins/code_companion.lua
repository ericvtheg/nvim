return {
  'olimorris/codecompanion.nvim',
  opts = function()
    local is_personal = os.getenv 'PERSONAL_COMPUTER' == 'true'
    local adapter = is_personal and 'anthropic' or 'copilot'

    return {
      strategies = {
        chat = {
          adapter = adapter,
        },
        inline = {
          adapter = adapter,
        },
        cmd = {
          adapter = adapter,
        },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'ANTHROPIC_API_KEY',
            },
          })
        end,
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            -- Copilot adapter config
          })
        end,
      },
    }
  end,
}
