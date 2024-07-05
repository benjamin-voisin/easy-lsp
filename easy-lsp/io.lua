local M = {}

local rpc = require 'easy-lsp.rpc'

function M.GetMessage()
	local first_line = io.read()
	local length = rpc.get_content_length(first_line)
	local rest_message = io.read(length + 2)
	io.write(rest_message)
	io.flush()
	return first_line..rest_message
end


return M
