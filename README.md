# lazygit.nvim

A [lazygit](https://github.com/jesseduffield/lazygit) integration into Neovim.

### Table of contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Preventing nesting](#preventing-nesting)
- [Plugin Configuration](#plugin-configuration)
- [Lazygit Configuration](#lazygit-configuration)
- [Default Mappings](#default-mappings)

## Requirements

- neovim 0.10
- lazygit 0.38
- [flatten.nvim](https://github.com/willothy/flatten.nvim) (optional)
- [nvim-unception](https://github.com/samjwill/nvim-unception) (optional)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  'lostl1ght/lazygit.nvim',
  lazy = true,
  cmd = 'Lazygit',
  keys = { { '<leader>g', '<cmd>Lazygit<cr>', desc = 'Lazygit' } },
}
```

## Usage

```lua
---@param path string?
---@param use_last boolean?
require('lazygit').open(path?, use_last?)
```

```vimdoc
:Lazygit[!] {path}    Open lazygit on {path}. Bang toggles "use_last".
```

## Preventing nesting

With [flatten.nvim](https://github.com/willothy/flatten.nvim):

```lua
require('flatten').setup({
  callbacks = {
    pre_open = function() require('lazygit').hide() end,
    post_open = function(bufnr, _, ft, _)
      if ft == 'gitcommit' or ft == 'gitrebase' then
        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          once = true,
          callback = vim.schedule_wrap(function() vim.api.nvim_buf_delete(bufnr, {}) end),
        })
      end
    end,
    block_end = vim.schedule_wrap(function() require('lazygit').show() end),
  },
  window = {
    open = 'alternate',
  },
})
```

With [nvim-unception](https://github.com/samjwill/nvim-unception):

```lua
vim.env['GIT_EDITOR'] = [[nvim --cmd 'let g:unception_block_while_host_edits=1']]
vim.api.nvim_create_autocmd('User', {
  pattern = 'UnceptionEditRequestReceived',
  callback = function() require('lazygit').hide() end,
})
```

## Plugin Configuration

Configure the plugin by calling `require('lazygit').setup()`.

Default `setup` values:

```lua
{
  winscale = 0.85,
  mappings = {
    t = {
      ['q'] = 'hide', -- matches 'quit' lazygit mapping
    },
    n = {
      ['q'] = 'hide', -- matches 'quit' lazygit mapping
    },
  },
}
```

Set mapping's action to false to disable.

### Adding a custom mapping

An action can be a function. This function accepts 1 argument which is a buffer number.

```lua
function(bufnr)
  print('Lazygit bufnr is' .. bufnr)
end
```

## Lazygit Configuration

```yaml
os:
  editPreset: 'nvim'
promptToReturnFromSubprocess: false
```

## Default Mappings

| Mappings | Action              | Configuration option |
|----------|---------------------|----------------------|
| `<c-q>`  | Hide Lazygit window | `hide`               |
