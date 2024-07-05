local M = {}

local rpc = require 'easy-lsp.rpc'

function M.GetMessage()
	local first_line = io.read()
	Log.info("Got a new message: ", first_line)
	local length = rpc.get_content_length(first_line)
	Log.info("Length of the message: ", length)
	local rest_message = io.read(length + 2)
	Log.info("Content of the message: ", rest_message)
	return rest_message
end

function M.SendMessage(message)
	io.write(message)
	io.flush()
end


return M
