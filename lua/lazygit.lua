local M = {}

local uv = vim.uv or vim.loop

---@param path string?
---@param use_last boolean?
M.open = function(path, use_last)
  local UI = require('lazygit.ui')
  local UTIL = require('lazygit.util')
  local gitdir = UTIL.get_root(path or use_last ~= false and UI.last_path or uv.cwd())
  if not gitdir then
    vim.notify('must be run inside a git repository', vim.log.levels.ERROR, { title = 'Lazygit' })
    return
  end
  if gitdir ~= UI.last_path then
    UI.drop()
    vim.wait(25, function() return false end)
  end
  UI.open(gitdir)
end

---@param opts LazyGitConfig
M.setup = function(opts) require('lazygit.config').setup(opts) end

M.hide = function() require('lazygit.ui').close_window() end

M.show = function() require('lazygit.ui').create_window() end

return M
