---@class LazyGitConfig
---@field winscale number
---@field mappings table

local M = {
  options = {
    winscale = 0.85,
    mappings = {
      t = {
        ['<c-q>'] = 'hide', -- matches 'quit' lazygit mapping
      },
      n = {
        ['<c-q>'] = 'hide', -- matches 'quit' lazygit mapping
      },
    },
  },
}

local predef = {
  'hide',
}

---@param opts LazyGitConfig
M.setup = function(opts)
  vim.validate({
    winscale = {
      opts.winscale,
      function(v) return v == nil or v > 0 and v <= 1 end,
      'value between 0 and 1',
    },
  })
  if opts.mappings ~= nil then
    for mode, keys in pairs(opts.mappings) do
      vim.validate({
        mode = {
          mode,
          function(v) return v == 't' or v == 'n' end,
          'only "normal" or "terminal" modes accepted',
        },
      })
      for lhs, rhs in pairs(keys) do
        vim.validate({
          lhs = { lhs, 'string' },
          rhs = {
            rhs,
            function(v)
              if type(v) == 'string' then
                return vim.tbl_contains(predef, v)
              else
                return type(v) == 'function'
              end
            end,
            'invalid action',
          },
        })
      end
    end
  end
  M.options = vim.tbl_deep_extend('force', M.options, opts or {})
end

setmetatable(M, {
  __index = function(self, key)
    if key ~= 'setup' then return self.options[key] end
  end,
})

return M
