local M = {}

local uv = vim.uv or vim.loop

function M.open(path, use_last)
  local UI = require('lazygit.ui')
  local UTIL = require('lazygit.util')
  local gitdir = UTIL.get_root(
    path
      or use_last ~= false and UI.last_path
      or uv.cwd()
  )
  if not gitdir then
    vim.notify('not a git repo', vim.log.levels.ERROR, { title = 'Lazygit' })
    return
  end
  if gitdir ~= UI.last_path then
    UI.drop()
    vim.wait(25, function()
      return false
    end)
  end
  UI.open(gitdir)
end

---@param opts LazyGitConfig
function M.setup(opts)
  require('lazygit.config').setup(opts)
end

return M
