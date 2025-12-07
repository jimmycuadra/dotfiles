local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
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

local fzf_path = "/opt/homebrew/opt/fzf"

if not vim.uv.fs_stat(fzf_path) then
  fzf_path = "/usr/local/opt/fzf"
end

require("lazy").setup({
  -- Colorschemes
  { "catppuccin/nvim", name = "catppuccin" },

  -- Multiple cursors
  "mg979/vim-visual-multi",

  -- Comment/uncomment selections
  "tpope/vim-commentary",

  -- Repeat things with . that you normally can't
  "tpope/vim-repeat",

  -- Ignore casing for save and quit commands
  "takac/vim-commandcaps",

  -- Preview registers when pressing " in normal mode
  {
    "tversteeg/registers.nvim",
    cmd = "Registers",
    config = true,
    keys = {
      { '"', mode = { "n", "v" } },
      { "<c-r>", mode = { "i" } },
    },
  },

  -- Install with `brew install fzf`
  { dir = fzf_path },
  {
    "junegunn/fzf.vim",
    config = function()
      require("user.fzf")
    end,
  },

  -- Add, remove, and change things like braces and brackets around objects
  {
    "kylechui/nvim-surround",
    opts = {},
  },

  -- Tree-sitter-aware '%' mapping
  {
    "andymass/vim-matchup",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- Add vertical lines to mark levels of indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local hooks = require("ibl.hooks")

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      require("ibl").setup({
        indent = {
          highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
          },
        },
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {
      cmdline = {
        enabled = false,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
          draw = {
            columns = {
              { "kind_icon", "label", "source_name", gap = 1 },
            },
          },
        },
      },
      keymap = {
        preset = "super-tab",
        ["<c-k>"] = { "scroll_documentation_up", "fallback" },
        ["<c-j>"] = { "scroll_documentation_down", "fallback" },
        -- Disable default documentation scroll mappings
        ["<c-b>"] = {},
        ["<c-f>"] = {},
      },
    },
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
    },
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

  -- tree-sitter-oxiby
  {
    "oxiby/tree-sitter-oxiby",
    dev = true,
  },

  -- tree-sitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = "all",
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      matchup = {
        enable = true,
      },
    },
    config = function(_, opts)
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.oxiby = {
        install_info = {
          url = "~/Code/tree-sitter-oxiby",
          files = { "src/parser.c" },
        },
        filetype = "ob",
      }
      require("nvim-treesitter.configs").setup(opts)
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
  dev = {
    path = "~/Code",
    patterns = {
      "oxiby",
    },
  },
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
