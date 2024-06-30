---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    --  format with conform
    ["<leader>fm"] = {
      function()
        require("conform").format()
      end,
      "formatting",
    },

    ["<leader>gi"] = {
      function()
        vim.cmd "LazyGit"
      end,
      "Enter git interface (LazyGit)",
    },
    ["<C-s>"] = {
      function()
        local ft = vim.api.nvim_buf_get_option(0, 'filetype')
        if ft == 'javascript' or ft == 'typescript' or ft == 'typescriptreact' then
          pcall(function()
            vim.cmd("EslintFixAll")
          end)
        end
        vim.cmd("update")
      end,
      "lint and save file",
    },
  },
  i = {
    -- add Ctrl+s mapping to exit insert mode and save file
    ["<C-s>"] = {
      function()
        vim.api.nvim_input("<Esc>")
        local ft = vim.api.nvim_buf_get_option(0, 'filetype')
        if ft == 'javascript' or ft == 'typescript' or ft == 'typescriptreact' then
          pcall(function()
            vim.cmd("EslintFixAll")
          end)
        end
        vim.cmd("update")
      end,
      "exit insert mode, lint, and save file",
    },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
