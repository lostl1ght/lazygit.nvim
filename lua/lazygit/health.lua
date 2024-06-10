local M = {}

M.check = function()
  vim.health.start('lazygit.nvim')
  if vim.fn.has('nvim-0.10.0') == 1 then
    vim.health.ok('Neovim version is >=0.10.0')
  else
    vim.health.error('lazygit.nvim requires neovim >=0.10.0')
  end
  if vim.fn.executable('lazygit') == 1 then
    vim.health.ok('Lazygit is installed')
    if vim.system then
      ---@type string
      local stdout = vim.system({ 'lazygit', '-v' }, { text = true }):wait().stdout
      local _ver = {}
      for num in
        string.gmatch(
          string.match(string.match(stdout, 'version=%d+%.%d+%.%d+'), '%d+%.%d+%.%d+'),
          '%d+'
        )
      do
        table.insert(_ver, tonumber(num))
      end
      local version = { major = _ver[1], minor = _ver[2], patch = _ver[3] }
      if version.major >= 0 and version.minor >= 38 and version.patch >= 0 then
        vim.health.ok(
          string.format('Lazygit version is %d.%d.%d', version.major, version.minor, version.patch)
        )
      else
        vim.health.error(
          string.format(
            'lazygit.nvim requires lazygit >=0.38.0 (%d.%d.%d detected)',
            version.major,
            version.minor,
            version.patch
          )
        )
      end
    end
  else
    vim.health.error('Lazygit is NOT installed')
  end
end

return M
