return {
  'mfussenegger/nvim-jdtls',
  settings = {
    java = {
      -- Custom eclipse.jdt.ls options go here
    },
  },
  config = function()
    vim.lsp.enable 'jdtls'
    -- TODO dont always boot up
  end,
}
