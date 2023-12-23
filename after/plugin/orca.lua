local orca = require("orca")

vim.api.nvim_create_user_command("OrcaStart", function()
	orca.start()
end, {})
vim.api.nvim_create_user_command("OrcaStop", function()
	orca.stop()
end, {})
