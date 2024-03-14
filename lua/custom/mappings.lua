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
  },
  i = {
    -- add Ctrl+s mapping to exit insert mode and save file
    ["<C-s>"] = {
      function()
        vim.cmd("update")
        vim.api.nvim_input("<Esc>")
      end,
      "exit insert mode and save file",
    },
  },
  v = {
    [">"] = { ">gv", "indent" },
  },
}

-- more keybinds!

return M
