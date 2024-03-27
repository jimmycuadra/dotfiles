local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
  return
end

lint.linters_by_ft = {
  python = { "flake8" },
  ruby = { "rubocop" },
}

-- Run Rubocop with `bundle exec` if we're in a Bundler project that uses RuboCop.
if require("user.ruby").has_gem("rubocop") then
  lint.linters.rubocop.cmd = "bundle"
  lint.linters.rubocop.args = vim.list_extend({ "exec", "rubocop" }, lint.linters.rubocop.args)
end

-- LSP servers automatically update a few seconds after you stop
-- typing ('updatetime') but nvim-lint seems to require this
-- to be set manually.
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    lint.try_lint()
  end,
})
