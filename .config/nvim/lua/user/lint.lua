local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
  return
end

lint.linters_by_ft = {
  python = { "flake8" },
  ruby = { "rubocop" },
}

-- LSP servers automatically update a few seconds after you stop
-- typing ('updatetime') but nvim-lint seems to require this
-- to be set manually.
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    lint.try_lint()
  end,
})
