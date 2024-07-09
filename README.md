# lazygit.nvim

A [lazygit](https://github.com/jesseduffield/lazygit) integration into Neovim.

### Table of contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Plugin Configuration](#plugin-configuration)
- [Lazygit Configuration](#lazygit-configuration)
- [Default Mappings](#default-mappings)

## Requirements

- neovim 0.10
- lazygit 0.38
- [nvim-unception](https://github.com/samjwill/nvim-unception)

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
  { 'samjwill/nvim-unception', lazy = false --[[ important ]] },
  {
    'lostl1ght/lazygit.nvim',
    lazy = true,
    cmd = 'Lazygit',
    keys = { { '<leader>g', '<cmd>Lazygit<cr>', desc = 'Lazygit' } },
  },
}
```

The plugin sets up `$GIT_EDITOR` & `UnceptionEditRequestReceived` user autocommand
to hide lazygit window when performing an action in lazygit **with editor**. See more in `plugin/lazygit.lua`.
Set `vim.g.loaded_lazygit` to `true` before loading the plugin to disable.

## Usage

```lua
---@param path string?
---@param use_last boolean?
require('lazygit').open(path?, use_last?)
```

```vimdoc
:Lazygit[!] {path}    Open lazygit on {path}. Bang toggles "use_last".
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
