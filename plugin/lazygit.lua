if vim.g.loaded_lazygit then
  return
end

vim.api.nvim_create_user_command('Lg', function(args)
  local path = args.args ~= '' and args.args or nil
  require('lazygit').open(path, not args.bang)
end, { nargs = '?', desc = 'Lazygit', bang = true })

vim.g.loaded_lazygit = true
