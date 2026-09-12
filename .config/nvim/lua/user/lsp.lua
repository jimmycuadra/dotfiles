local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
if not blink_cmp_ok then
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
vim.lsp.log.set_level(vim.log.levels.OFF)

-- Adds the 'winhighlight' options nvim-cmp uses for documentation floating windows to
-- LSP floating windows created by the provided handler
local with_cmp_style_highlights = function(handler)
  return function(err, result, ctx, config)
    local _, winnr = handler(err, result, ctx, config)

    if winnr then
      vim.api.nvim_set_option_value(
        "winhighlight",
        "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
        { win = winnr }
      )
    end
  end
end

-- Use nvim-cmp style windows for LSP hover windows.
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return with_cmp_style_highlights(hover({
    border = "rounded",
    width = 60,
  }))
end

-- Use nvim-cmp style windows for LSP signature help windows.
local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return with_cmp_style_highlights(signature_help({
    border = "rounded",
    width = 60,
  }))
end

local map = vim.keymap.set

local opts = { silent = true }

-- Navigate diagnostics
map("n", "[g", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, opts)
map("n", "]g", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, opts)
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

local capabilities = blink_cmp.get_lsp_capabilities()

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
  vim.lsp.config("bashls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("bashls")
end

-- clangd should be present on macOS already, but `brew install llvm` will install it if not.
if use_server("clangd") then
  vim.lsp.config("clangd", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("clangd")
end

-- pnpm -g install vscode-langservers-extracted
if use_server("cssls") then
  vim.lsp.config("cssls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("cssls")
end

-- pnpm -g install dockerfile-language-server-nodejs
if use_server("dockerls") then
  vim.lsp.config("dockerls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("dockerls")
end

-- pnpm -g install vscode-langservers-extracted
if use_server("html") then
  vim.lsp.config("html", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("html")
end

-- pnpm -g install vscode-langservers-extracted
if use_server("jsonls") then
  vim.lsp.config("jsonls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("jsonls")
end

-- brew install pyright
if use_server("pyright") then
  vim.lsp.config("pyright", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("pyright")
end

-- brew install rust-analyzer
-- rustup component add rust-src
if use_server("rust_analyzer") then
  vim.lsp.config("rust_analyzer", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        check = {
          extraArgs = {
            "--target-dir=target/analyzer",
          },
        },
        diagnostics = {
          disabled = {
            "inactive-code",
          },
        },
        server = {
          extraEnv = {
            ["CARGO_TARGET_DIR"] = "target/analyzer",
          },
        },
      },
    },
  })

  vim.lsp.enable("rust_analyzer")
end

-- gem install ruby-lsp
if use_server("ruby_lsp") then
  vim.lsp.enable("ruby_lsp")
end

-- brew install sql-language-server
if use_server("sqlls") then
  vim.lsp.config("sqlls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("sqlls")
end

-- brew install lua-language-server
if use_server("lua_ls") then
  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  vim.lsp.config("lua_ls", {
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

  vim.lsp.enable("lua_ls")
end

-- pnpm -g install typescript-language-server
if use_server("ts_ls") then
  vim.lsp.config("ts_ls", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("ts_ls")
end

-- pnpm -g install vscode-langservers-extracted
if use_server("eslint") then
  vim.lsp.config("eslint", {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable("eslint")
end
