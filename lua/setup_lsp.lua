-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Disable hightlight
  client.server_capabilities.semanticTokensProvider = nil
end

vim.diagnostic.config({
  virtual_text = true,
})

local function installed(set, key)
  return set[key] ~= nil
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

vim.lsp.config('dartls', {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {}
  }
})
vim.lsp.config('gopls', {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config('clangd', {
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = { "c", "sc", "qsc", "h", "qsh", "cc", "cpp", "hxx" },
})
vim.lsp.config('verible', {
  on_attach = on_attach,
  flags = lsp_flags,
})
vim.lsp.config('ruff', {
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = { "python" },
})
vim.lsp.config('jedi_language_server', {
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = { "python" },
})

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  flags = lsp_flags,
  filetypes = { "lua" },
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- '${3rd}/luv/library'
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of jedi
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})
