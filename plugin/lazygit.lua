if vim.g.loaded_lazygit then
  return
end

vim.api.nvim_create_user_command('Lg', function(args)
  local path = args.args ~= '' and args.args or nil
  require('lazygit').open(path, not args.bang)
end, { nargs = '?', desc = 'Lazygit', bang = true })

vim.env['GIT_EDITOR'] = [[nvim --cmd 'let g:unception_block_while_host_edits=1']]
vim.api.nvim_create_autocmd('User', {
  pattern = 'UnceptionEditRequestReceived',
  callback = function()
    require('lazygit').hide()
  end,
})

vim.g.loaded_lazygit = true
