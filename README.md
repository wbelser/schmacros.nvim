# Schmacros.Nvim

As much a macro organiser as it is a feeble attempt to play with `nvim` plugins and learn `lua`!

# Introduction

## My problem

Ok - I am fully aware that macros can easily be handled with a simple
entry into your `options.lua` file that looks like:

```lua
local macro_md_url = vim.api.nvim_replace_termcodes("0i[<Esc>A]()<Esc>", true, true, true)
vim.fn.setreg("l", macro_md_url)
```

My problem is that I create macros and cannot remember what registry I put it
in or sometimes even what the macro is/was supposed to do. I know - you can just do:

```vim
:reg
```

And see everything, but now I have to reread the line and decipher what it
is doing.

## A solution?

So I thought that is might be cool if I could define some macros with a description
and be able to also get a _cool_ cheat sheet of some kind as a reminder.

You know perhaps have:

```lua
{
    reg = "l",
    macro = "0i[<Esc>A]()<Esc>",
    desc = "Markdown link",
    ft = "markdown",    -- perhaps a filetype?
}
```

Then I could get a nice display that could look sometime like:

```output
l - Markdown link
```

And most importantly - Learn lua and how to create nvim plugins
