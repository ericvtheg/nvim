return {
  'olimorris/codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
  keys = {
    {
      '<C-a>',
      '<cmd>CodeCompanionActions<CR>',
      desc = 'CodeCompanion: Open the action palette',
      mode = { 'n', 'v' },
    },
    {
      '<leader>a',
      '<cmd>CodeCompanionChat Toggle<CR>',
      desc = 'CodeCompanion: Toggle a chat buffer',
      mode = { 'n', 'v' },
    },
    {
      '<LocalLeader>a',
      '<cmd>CodeCompanionChat Add<CR>',
      desc = 'CodeCompanion: Add code to a chat buffer',
      mode = { 'v' },
    },
  },
  opts = function()
    local is_personal = os.getenv 'PERSONAL_COMPUTER' == 'true'
    local adapter = is_personal and 'anthropic' or 'copilot'

    print(adapter)

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
