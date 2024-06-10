local M = {}

M.check = function()
  vim.health.start('lazygit.nvim')
  if vim.fn.has('nvim-0.10') == 1 then
    vim.health.ok('Neovim version is >=0.10')
  else
    vim.health.error('lazygit.nvim requires neovim >=0.10')
  end
  if vim.fn.executable('lazygit') == 1 then
    vim.health.ok('Lazygit is installed')
  else
    vim.health.error('Lazygit is NOT installed')
  end
end

return M
