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
	local lines = { "=== Macro List ===" }
	local max_width = #lines[1]

	for _, value in ipairs(M.options) do
		local line = string.format(" %s - %s", value.reg, value.desc)
		table.insert(lines, line)
		if #line > max_width then
			max_width = #line
		end
	end

	local height = #lines
	local width = max_width + 2

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local ui = vim.api.nvim_list_uis()[1]
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
end

function M.list()
	local message = "\n=== Macro List ===\n"
	for _, value in ipairs(M.options) do
		message = message .. string.format(" %s - %s\n", value.reg, value.desc)
	end
	vim.notify(message, vim.log.levels.INFO)
end

return M
