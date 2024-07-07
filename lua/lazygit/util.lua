local M = {}

M.get_root = function(path)
  return vim.fs.dirname(vim.fs.find('.git', {
    path = vim.fs.normalize(path),
    upward = true,
  })[1])
end

return M
