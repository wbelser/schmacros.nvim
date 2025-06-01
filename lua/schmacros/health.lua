local health = vim.health or require("health")

local M = {}

function M.check()
	health.report_start("schmacros.nvim health check")
	-- TODO implement a real health check
	-- for now - just say hi...
	health.report_ok("Plugin is installed correctly")
end

return M
