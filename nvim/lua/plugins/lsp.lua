local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = false })
  end

  nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>a', vim.lsp.buf.code_action, 'Code action')
  nmap('gd', vim.lsp.buf.definition, 'Goto definition')
  nmap('gD', vim.lsp.buf.declaration, 'Goto declaration')
  nmap('gr', vim.lsp.buf.references, 'Goto references')
  nmap('gI', vim.lsp.buf.implementation, 'Goto implementation')
  nmap('gh', vim.lsp.buf.hover, 'Hover')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  if client.server_capabilities.documentFormattingProvider then
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    -- auto format on save
    -- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lsp = require('lspconfig')
      lsp["gopls"].setup {
        on_attach = on_attach,
        root_dir = lsp.util.root_pattern('.git', 'src/go.mod', 'go.mod'),
        settings = {
          gopls = {
            gofumpt = true
          }
        }
      }
      lsp["biome"].setup {
        on_attach = on_attach,
      }
      lsp["lua_ls"].setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
      }
      -- Not working...
      -- lsp["pyright"].setup{}
      -- lsp["pylsp"].setup {
      --   filetypes = { 'py' }
      -- }

      -- Auto format go imports, source:
      -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          -- buf_request_sync defaults to a 1000ms timeout. Depending on your
          -- machine and codebase, you may want longer. Add an additional
          -- argument after params if you find that you have to write the file
          -- twice for changes to be saved.
          -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    config = function()
      local lsp = require("lspconfig")
      require("typescript").setup({
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = false,            -- enable debug logging for commands
        go_to_source_definition = {
          fallback = true,        -- fall back to standard LSP definition on failure
        },
        server = {                -- pass options to lspconfig's setup method
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false

            on_attach(client, bufnr)
          end,
          root_dir = lsp.util.root_pattern("package.json"),
          single_file_support = false,
        },
      })
    end
  }
}
