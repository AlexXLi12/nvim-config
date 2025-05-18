local jdtls = require('jdtls')
local root_markers = {'.git', 'pom.xml', 'build.gradle'}
local root_dir = require('jdtls.setup').find_root(root_markers)
if root_dir == nil then return end
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

jdtls.start_or_attach({
  cmd = { vim.fn.expand('~/.local/share/nvim/mason/packages/jdtls/bin/jdtls') },
  root_dir = root_dir,
  workspace_folder = workspace_dir,
})

