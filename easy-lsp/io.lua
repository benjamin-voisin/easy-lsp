local M = {}

local rpc = require 'easy-lsp.rpc'

function M.GetMessage()
	local first_line = io.read()
	if Log then
		Log.info("Got a new message !")
	end
	local length = rpc.get_content_length(first_line)
	local rest_message = io.read(length + 2)
	return rest_message
end

function M.SendMessage(message)
	io.write(message)
	io.flush()
end


return M
