----------------------------
-------OPTIONS--------------
----------------------------
vim.opt.relativenumber=true
vim.opt.number=true
vim.opt.cursorline=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.wrap=false
vim.opt.hlsearch=false
vim.opt.history=2000
vim.opt.scrolloff=10
vim.opt.hidden=true
vim.opt.ttimeoutlen=150
vim.opt.sidescrolloff=10
vim.opt.sidescroll=6
vim.opt.startofline=true
vim.opt.linebreak=true
vim.opt.backup=true
vim.opt.colorcolumn='80'
--folding with treesitter:
vim.opt.foldmethod='expr'
vim.opt.foldexpr='nvim_treesitter#foldexpr()'
vim.opt.foldenable=false
vim.opt.foldnestmax=3
--tabs are 4 spaces
--TODO mischien vervangen met verschillende opties per taal
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
-- mapping related stuff
vim.g.mapleader = ' '
vim.g.NERDCreateDefaultMappings = 0

----------------------------
-------LAZY/PLUGINS---------
----------------------------
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

local plugins = {
    "ThePrimeagen/vim-be-good",
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
          local configs = require("nvim-treesitter.configs")
          configs.setup({
              -- folding zooi staat bij options
              sync_install = false,
              highlight = { enable = true },
              indent = { enable = true },
              ensure_installed = {"lua", "javascript", "python", "haskell", "c_sharp"},
            })
        end
    },
    { "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
    {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("nvim-tree").setup {}
      end,
    },
    {
        'nvim-telescope/telescope.nvim', branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'BurntSushi/ripgrep',
            'sharkdp/fd',
            'nvim-tree/nvim-web-devicons'
        }
    },
    {
        'mbbill/undotree'
    },
    'nvim-tree/nvim-web-devicons',
    {
        'preservim/nerdcommenter',
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
    },
    'nvim-lualine/lualine.nvim',
    {
        "NMAC427/guess-indent.nvim",
        config = function()
          require("guess-indent").setup {}
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim", 'BurntSushi/ripgrep',
            "folke/trouble.nvim", 'nvim-telescope/telescope.nvim'},
        opts = {
            highlight = { pattern = [[.*<(KEYWORDS)\s*]]},
            search = { pattern = [[\b(KEYWORDS)\b]] }
	    }
    },
    {
     "folke/trouble.nvim",
     dependencies = { "nvim-tree/nvim-web-devicons" },
     opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    { --TODO:
        'simrat39/symbols-outline.nvim',
        config = function()
          require("symbols-outline").setup()
        end,
    },
    {
        'karb94/neoscroll.nvim',
        config = function()
          require("neoscroll").setup()
        end,
    },
    {
       "m4xshen/hardtime.nvim",
       dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
       opts = {
            restriction_mode = "hint",
            disable_mouse = false,
        }
    },
    {'VonHeikemen/lsp-zero.nvim', branch = 'dev-v3'},
    --- Uncomment these if you want to manage LSP servers from neovim
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    -- LSP Support
    {
        'neovim/nvim-lspconfig',
        dependencies = {
          {'hrsh7th/cmp-nvim-lsp'},
        },
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
          {'L3MON4D3/LuaSnip'},
        }
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
      end,
      opts = {}
    },
}
require("lazy").setup(plugins)
----------------------------
-------LSP-ZERO-STUFF-------
----------------------------
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr, preserve_mappings = false})
end)

lsp.extend_cmp()

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here
  -- with the ones you want to install
  ensure_installed = {"lua_ls", "jedi_language_server"},
  handlers = {
    lsp.default_setup,
    lua_ls = function()
      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
    end,
  },
})
--TODO
--mason
    --LSP
    --DAP
    --linter
    --formatter
--autocomplete, coc
--snippets, ultisnips?
--peak definition 
--maybe add later stuff:
    --easy align maybe
    --telescope extensie -> zoek door text
    --better-escape als ik jj ga gebruiken voor esc
    --harpoon
    --kijken voor coole motions plugins
    --iets voor git -> git-conflicts.nvim
vim.cmd [[colorscheme nightfly]]
require('lualine').setup()
----------------------------
-------KEYMAPS--------------
----------------------------
-- leader key defined above under options
-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}
-- automatically reselect after indenting
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('n', '<leader>p', '"+p', opts)
vim.keymap.set('n', 'yp', '"0p', opts)

vim.keymap.set('n', '<leader>t', vim.cmd.NvimTreeToggle, opts)
vim.keymap.set('n', '<leader>o', 'o<Esc>', opts)
vim.keymap.set('n', '<leader>O', 'O<Esc>', opts)
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, opts)
vim.keymap.set('n', '<leader>g', builtin.git_files, opts)
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, opts)
vim.keymap.set({'n','v'}, '<leader>c', '<plug>NERDCommenterToggle', opts)
