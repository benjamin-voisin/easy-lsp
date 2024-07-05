local M = {}
local rpc = require('easy-lsp.rpc')




function M.start ()
	local log = io.open("./easy-lsp.log", "w")
	io.output(log)
	local first_line = io.read()
	local length = rpc.get_content_length(first_line)
	local rest_message = io.read(length + 2)
	io.write(rest_message)
	io.flush()
end

return M
