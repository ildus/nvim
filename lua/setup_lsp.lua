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

--vim.lsp.enable('dartls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('gopls')

vim.filetype.add({
  extension = {
    sc = "c",    -- Map .sc files to C
    qsc = "c",   -- Map .qsc files to C
    qsh = "c",
    h = "c",
    hxx = "cpp",
    cc = "cpp",
  },
})

vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm"
  },
  on_attach = on_attach,
  flags = lsp_flags,
  root_markers = { 'compile_commands.json', ".git" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})
vim.lsp.enable('clangd')
vim.lsp.config("grph", {
  cmd = { "grph", "serve", "--lsp" },
  filetypes = { "c", "cpp", "python", "rust", "go", "javascript", "typescript", "typescriptreact" },
  root_markers = { ".grph", ".git" },
})

vim.lsp.enable('ruff')
vim.lsp.enable('ty')
vim.lsp.enable('grph')

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
vim.lsp.enable('lua_ls')

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_highlight', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    client.server_capabilities.semanticTokensProvider = nil
    --if client.name == 'ruff' then
      -- Disable hover in favor of jedi
      --client.server_capabilities.hoverProvider = false
    --end
  end,
  desc = 'LSP: Disable highlight',
})
