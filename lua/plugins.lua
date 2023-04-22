local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'ressu/vim-xdg-cache'
  use 'ludovicchabant/vim-gutentags'
  use 'plasticboy/vim-markdown'
  use 'ntpeters/vim-better-whitespace'

  use 'neovim/nvim-lspconfig'
  use { 'psf/black', branch = 'main' }

  use 'nvim-lua/plenary.nvim'
  use {
    'embear/vim-localvimrc',
    requires = { 'nvim-lua/plenary.nvim' }
  }

  use 'folke/which-key.nvim'
  use {
    'ildus/cscope_maps.nvim',
    requires = { 'folke/which-key.nvim' }
  }
  use 'alok/notational-fzf-vim'
  use 'justinmk/vim-syntax-extra'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    tag = '0.1.1'
  }

  local fzf_plugin = 'nvim-telescope/telescope-fzf-native.nvim'
  use {
    fzf_plugin,
    requires = { 'nvim-telescope/telescope.nvim' },
    run = 'make'
  }

  local ui_plugin = 'nvim-telescope/telescope-ui-select.nvim'
  use {
    ui_plugin,
    requires = { 'nvim-telescope/telescope.nvim' },
  }

  require('telescope').load_extension('fzf')
  require("telescope").load_extension("ui-select")
  require('setup_lsp')
  require("cscope_maps").setup({})

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
