# Schmacros.Nvim

A lightweight Neovim plugin (Lua) for organizing letter-register macros (a–z).
Configure your macros with a name and description, then pull up a cheat sheet
anytime to see what's available and what's in use.

## Features

- **Define macros** with a register letter, key-sequence, and a human-readable description
- **`:Schmacros`** — Opens a centered floating window showing which letters are free
  and which are already configured, all in one view
- **`:SchmacrosYank {reg}`** — Yank an existing register's contents as a formatted
  Lua config snippet, ready to paste into your lazy.nvim `opts`
- **No extra keymaps or autocommands** — the plugin stays out of your way until you
  explicitly call a command

## Requirements

- Neovim 0.7+ (uses `nvim_create_user_command`, `nvim_open_win`, `nvim_replace_termcodes`)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "wbelser/schmacros.nvim",
  opts = {
    {
      reg = "l",
      macro = "0i[<Esc>A]()<Esc>",
      desc = "Markdown link",
    },
    {
      reg = "q",
      macro = 'yi"<esc>pa"',
      desc = 'Quote (") visual',
    },
  },
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "wbelser/schmacros.nvim",
  config = function()
    require("schmacros").setup({
      {
        reg = "l",
        macro = "0i[<Esc>A]()<Esc>",
        desc = "Markdown link",
      },
    })
  end,
}
```

Using Neovim 0.12+ built-in package management (`vim.pack`):

```lua
vim.pack.add({
  "https://github.com/wbelser/schmacros.nvim",
  config = function()
    require("schmacros").setup({
      {
        reg = "l",
        macro = "0i[<Esc>A]()<Esc>",
        desc = "Markdown link",
      },
    })
  end,
})
```

## Configuration

Pass a list of macro entries to `setup()` or lazy.nvim's `opts`. Each entry is a
table with these fields:

| Field   | Type     | Required | Description                                    |
|---------|----------|----------|------------------------------------------------|
| `reg`   | `string` | Yes      | Single letter a–z                              |
| `macro` | `string` | Yes      | Key-notation string (e.g. `0i[<Esc>A]()<Esc>`) |
| `desc`  | `string` | Yes      | Human-readable label shown in `:Schmacros`      |
| `ft`    | `string` | No       | Filetype filter (reserved, not yet implemented)  |

On `setup()`, each macro's key-sequence is expanded with `nvim_replace_termcodes`
and written into the corresponding Neovim register via `setreg()`.

## Commands

### `:Schmacros`

Opens a centered floating window with a rounded border showing two sections:

- **Available slots** — Letters a–z that are not yet configured, displayed in a
  compact grid (rows of 7). When all 26 registers are used, shows `(none available)`.
- **In use** — Each configured register with its description, same format as
  the original display. When no macros are configured, shows `(none configured)`.

Close the window with `q` or `<Esc>`.

### `:SchmacrosYank {reg}`

Reads the raw contents of a Neovim register (`{reg}`), converts it to key notation
with `keytrans()`, and yanks a ready-to-use Lua config snippet to the `"*` register
(system clipboard / PRIMARY selection). Supports tab-completion on a–z.

Example workflow:

1. Record a macro on-the-fly with `qa...q`
2. Run `:SchmacrosYank a`
3. Paste (`p` in normal mode) the snippet into your config
4. Restart or re-source to make it managed

## Architecture

All logic lives in a single module: `lua/schmacros/init.lua`.

- **`M.options`** — The canonical macro list (populated during `setup()`). Each
  entry is written to its register with `setreg()` at startup.
- **`M.show_macros_floating()`** — Computes available slots (set difference of
  a–z minus configured registers), builds the two-section display lines, and
  opens a centered `minimal`-style floating window with a rounded border.
  Buffer-local keymaps (`q`, `<Esc>`) close the window.
- **`M.yank_macro(reg)`** — Reads `getreg(reg)`, converts to key notation with
  `keytrans()`, wraps the result in a Lua table literal, and yanks to `"*`.

The header line uses the `SchmacrosHeader` highlight group (reversed + bold),
set during `setup()`.

## License

GPL-3.0 license
