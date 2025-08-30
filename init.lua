--Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup
require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim", config = true },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    config = function()
      require("lsp")
    end,
  },

  -- TreeSitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "c",
          "cpp",
          "java",
          "typescript",
          "html",
          "css",
          "sql",
          "python",
          "markdown",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
      -- enable code folding
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require("plugins.telescope_setup")
    end,
  },

  -- nvim-jdtls (Java LSP plugin)
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" }, -- Only load for Java files
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp_setup")
    end,
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  -- Fugitive for git
  { "tpope/vim-fugitive" },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins.harpoon_setup")
    end,
  },

  -- Github Copilot
  { "github/copilot.vim" },

  -- Colorscheme
  { "catppuccin/nvim",   name = "catppuccin", priority = 1000 },
})

local opt = vim.opt

-- Editor options
opt.number = true
opt.relativenumber = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.mouse = ""
opt.updatetime = 100

-- nvim copy goes to terminal emulator clipboard
vim.g.clipboard = 'osc52'

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 150 })
  end,
})

-- Filetype plugins
vim.cmd([[filetype plugin indent on]])

-- Colorscheme
vim.cmd.colorscheme("catppuccin")

-- Remappings
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move highlighted lines down, reindent" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move highlighted lines up, reindent" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "keep cursor centered after moving" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "keep cursor centered after moving" })
vim.keymap.set("n", "n", "nzz", { desc = "keep cursor centered when searching" })
vim.keymap.set("n", "N", "Nzz", { desc = "keep cursor centered when searching" })
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y", { desc = "yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "yank to system clipboard" })
vim.keymap.set("n", "Q", "@q", { desc = "Replay macro in register q" })
vim.keymap.set("n", "<leader>z", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader>o", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>c", "zM", { desc = "Close all folds" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Open git status" })
