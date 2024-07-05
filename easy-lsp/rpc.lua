local M = {}

local cjson = require 'cjson.safe'

function M.get_content_length(message)
	local _,_, b = string.find(message, "Content*-Length:%s*(%d+)")
	return tonumber(b)
end

function M.DecodeMessage(message)
	local start, finish = string.find(message, "\r\n\r\n")
	if not finish then
		return nil, "Error: did not find header separator"
	end
	local header = string.sub(message, 1, start - 1)
	local content_length, err = M.get_content_length(header)
	if err then
		return nil, "Error: Could not find Content-Length value"
	end
	local request = string.sub(message, finish + 1, finish + content_length)
	return cjson.decode(request)

end

function M.EncodeMessage(message)
	local json_text, err = cjson.encode(message)
	if err then
		-- We are unable to properly format the message into json
		error(err)
		os.exit()
	end
	return string.format("Content-Length: %d\r\n\r\n%s", #json_text, json_text)
end

-- Export private functions for testing
-- if _TEST then
-- 	M.get_content_length = get_content_length
-- end

return M
