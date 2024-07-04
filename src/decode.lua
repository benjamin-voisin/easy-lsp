--[[
	This file contains the functions usefull to decode messages sent to the LSP
	We need : A class for decoded message, a way to convert a string to this class.
	First, write the conversion function
]]
local M = {}


local function get_content_length(message)
	local _,_, b = string.find(message, "Content*-Length:%s*(%d+)")
	return tonumber(b)
end

function decode (message)
	local content_length = get_content_length(message)
	if not content_length then
		return nil, "Mal-formed request: There is no Content-Lenth field"
	end
	local start, finish = string.find(message, "\r\n\r\n")
	local header = string.sub(message, 1, start)
	local request = string.sub(message, finish, content_length)
	return header, request
end

-- Export private functions for testing
if _TEST then
	M.get_content_length = get_content_length
end

return M
