-- Plugin configurations and setups
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
   }
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
   'tpope/vim-fugitive',
   'tpope/vim-rhubarb',
   'tpope/vim-sleuth',
   {
      'neovim/nvim-lspconfig',
      dependencies = {
         'williamboman/mason.nvim',
         'williamboman/mason-lspconfig.nvim',
         { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
         'folke/neodev.nvim',
      },
   },
   {
      'hrsh7th/nvim-cmp',
      dependencies = {
         'L3MON4D3/LuaSnip',
         'saadparwaiz1/cmp_luasnip',
         'hrsh7th/cmp-nvim-lsp',
         'rafamadriz/friendly-snippets',
      },
   },
   { 'folke/which-key.nvim',  opts = {} },
   {
      'lewis6991/gitsigns.nvim',
      opts = {
         signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
         },
         on_attach = function(bufnr)
            vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk,
               { buffer = bufnr, desc = 'Preview git hunk' })
            local gs = package.loaded.gitsigns
            vim.keymap.set({ 'n', 'v' }, ']c', function()
               if vim.wo.diff then
                  return ']c'
               end
               vim.schedule(function()
                  gs.next_hunk()
               end)
               return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
            vim.keymap.set({ 'n', 'v' }, '[c', function()
               if vim.wo.diff then
                  return '[c'
               end
               vim.schedule(function()
                  gs.prev_hunk()
               end)
               return '<Ignore>'
            end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
         end,
      },
   },
   {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      config = function()
         require('catppuccin').setup {
            flavour = "mocha",
            background = {
               light = "latte",
               dark = "mocha",
            },
            transparent_background = false,
            show_end_of_buffer = false,
            term_colors = false,
            dim_inactive = {
               enabled = false,
               shade = "dark",
               percentage = 0.15,
            },
            no_italic = false,
            no_bold = false,
            no_underline = false,
            styles = {
               comments = { "italic" },
               conditionals = { "italic" },
               loops = {},
               functions = {},
               keywords = {},
               strings = {},
               variables = {},
               numbers = {},
               booleans = {},
               properties = {},
               types = {},
               operators = {},
            },
            color_overrides = {},
            custom_highlights = {},
            integrations = {
               cmp = true,
               gitsigns = true,
               nvimtree = true,
               treesitter = true,
               notify = false,
               mini = {
                  enabled = true,
                  indentscope_color = "",
               },
            },
         }
         vim.cmd('colorscheme catppuccin')
      end,
   },
   {
      'nvim-lualine/lualine.nvim',
      opts = {
         options = {
            icons_enabled = false,
            theme = 'catppuccin',
            component_separators = '|',
            section_separators = '',
         },
      },
   },
   { 'numToStr/Comment.nvim', opts = {} },
   {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
         'nvim-lua/plenary.nvim',
         "nvim-tree/nvim-web-devicons",
         {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            cond = function()
               return vim.fn.executable 'make' == 1
            end,
         },
      },
   },
   {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
         'nvim-treesitter/nvim-treesitter-textobjects',
      },
      build = ':TSUpdate',
   },
   {
      "windwp/nvim-autopairs",
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
         require("nvim-autopairs").setup {}
         local cmp_autopairs = require('nvim-autopairs.completion.cmp')
         local cmp = require('cmp')
         cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
         )
      end,
   },
   {
      "kyazdani42/nvim-tree.lua",
      opts = {
         update_cwd = true,
         view = {
            adaptive_size = true,
            side = "right",
         },
         diagnostics = {
            enable = true,
            icons = {
               hint = "? ",
               info = "i ",
               warning = "w ",
               error = "e ",
            },
         },
         update_focused_file = {
            enable = true,
            update_cwd = true,
         },
         git = {
            enable = false,
            ignore = true,
            timeout = 500,
         },
         renderer = {
            icons = {
               default = " ",
               symlink = " ",
            },
            highlight_opened_files = "all",
            indent_markers = {
               enable = false,
               icons = {
                  corner = "└ ",
                  edge = "│ ",
                  none = "  ",
               },
            },
         },
         actions = {
            change_dir = {
               enable = false,
            },
            open_file = {
               quit_on_open = true,
            },
         },
      },
   },
   {
      "github/copilot.vim",
      branch = "release",
      version = "*",
      config = function()
      end,
   },
   {
      "mbbill/undotree",
      version = "*",
      config = function()
      end,
   },
   {
      "NvChad/nvim-colorizer.lua",
      opts = {
         filetypes = { "*" },
         user_default_options = {
            rgb_fn = true,
            hsl_fn = true,
            css = true,
            css_fn = true,
            mode = "background",
            tailwind = true,
            sass = { enable = true, parsers = { "css" } },
            virtualtext = "■",
         },
         buftypes = {},
      },
   },
   {
      "leafOfTree/vim-matchtag",
      config = function()
         vim.g.vim_matchtag_enable_by_default = 1
         vim.g.vim_matchtag_files = "*.astro,*.html,*.xml,*.js,*.jsx,*.vue,*.svelte,*.jsp,*.tsx"
         vim.g.vim_matchtag_highlight_cursor_on = 1
      end,
   },
   {
      "christoomey/vim-tmux-navigator",
      config = function()
         vim.g.tmux_navigator_no_mappings = 1
      end,
   },
   require("formatter")
   , {}
})
