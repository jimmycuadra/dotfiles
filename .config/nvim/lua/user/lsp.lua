local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  return
end
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_ok then
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
    -- Show the names of ESLint rules along with their messages
    format = function(diagnostic)
      if diagnostic.source == "eslint" then
        return string.format("%s [%s]", diagnostic.message, diagnostic.user_data.lsp.code)
      else
        return diagnostic.message
      end
    end,
  },
})

-- Comment this out if/when LSP debug logs are needed.
vim.lsp.set_log_level("off")

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

  -- Prefer formatting from conform.nvim
  if vim.tbl_contains({
    "ts_ls",
    "lua_ls",
    "html",
    "jsonls",
  }, client.name) then
    client.server_capabilities.documentFormattingProvider = false
  end

  map("n", "K", vim.lsp.buf.hover, buffer_opts)
  map("n", "<m-k>", vim.lsp.buf.signature_help, buffer_opts)

  map("n", "gd", vim.lsp.buf.definition, buffer_opts)
  map("n", "gD", vim.lsp.buf.declaration, buffer_opts)
  map("n", "gr", vim.lsp.buf.references, buffer_opts)
  map("n", "gy", vim.lsp.buf.type_definition, buffer_opts)
  map("n", "gi", vim.lsp.buf.implementation, buffer_opts)

  map("n", "<leader>c", vim.lsp.buf.code_action, buffer_opts)
  map("x", "<leader>c", vim.lsp.buf.code_action, buffer_opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, buffer_opts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Decide whether or not to enable a particular LSP server based on
-- machine-specific configuration that is not committed
local use_server = function(server)
  if machine_ok and machine.enable_lsp_server and machine.enable_lsp_server[server] then
    return machine.enable_lsp_server[server]()
  end

  return true
end

-- pnpm -g install bash-language-server
if use_server("bashls") then
  lspconfig.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- pnpm -g install vscode-langservers-extracted
if use_server("cssls") then
  lspconfig.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- pnpm -g install dockerfile-language-server-nodejs
if use_server("dockerls") then
  lspconfig.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- pnpm -g install vscode-langservers-extracted
if use_server("html") then
  lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- pnpm -g install vscode-langservers-extracted
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
      if require("user.ruby").has_gem("solargraph") then
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

-- brew install sql-language-server
if use_server("sqlls") then
  lspconfig.sqlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- brew install lua-language-server
if use_server("lua_ls") then
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  lspconfig.lua_ls.setup({
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

-- pnpm -g install typescript-language-server
if use_server("ts_ls") then
  lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- pnpm -g install vscode-langservers-extracted
if use_server("eslint") then
  lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
