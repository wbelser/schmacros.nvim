local health = vim.health or require("health")

local M = {}

function M.check()
	health.start("schmacros.nvim health check")

	-- You can add any checks here:
	if vim.fn.has("nvim-0.9") == 1 then
		health.ok("Neovim version is OK")
	else
		health.warn("Neovim 0.9+ is recommended")
	end

	if vim.fn.exists("*setreg") == 1 then
		health.ok("setreg is available")
	else
		health.error("setreg function is missing - you need it to create macros")
	end
end

return M
