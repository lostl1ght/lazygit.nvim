local M = {
  bufnr = -1,
  jobid = -1,
  last_path = nil,
  visited_paths = {},
}

local api = vim.api

local actions = {
  hide = function()
    M.close_window()
  end,
}

function M.create_buffer()
  if M.bufnr == -1 then
    local bufnr = api.nvim_create_buf(true, true)
    M.bufnr = bufnr
    api.nvim_set_option_value('filetype', 'lazygit', { buf = bufnr })
    api.nvim_create_autocmd('TermLeave', {
      buffer = bufnr,
      callback = vim.schedule_wrap(function()
        ---@type integer
        ---@diagnostic disable-next-line
        local winid = vim.fn.bufwinid(bufnr)

        if api.nvim_win_is_valid(winid) then
          vim.defer_fn(function()
            api.nvim_win_set_cursor(winid, { 1, 0 })
          end, 20)
        end
      end),
    })
    api.nvim_create_autocmd('BufEnter', {
      buffer = bufnr,
      callback = function(args)
        vim.defer_fn(function()
          ---@type integer
          ---@diagnostic disable-next-line
          local winid = vim.fn.bufwinid(args.buf)
          api.nvim_win_set_cursor(winid, { 1, 0 })
          api.nvim_cmd({ cmd = 'startinsert' }, {})
        end, 20)
      end,
    })
    api.nvim_create_autocmd('BufWinEnter', {
      buffer = bufnr,
      callback = function(args)
        local win = vim.fn.bufwinid(args.buf)
        api.nvim_set_option_value('number', false, { scope = 'local', win = win })
        api.nvim_set_option_value('relativenumber', false, { scope = 'local', win = win })
      end,
    })
    local mappings = require('lazygit.config').mappings
    for mode, keys in pairs(mappings) do
      for key, action in pairs(keys) do
        local fun
        if type(action) == 'string' then
          fun = actions[action]
        else
          fun = action
        end
        api.nvim_buf_set_keymap(bufnr, mode, key, '', { callback = fun })
      end
    end
  end
end

function M.create_window()
  local winid = vim.fn.bufwinid(M.bufnr)
  if winid == -1 then
    api.nvim_cmd({ cmd = 'split', mods = { horizontal = true, split = 'belowright' } }, {})
    api.nvim_cmd({ cmd = 'wincmd', args = { 'J' } }, {})
    api.nvim_cmd({
      cmd = 'resize',
      args = { math.floor(vim.opt.lines:get() * require('lazygit.config').winscale) },
    }, {})
    ---@diagnostic disable-next-line
    api.nvim_win_set_buf(0, M.bufnr)
  else
    ---@diagnostic disable-next-line
    api.nvim_set_current_win(winid)
  end
end

function M.close_window()
  ---@type integer
  ---@diagnostic disable-next-line
  local winid = vim.fn.bufwinid(M.bufnr)
  if api.nvim_win_is_valid(winid) then
    api.nvim_win_close(winid, true)
  end
end

function M.start_job(path)
  local jobid = M.jobid
  if jobid == -1 then
    ---@diagnostic disable-next-line
    jobid = vim.fn.termopen('lazygit -p ' .. path, {
      on_exit = function()
        M.drop()
      end,
    })
    ---@diagnostic disable-next-line
    M.jobid = jobid
    M.last_path = path
    M.push_path(path)
  end
end

function M.drop()
  local bufnr = M.bufnr
  ---@type integer
  ---@diagnostic disable-next-line
  local winid = vim.fn.bufwinid(bufnr)
  M.close_window()
  if api.nvim_buf_is_loaded(bufnr) then
    api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
    api.nvim_buf_delete(bufnr, { force = true })
  end
  M.bufnr = -1
  M.jobid = -1
end

function M.push_path(path)
  local idx
  for i, v in ipairs(M.visited_paths) do
    if v == path then
      idx = i
      break
    end
  end
  if idx then
    table.remove(M.visited_paths, idx)
  end
  table.insert(M.visited_paths, 1, path)
end

function M.open(path)
  M.create_buffer()
  M.create_window()
  M.start_job(path)
end

return M
