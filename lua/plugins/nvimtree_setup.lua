local api = require("nvim-tree.api")

require("nvim-tree").setup({
  on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<leader>e', api.tree.toggle, { desc = "Toggle file explorer" })
  end,
})

-- Auto-open tree when launching nvim with no args or into a directory
local function open_nvim_tree()
    local argc = vim.fn.argc()

    -- If launched with no args: open tree
    if argc == 0 then
      vim.schedule(function() api.tree.open() end)
      return
    end

    -- If first arg is a directory: cd and open tree
    local first = vim.fn.argv(0)
    if vim.fn.isdirectory(first) == 1 then
      vim.cmd.cd(first)
      vim.schedule(function() api.tree.open() end)
    end
  end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = open_nvim_tree,
})

-- Auto-reopen tree after session restore
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSessionRestorePost",
  callback = function()
    vim.schedule(function() api.tree.open() end)
  end,
})
