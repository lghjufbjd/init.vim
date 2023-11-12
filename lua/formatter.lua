return {
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
               if vim.fn.executable 'prettier' == 0 then
                  print('Prettier is not installed, Installing...')
                  vim.fn.system { 'npm', 'install', '-g', 'prettier' }
                  if vim.fn.executable 'prettier' == 0 then
                     print('Prettier installation failed, please install manually (npm install -g prettier)')
                     return
                  end
                  return
               end
               vim.api.nvim_create_autocmd("BufWritePre", {
                  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.json", "*.md" },
                  callback = function()
                     if not format_is_enabled then
                        return
                     end
                     local cmd = 'prettier'
                     local filepath = vim.fn.expand('%:p')
                     local prettierrc_path = vim.fn.expand('%:p:h') .. '/.prettierrc'

                     if vim.fn.filereadable(prettierrc_path) == 1 then
                        cmd = cmd .. ' --config ' .. prettierrc_path
                     else
                        local prettier_opt = {
                           tabstop = 'tab-width',
                        }
                        local vim_opt = { 'tabstop' }
                        for _, opt in ipairs(vim_opt) do
                           local prettier_opt_name = prettier_opt[opt] or opt
                           local value = vim.opt[opt]:get()
                           if value ~= nil then
                              if type(value) == "boolean" then
                                 value = value and 'true' or 'false'
                              end
                              cmd = cmd .. ' --' .. prettier_opt_name .. ' ' .. tostring(value)
                           end
                        end
                     end
                     vim.api.nvim_command('silent! write')
                     vim.fn.system(cmd .. ' --write ' .. filepath)
                     vim.api.nvim_command('silent! edit')
                     return true
                  end
               })
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
}
