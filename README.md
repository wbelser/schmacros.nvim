# Schmacros.Nvim

As much a macro organiser as it is a feeble attempt to play with
`nvim` plugins and learn `lua`!

# Introduction

## My problem

Ok - I am fully aware that macros can easily be handled with a simple
entry into your `options.lua` file that looks something like:

```lua
local macro_md_url = vim.api.nvim_replace_termcodes("0i[<Esc>A]()<Esc>", true, true, true)
vim.fn.setreg("l", macro_md_url)
```

My problem is that I create macros and cannot remember what registry
I put it in or sometimes even what the macro is/was supposed to
do. I know - you can just do:

```vim
:reg
```

And see everything, but now I have to reread the line and decipher what it
is doing.

## A solution?

And again, I know that there are other macro managers out there,
I am just trying to use this as a project to learn a little bit,
So I thought that is might be cool if I could define some macros
with a description and be able to also get a _cool_ cheat sheet of
some kind as a reminder.

You know perhaps have:

```lua
{
    reg = "l",
    macro = "0i[<Esc>A]()<Esc>",
    desc = "Markdown link",
    ft = "markdown",    -- perhaps a filetype later?
}
```

Then I could get a nice display that could look sometime like:

```output
l - Markdown link
```

And most importantly - Learn lua and how to create nvim plugins

# Configuration

So I use [https://github.com/folke/lazy.nvimi](lazy.nvim), and a
plugin file configuration should look something like this
and be placed where your `init.lua` file find it as
a plugin:

```lua
-- schmacros.nvim -  configuration
--
--
return {
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
	},
}

```

# Commands

So far I only have two commands but perhaps I will make some more. And
both of these commands need _tweeking_, they are not 100% the way they
should be or to my liking. So bear with me...

## Schmacros

This will display all of your managed and defined in the setup file _schmacros_.

```vim
:Schmacros
```

## SchmacroYank x

So, if you make a cool macro on the fly and want to keep it as a
managed _schmacro_, I wanted a way to grab about 85% of the correct
format and have it available to paste into my configuration file
(`schmacros.nvim`), so this is the function to do that.

You can always run:

```vim
:reg
```

To see what is going on in your registers. Find the register that
you want to copy or "yank". In this case let's say it is register
"j", and then call

```vim
:SchmacrosYank j
```

This will translate the macro to human readable text and place it
in the "+" register so that it can be 'pasted' into your config
file with these keys in `normal mode`: `"+p`
