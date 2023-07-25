local function callback(args)
  local path = args.args ~= '' and args.args or nil
  if args.bang then
    require('lazygit').open(path, false)
  else
    require('lazygit').open(path)
  end
end

vim.api.nvim_create_user_command('Lg', callback, { nargs = '?', desc = 'Lazygit', bang = true })
