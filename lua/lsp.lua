-- Set up Mason (LSP installer)
require("mason").setup()

-- Ensure install list (this does NOT auto-setup servers)
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",       -- C, C++
    "jdtls",        -- Java
    "basedpyright", -- Python
    "html",         -- HTML
    "cssls",        -- CSS
    "sqls",         -- SQL
    "lua_ls",       -- Lua
  },
})

vim.lsp.config("basedpyright", {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "off", -- "off", "basic", "strict"
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Keybindings when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rf", function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

-- Diagnostics UI
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
