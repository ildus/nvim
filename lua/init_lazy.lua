local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'ressu/vim-xdg-cache',
  -- 'ludovicchabant/vim-gutentags',
  'ntpeters/vim-better-whitespace',
  'plasticboy/vim-markdown',
  { 'psf/black', branch = 'main' },
  {
    'embear/vim-localvimrc',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'ojroques/nvim-osc52',
    init = function()
      function copy()
        if vim.v.event.operator == 'y' and vim.v.event.regname == '+' then
          require('osc52').copy_register('+')
        end
      end

      vim.api.nvim_create_autocmd('TextYankPost', {callback = copy})
    end
  },
  {
    'folke/which-key.nvim',
    init = function()
      require("setup_wk")
    end
  },
  {
    "dhananjaylatkar/cscope_maps.nvim",
    dependencies = {
      "folke/which-key.nvim", -- optional [for whichkey hints]
      "nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
    },
    opts = {
      skip_input_prompt = true,

      cscope = {
        picker = "telescope", -- "telescope", "fzf-lua" or "quickfix"
        -- "true" does not open picker for single result, just JUMP
        skip_picker_for_single_result = true,
      }
    },
  },
  {
  "dhananjaylatkar/vim-gutentags",
    dependencies = {
      "dhananjaylatkar/cscope_maps.nvim",
    },
    init = function()
      vim.g.gutentags_modules = {"cscope_maps"} -- This is required. Other config is optional
      vim.g.gutentags_cscope_build_inverted_index_maps = 1
      vim.g.gutentags_cache_dir = vim.fn.expand("~/code/.gutentags")
      vim.g.gutentags_file_list_command = "fd -u -e qsh -e sc -e qsc -e c -e cc -e cpp -e h -e hh -e hpp"
      -- vim.g.gutentags_trace = 1
    end,
  },
  'alok/notational-fzf-vim',
  'justinmk/vim-syntax-extra',
  {
    'junegunn/fzf.vim',
    dependencies = {
      {
        'junegunn/fzf',
        build = ':call fzf#install()',
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
      'nvim-telescope/telescope-ui-select.nvim',
    },
    init = function ()
      require('telescope').load_extension('fzf')
      require("telescope").load_extension("ui-select")
    end
  },
  {
    'neovim/nvim-lspconfig',
    init = function()
      require("setup_lsp")
    end
  }
})
