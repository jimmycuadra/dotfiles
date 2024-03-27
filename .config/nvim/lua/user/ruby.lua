local M = {}

-- Check if a gem is in the project's Gemfile
M.has_gem = function(gem)
  if not vim.fn.executable("rg") then
    vim.notify("Install `ripgrep` to determine whether or not a project has a certain gem.")
    return false
  end

  local ret_code = nil
  local jid = vim.fn.jobstart(string.format("rg %s Gemfile", gem), {
    on_exit = function(_, data)
      ret_code = data
    end,
  })
  vim.fn.jobwait({ jid }, 5000)
  return ret_code == 0
end

return M
