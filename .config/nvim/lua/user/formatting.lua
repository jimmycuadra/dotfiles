local conform_ok, conform = pcall(require, "conform")
if not conform_ok then
  return
end

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    lua = { "stylua" },
    python = { "black" },
    ruby = { "rubocop" },
  },
})

-- Run Rubocop with `bundle exec` if we're in a Bundler project that uses RuboCop.
if require("user.ruby").has_gem("rubocop") then
  conform.formatters.rubocop = {
    prepend_args = { "bundle", "exec" },
  }
end

local conform_format = function()
  return conform.format({
    lsp_fallback = true,
  })
end

vim.keymap.set("n", "<leader>F", conform_format, { silent = true })
vim.keymap.set("x", "<leader>F", conform_format, { silent = true })
