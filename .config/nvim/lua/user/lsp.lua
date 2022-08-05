local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  return
end
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
  return
end
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  return
end
local machine_ok, machine = pcall(require, "user.machine")

local o = vim.opt

-- Add more space for messages
o.cmdheight = 2

-- Display signs over line numbers
o.signcolumn = "number"

-- Configure diagnostics
vim.diagnostic.config({
  -- Only show diagnostics in floating windows
  virtual_text = false,
  float = {
    -- Show which LSP source produced the diagnostic
    source = true,
  },
})

-- Adds the 'winhighlight' options nvim-cmp uses for documentation floating windows to
-- LSP floating windows created by the provided handler
local with_cmp_style_highlights = function(handler)
  return function(err, result, ctx, config)
    local _, winnr = handler(err, result, ctx, config)

    if winnr then
      vim.api.nvim_win_set_option(
        winnr,
        "winhighlight",
        "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None"
      )
    end
  end
end

vim.lsp.handlers["textDocument/hover"] = with_cmp_style_highlights(vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
  width = 60,
}))

vim.lsp.handlers["textDocument/signatureHelp"] =
  with_cmp_style_highlights(vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    width = 60,
  }))

local map = vim.keymap.set

local opts = { silent = true }

-- Navigate diagnostics
map("n", "[g", vim.diagnostic.goto_prev, opts)
map("n", "]g", vim.diagnostic.goto_next, opts)
map("n", "<leader>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  local buffer_opts = { silent = true, buffer = bufnr }

  -- Prefer formatting from null-ls
  if vim.tbl_contains({
    "tsserver",
    "sumneko_lua",
    "html",
    "jsonls",
  }, client.name) then
    client.resolved_capabilities.document_formatting = false
  end

  map("n", "K", vim.lsp.buf.hover, buffer_opts)
  map("n", "<m-k>", vim.lsp.buf.signature_help, buffer_opts)

  map("n", "gd", vim.lsp.buf.definition, buffer_opts)
  map("n", "gD", vim.lsp.buf.declaration, buffer_opts)
  map("n", "gr", vim.lsp.buf.references, buffer_opts)
  map("n", "gy", vim.lsp.buf.type_definition, buffer_opts)
  map("n", "gi", vim.lsp.buf.implementation, buffer_opts)

  map("n", "<leader>F", vim.lsp.buf.formatting, buffer_opts)
  map("x", "<leader>F", vim.lsp.buf.range_formatting, buffer_opts)
  map("n", "<leader>c", vim.lsp.buf.code_action, buffer_opts)
  map("x", "<leader>c", vim.lsp.buf.range_code_action, buffer_opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, buffer_opts)
end

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Check if a gem is in the project's Gemfile
local has_gem = function(gem)
  if not vim.fn.executable("rg") then
    vim.notify("Install ripgrep to use bundled gems for LSP")
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

-- Decide whether or not to enable a particular LSP server based on
-- machine-specific configuration that is not committed
local use_server = function(server)
  if machine_ok and machine.enable_lsp_server and machine.enable_lsp_server[server] then
    return machine.enable_lsp_server[server]()
  end

  return true
end

-- yarn global add bash-language-server
if use_server("bashls") then
  lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- yarn global add vscode-langservers-extracted
if use_server("cssls") then
  lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- yarn global add dockerfile-language-server-nodejs
if use_server("dockerls") then
  lspconfig.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- yarn global add vscode-langservers-extracted
if use_server("html") then
  lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- yarn global add vscode-langservers-extracted
if use_server("jsonls") then
  lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- brew install pyright
if use_server("pyright") then
  lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- brew install rust-analyzer
-- rustup component add rust-src
if use_server("rust_analyzer") then
  lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- gem install solargraph
if use_server("solargraph") then
  lspconfig.solargraph.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = (function()
      if has_gem("solargraph") then
        return { "bundle", "exec", "solargraph", "stdio" }
      else
        return { "solargraph", "stdio" }
      end
    end)(),
    init_options = {
      formatting = false,
    },
    settings = {
      solargraph = {
        diagnostics = false,
      },
    },
  })
end

-- brew install sqls
if use_server("sqls") then
  lspconfig.sqls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- brew install lua-language-server
if use_server("sumneko_lua") then
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lspconfig.sumneko_lua.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          globals = { "vim" },
          disable = {
            -- The server isn't smart enough to know that if a module is
            -- required with `pcall` and we return when it isn't successful,
            -- then the module is not `nil` past that point.
            "need-check-nil",
          },
        },
        workspace = {
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.stdpath("config") .. "/lua",
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

-- yarn global add typescript-language-server
if use_server("tsserver") then
  lspconfig.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- yarn global add vscode-langservers-extracted
if use_server("eslint") then
  lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- brew install black flake8 prettier stylua
-- gem install rubocop
if use_server("null_ls") then
  local builtins = null_ls.builtins
  local diagnostics = builtins.diagnostics
  local formatting = builtins.formatting

  -- Prefer project-local versions of RuboCop
  local prefer_local_rubocop = function(kind)
    if machine_ok and machine.null_ls and machine.null_ls.rubocop then
      return machine.null_ls.rubocop(kind)
    elseif has_gem("rubocop") then
      return null_ls.builtins[kind].rubocop.with({
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins[kind].rubocop._opts.args),
      })
    else
      return null_ls.builtins[kind].rubocop
    end
  end

  null_ls.setup({
    sources = {
      -- Diagnostics
      diagnostics.flake8,
      prefer_local_rubocop("diagnostics"),

      -- Formatting
      formatting.black,
      formatting.prettier,
      formatting.stylua,
      prefer_local_rubocop("formatting"),
    },
    on_attach = on_attach,
  })
end
