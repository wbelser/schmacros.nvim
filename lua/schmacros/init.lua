local M = {}

-- Default config
M.options = {
	{
		reg = "l",
		macro = "0i[<Esc>A]()<Esc>",
		desc = "Markdown link",
		ft = "markdown", -- perhaps a filetype?
	},
}

-- Setup function that merges user options
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})

	for _, value in ipairs(M.options) do
		vim.fn.setreg(value.reg, vim.api.nvim_replace_termcodes(value.macro, true, true, true))
	end
end

-- floating macro list....
function M.show_macros_floating()
	local macro_lines = {}
	local max_width = 0

	-- Build the macro lines and track max width
	for _, value in ipairs(M.options) do
		local line = string.format(" %s - %s", value.reg, value.desc)
		table.insert(macro_lines, line)
		if #line > max_width then
			max_width = #line
		end
	end

	-- Centered and padded header
	local width = max_width + 4 -- some padding

	local header = "=== Macro List ==="
	local pad = math.max(0, math.floor((width - #header) / 2))
	local header_line = string.rep(" ", pad) .. header
	table.insert(macro_lines, 1, header_line)

	local height = #macro_lines

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, macro_lines)

	local ui = vim.api.nvim_list_uis()[1]
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	-- Keymaps to close the window
	vim.keymap.set("n", "q", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, silent = true })

	vim.keymap.set("n", "<Esc>", function()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end, { buffer = buf, nowait = true, silent = true })
end

-- Yank a macko into a human readable string
-- ready to be pasted into your config file.
--
function M.yank_macro(reg)
	if not reg or #reg ~= 1 then
		vim.notify("Please provide a single-letter register.", vim.log.levels.ERROR)
		return
	end

	local raw = vim.fn.getreg(reg)
	if raw == "" then
		vim.notify(string.format('Register "%s" is empty.', reg), vim.log.levels.WARN)
		return
	end

	-- Convert termcodes to key notation (like <Esc>)
	local readable = vim.fn.keytrans(raw)

	-- Format as Lua table snippet
	local formatted = string.format(
		[[
{
  reg = "%s",
  macro = "%s",
  desc = "Enter description here.",
}
]],
		reg,
		readable
	)

	-- Yank to system clipboard register "*"
	vim.fn.setreg("*", formatted)

	vim.notify("Macro yanked to system clipboard as Lua snippet.", vim.log.levels.INFO)
end

-- function M.list()
-- 	local message = "\n=== Macro List ===\n"
-- 	for _, value in ipairs(M.options) do
-- 		message = message .. string.format(" %s - %s\n", value.reg, value.desc)
-- 	end
-- 	vim.notify(message, vim.log.levels.INFO)
-- end
--

-- Setup user commands
vim.api.nvim_create_user_command("Schmacros", function()
	require("schmacros").show_macros_floating()
end, {
	desc = "Show macro list in a floating window",
})

vim.api.nvim_create_user_command("SchmacrosYank", function(opts)
	require("schmacros").yank_macro(opts.args)
end, {
	nargs = 1,
	complete = function()
		return {
			"a",
			"b",
			"c",
			"d",
			"e",
			"f",
			"g",
			"h",
			"i",
			"j",
			"k",
			"l",
			"m",
			"n",
			"o",
			"p",
			"q",
			"r",
			"s",
			"t",
			"u",
			"v",
			"w",
			"x",
			"y",
			"z",
		}
	end,
	desc = "Yank register macro as a Lua config snippet",
})

return M
