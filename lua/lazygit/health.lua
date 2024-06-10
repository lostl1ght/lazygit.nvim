local M = {}

M.check = function()
  vim.health.start('lazygit.nvim')
  if vim.fn.executable('lazygit') == 1 then
    vim.health.ok('Lazygit is installed')
  else
    vim.health.error('Lazygit is NOT installed')
  end
end

return M
