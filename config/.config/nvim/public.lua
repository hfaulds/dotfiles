vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.api.nvim_create_user_command('Definition', vim.lsp.buf.definition, {})
    vim.api.nvim_create_user_command('TypeDefinition', vim.lsp.buf.type_definition, {})
    vim.api.nvim_create_user_command('Rename', function(opts)
      vim.lsp.buf.rename(opts.args)
    end, { nargs = 1 })
    vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, {})
    vim.api.nvim_create_user_command('References', vim.lsp.buf.references, {})
    vim.api.nvim_create_user_command('Info', vim.lsp.buf.hover, {})
  end,
})
