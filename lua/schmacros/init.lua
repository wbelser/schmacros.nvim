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
end

function M.list()
	local message = "=== Macro List ===\n"
	for _, value in ipairs(M.options) do
		message = message .. string.format(" %s - %s\n", value.reg, value.desc)
	end
	vim.notify(message, vim.log.levels.INFO)
end

return M
