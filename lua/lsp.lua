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

-- Dumb workaround for hover not showing special characters properly
local pretty_hover = function()
  local client = vim.lsp.get_clients({ bufnr = 0 })[1]
  local position_encoding = client and client.offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, position_encoding)

  vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
    if err then
      vim.notify("LSP hover error: " .. err.message, vim.log.levels.ERROR)
      return
    end
    if not (result and result.contents) then
      vim.notify("No hover info", vim.log.levels.INFO)
      return
    end

    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = vim.tbl_map(
      function(line)
        line = string.gsub(line, '&gt;', '>')
        line = string.gsub(line, '&lt;', '<')
        line = string.gsub(line, '&quot;', '"')
        line = string.gsub(line, '&apos;', "'")
        line = string.gsub(line, '&ensp;', ' ')
        line = string.gsub(line, '&emsp;', ' ')
        line = string.gsub(line, '&nbsp;', ' ')
        line = string.gsub(line, '&amp;', '&')
        line = line:gsub("\\(%p)", "%1")  -- turns \_ \* \[ \] \) etc. into _, *, [, ], )
        return line
      end,
      markdown_lines
    )

    if vim.tbl_isempty(markdown_lines) then
      vim.notify("No hover info", vim.log.levels.INFO)
      return
    end

    vim.lsp.util.open_floating_preview(markdown_lines, "markdown", { border = "rounded" })
  end)
end


-- Keybindings when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", pretty_hover, opts, { desc = "Pretty LSP hover" })
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
