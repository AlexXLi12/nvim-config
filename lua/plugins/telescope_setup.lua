local builtin = require('telescope.builtin')

-- keybindings
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

local telescope = require('telescope')

telescope.load_extension('fzf')
telescope.setup({
  defaults = {
    file_ignore_patterns = {
      "go",                -- Go modules
      "node_modules/",              -- Node
      "%.lock",                     -- Lock files
      "__pycache__/", "env/",       -- Python
      "%.class$",                   -- Java class files
      "%.o$", "%.out$",             -- C/C++ build artifacts
    },
  },
})

