-- Current directory Ack
vim.api.nvim_set_keymap('n', '<leader>f', ':Files<CR>', {})
-- Git repo global Ack
vim.api.nvim_set_keymap('n', '<leader>g', ':GFiles<CR>', {})
-- ,c to show hidden characters
vim.api.nvim_set_option_value('listchars', 'tab:>-,trail:·,eol:$', {})
vim.api.nvim_set_keymap('n', '<leader>c', ':set nolist!<CR>', {})
-- make Y behave like C and D
vim.api.nvim_set_keymap('n', 'Y', 'y$', {})

vim.api.nvim_create_user_command('Mkdir', function()
  local dir = vim.fn.expand('%:h')
  vim.fn.mkdir(dir, 'p')
end, {})

vim.api.nvim_create_user_command('RenameFile', function(opts)
  local curpath = vim.fn.expand('%:p')
  local curdir = vim.fn.expand('%:p:h')
  local newpath = curdir .. '/' .. opts.args
  vim.fn.rename(curpath, newpath)
  vim.cmd.edit(newpath)
end, { nargs = 1})


vim.api.nvim_create_user_command('Search', function(opts)
  local term = vim.fn.expand("<cword>")
  vim.cmd("Ack!", term)
end, {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.api.nvim_create_user_command('Definition', vim.lsp.buf.definition, {})
    vim.api.nvim_create_user_command('TypeDefinition', vim.lsp.buf.type_definition, {})
    vim.api.nvim_create_user_command('Rename', function(opts)
      vim.lsp.buf.rename(opts.args)
    end, { nargs = 1 })
    vim.api.nvim_create_user_command('Format', function()
      vim.lsp.buf.format({ async = true })
    end, {})
    vim.api.nvim_create_user_command('References', vim.lsp.buf.references, {})
    vim.api.nvim_create_user_command('Info', vim.lsp.buf.hover, {})
  end,
})

require('lualine').setup({
  sections = {
    lualine_c = {
      'lsp_progress'
    }
  }
})
