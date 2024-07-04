local M = {}

local cjson = require 'cjson.safe'

function EncodeMessage(message)
	local json_text, err = cjson.encode(message)
	if err then
		-- We are unable to properly format the message into json
		error(err)
		os.exit()
	end
	return string.format("Content-Length: %d\r\n\r\n%s", #json_text, json_text)
end

return M
