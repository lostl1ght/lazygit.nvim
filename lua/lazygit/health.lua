local M = {}

function M.check()
  vim.health.start('lazygit.nvim')
  if vim.fn.has('nvim-0.10.0') == 1 then
    local version = vim.version()
    vim.health.ok(('{neovim} version `%d.%d.%d`'):format(version.major, version.minor, version.patch))
  else
    vim.health.error('lazygit.nvim requires neovim >=0.10.0')
  end
  if vim.fn.executable('lazygit') == 1 then
    local function get_version()
      local cmd = { 'lazygit', '-v' }
      if vim.system then
        return vim.system(cmd, { text = true }):wait().stdout
      else
        return vim.fn.system(cmd)
      end
    end
    local stdout = get_version()
    local major, minor, patch = stdout:match('version=(%d+)%.?(%d*)%.?(%d*)')
    local version = { major = tonumber(major), minor = tonumber(minor), patch = tonumber(patch) }
    if version.major > 0 or version.minor >= 38 then
      vim.health.ok(
        ('{lazygit} version `%d.%d.%d`'):format(version.major, version.minor, version.patch)
      )
    else
      vim.health.error(
        ('*lazygit.nvim* requires {lazygit} version `0.38.0` (`%d.%d.%d` detected)'):format(
          version.major,
          version.minor,
          version.patch
        )
      )
    end
  else
    vim.health.error('Lazygit is NOT installed')
  end
end

return M
