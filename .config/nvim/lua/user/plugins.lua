local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  -- Colorschemes
  "jimmycuadra/vim-railscasts",
  { "catppuccin/nvim", name = "catppuccin" },

  -- Install with `brew install fzf`
  { dir = "/opt/homebrew/opt/fzf" },
  {
    "junegunn/fzf.vim",
    config = function()
      require("user.fzf")
    end,
  },

  -- Multiple cursors
  "mg979/vim-visual-multi",

  -- Comment/uncomment selections
  "tpope/vim-commentary",

  -- Mappings for navigation
  "tpope/vim-ragtag",

  -- Repeat things with . that you normally can't
  "tpope/vim-repeat",

  -- Add, remove, and change things like braces and brackets around objects
  {
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Add faint vertical lines to mark levels of indentation
  "yggdroot/indentline",

  -- Ignore casing for save and quit commands
  "takac/vim-commandcaps",

  -- Preview registers when pressing " in normal mode
  "tversteeg/registers.nvim",

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("user.completion")
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("user.lsp")
    end,
  },
  {
    -- brew install black prettier stylua
    "stevearc/conform.nvim",
    config = function()
      require("user.formatting")
    end,
  },
  {
    -- brew install flake8
    -- gem install rubocop
    "mfussenegger/nvim-lint",
    config = function()
      require("user.lint")
    end,
  },

  -- tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("user.treesitter")
    end,
  },

  -- Lua + Neovim
  "folke/neodev.nvim",

  -- CoffeeScript
  {
    "kchmck/vim-coffee-script",
    ft = { "coffee", "litcoffee" },
  },

  -- Docker
  {
    "ekalinin/Dockerfile.vim",
    ft = { "Dockerfile" },
  },

  -- Elixir
  {
    "elixir-lang/vim-elixir",
    ft = { "elixir" },
  },

  -- Elm
  {
    "ElmCast/elm-vim",
    ft = { "elm" },
    config = function()
      vim.api.nvim_set_var("elm_format_autosave", 1)
    end,
  },

  -- Git
  "tpope/vim-fugitive",

  -- Go
  {
    "fatih/vim-go",
    build = ":GoUpdateBinaries",
    ft = { "go" },
  },

  -- Nginx
  {
    "chr4/nginx.vim",
    ft = { "nginx" },
  },

  -- Protocol Buffers
  {
    "uarun/vim-protobuf",
    ft = { "proto" },
  },

  -- RBS
  {
    "jlcrochet/vim-rbs",
    ft = { "rbs" },
  },

  -- Terraform
  "hashivim/vim-terraform",

  -- TypeScript
  {
    "HerringtonDarkholme/yats.vim",
    ft = { "typescript", "typescriptreact" },
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "rrhelper",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
})
