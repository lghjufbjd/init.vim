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
            enable = true,
            ignore = true,
            timeout = 500,
         },
         renderer = {
            highlight_git = true,
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
      "jose-elias-alvarez/null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "mason.nvim" },
      opts = function()
         local null_ls = require("null-ls")
         local formatting = null_ls.builtins.formatting
         local diagnostics = null_ls.builtins.diagnostics
         local code_actions = null_ls.builtins.code_actions
         local completion = null_ls.builtins.completion
         return {
            sources = {
               formatting.prettier.with {
                  filetypes = {
                     "javascript",
                     "javascriptreact",
                     "typescript",
                     "typescriptreact",
                  },
                  extra_args = function(params)
                     local file = params.bufname
                     local root = vim.fn.FindRootDirectory(file)
                     if root == "" then
                        return {
                           "--tab-width=" .. vim.bo.tabstop,
                           "--single-quote",
                           "--trailing-comma=all",
                           "--bracket-spacing=false",
                           "--jsx-bracket-same-line",
                           "--print-width=80",
                        }
                     end
                     return { "--config=" .. root .. "/.prettierrc" }
                  end,
               },
               diagnostics.tsc,
            },
         }
      end,
   },
   {
      'neovim/nvim-lspconfig',
      config = function()
         local format_is_enabled = true
         vim.api.nvim_create_user_command('KickstartFormatToggle', function()
            format_is_enabled = not format_is_enabled
            print('Setting autoformatting to: ' .. tostring(format_is_enabled))
         end, {})
         local _augroups = {}
         local get_augroup = function(client)
            if not _augroups[client.id] then
               local group_name = 'kickstart-lsp-format-' .. client.name
               local id = vim.api.nvim_create_augroup(group_name, { clear = true })
               _augroups[client.id] = id
            end

            return _augroups[client.id]
         end
         vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
            callback = function(args)
               local client_id = args.data.client_id
               local client = vim.lsp.get_client_by_id(client_id)
               local bufnr = args.buf
               if not client.server_capabilities.documentFormattingProvider then
                  return
               end
               if client.name == 'tsserver' then
                  return
               end
               vim.api.nvim_create_autocmd('BufWritePre', {
                  group = get_augroup(client),
                  buffer = bufnr,
                  callback = function()
                     if not format_is_enabled then
                        return
                     end
                     vim.lsp.buf.format {
                        async = false,
                        filter = function(c)
                           if c.id == nil then
                              return true
                           end
                           return c.id == client.id
                        end,
                     }
                  end,
               })
            end,
         })
      end,
   },
})
