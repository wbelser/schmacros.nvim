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

	-- set the highlighted group
	vim.api.nvim_set_hl(0, "SchmacrosHeader", {
		reverse = true,
		bold = true,
	})
end

function M.show_macros_floating()
	local all_letters = {}
	for i = string.byte("a"), string.byte("z") do
		table.insert(all_letters, string.char(i))
	end

	local used_set = {}
	for _, v in ipairs(M.options) do
		used_set[v.reg] = true
	end

	local available = {}
	for _, letter in ipairs(all_letters) do
		if not used_set[letter] then
			table.insert(available, letter)
		end
	end

	local available_rows = {}
	local row = {}
	for i, letter in ipairs(available) do
		table.insert(row, letter)
		if #row == 7 or i == #available then
			table.insert(available_rows, table.concat(row, "  "))
			row = {}
		end
	end

	local lines = {}

	table.insert(lines, "Available slots:")
	if #available_rows > 0 then
		for _, r in ipairs(available_rows) do
			table.insert(lines, "  " .. r)
		end
	else
		table.insert(lines, "  (none available)")
	end

	table.insert(lines, "")

	table.insert(lines, "In use:")
	if #M.options > 0 then
		for _, v in ipairs(M.options) do
			table.insert(lines, string.format("  %s - %s", v.reg, v.desc))
		end
	else
		table.insert(lines, "  (none configured)")
	end

	local max_width = 0
	for _, line in ipairs(lines) do
		if #line > max_width then
			max_width = #line
		end
	end

	local header = " available schmacros "
	local width = max_width + 4
	local pad_total = width - #header
	local pad_left = math.floor(pad_total / 2)
	local pad_right = pad_total - pad_left
	local header_line = string.rep(" ", pad_left) .. header .. string.rep(" ", pad_right)
	local separator = string.rep("─", width)

	local macro_lines = { header_line, separator }
	for _, line in ipairs(lines) do
		table.insert(macro_lines, line)
	end

	local height = #macro_lines
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, macro_lines)

	local ui = vim.api.nvim_list_uis()[1]
	local row_win = math.floor((ui.height - height) / 2)
	local col_win = math.floor((ui.width - width) / 2)

	vim.api.nvim_buf_add_highlight(buf, -1, "SchmacrosHeader", 0, 0, -1)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row_win,
		col = col_win,
		style = "minimal",
		border = "rounded",
	})

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
