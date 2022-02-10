if has('nvim')
lua <<EOF
require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "bash",
    "css",
    "dockerfile",
    "go",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "jsonc",
    "ruby",
    "rust",
    "scss",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },

  highlight = {
    enable = true,
  },

  incremental_selection = {
    enable = true,

    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  indent = {
    enable = true
  },
})
EOF

  set foldexpr=nvim_treesitter#foldexpr()
end
