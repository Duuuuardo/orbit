if vim.loader then
	vim.loader.enable()
end

_G.dd = function(...)
	require("util.debug").dump(...)
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")