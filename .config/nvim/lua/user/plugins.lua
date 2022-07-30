local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.cmd [[packadd packer.nvim]]
end

local ok, packer = pcall(require, "packer")
if not ok then return end

packer.startup(function(use)
  use "wbthomason/packer.nvim"

  -- Install with `brew install fzf`
  use "/usr/local/opt/fzf"
  use "junegunn/fzf.vim"

  -- Railscasts color scheme
  use "jgdavey/vim-railscasts"

  -- Multiple cursors
  use "mg979/vim-visual-multi"

  -- Comment/uncomment selections
  use "tpope/vim-commentary"

  -- Mappings for navigation
  use "tpope/vim-ragtag"

  -- Repeat things with . that you normally can't
  use "tpope/vim-repeat"

  -- Add, remove, and change things like braces and brackets around objects
  use "tpope/vim-surround"

  -- Add faint vertical lines to mark levels of indentation
  use "yggdroot/indentline"

  -- Completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "L3MON4D3/LuaSnip"

  -- LSP
  use "neovim/nvim-lspconfig"
  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  }

  -- Git
  use "tpope/vim-fugitive"

  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
