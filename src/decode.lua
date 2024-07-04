--[[
	This file contains the functions usefull to decode messages sent to the LSP
	We need : A class for decoded message, a way to convert a string to this class.
	First, write the conversion function
]]
local M = {}

local cjson = require 'cjson.safe'


local function get_content_length(message)
	local _,_, b = string.find(message, "Content*-Length:%s*(%d+)")
	return tonumber(b)
end

function DecodeMessage(message)
	local start, finish = string.find(message, "\r\n\r\n")
	if not finish then
		return nil, "Error: did not find header separator"
	end
	local header = string.sub(message, 1, start - 1)
	local content_length, err = get_content_length(header)
	if err then
		return nil, "Error: Could not find Content-Length value"
	end
	local request = string.sub(message, finish + 1, finish + content_length)
	return cjson.decode(request)

end

-- Export private functions for testing
if _TEST then
	M.get_content_length = get_content_length
end

return M
