# lazygit.nvim

A [lazygit](https://github.com/jesseduffield/lazygit) integration into Neovim.

### Table of contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Plugin Configuration](#plugin-configuration)
- [Lazygit Configuration](#lazygit-configuration)
- [Default Mappings](#default-mappings)

## Requirements

- Neovim >=0.10
- [Lazygit](https://github.com/jesseduffield/lazygit) >=0.38
- [nvim-unception](https://github.com/samjwill/nvim-unception)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  'lostl1ght/lazygit.nvim',
  lazy = true, -- optional
  cmd = 'Lg',
  keys = {
    {
      '<leader>g',
      function()
        require('lazygit').open()
      end,
      desc = 'Lazygit',
    },
  },
  dependencies = {
    'samjwill/nvim-unception',
    lazy = false, -- important!
    config = function()
      vim.env['GIT_EDITOR'] = "nvim --cmd 'let g:unception_block_while_host_edits=1'"
    end,
  },
  config = function()
    require('lazygit').setup({}) -- optional
  end
}
```

Calling `setup` is optional.

## Plugin Configuration

Default `setup` values:

```lua
{
  winscale = 0.75,
  mappings = {
    t = {
      ['<c-q>'] = 'hide',
    },
    n = {
      ['<c-q>'] = 'hide',
    },
  },
}
```

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
