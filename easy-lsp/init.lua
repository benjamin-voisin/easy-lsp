local M = {}

local rpc = require('easy-lsp.rpc')
local lsp_io = require('easy-lsp.io')
Log = require('easy-lsp.log')

Log.outfile = "/tmp/easy-lsp.log"

M.name = "easy-lsp"
M.version = "0.1.0"

M.HandleRequest = {}
M.HandleNotifications = {}

function M.HandleRequest.initialize (request)
	local response = {
		id = request.id,
		result = {
			capabilities = M.capabilities,
			serverInfo = {
				name = M.name,
				version = M.version,
			}
		}
	}
	local response_message = rpc.EncodeMessage(response)
	Log.info("Response: ", response_message)
	return response_message
end

function M.HandleRequest.default (request)
	local response = {
		id = request.id,
		error = {
			code = -32803,
			message = "This method has not been implemented in the LSP."
		}
	}
	local response_message = rpc.EncodeMessage(response)
	Log.info("Response: ", response_message)
	return response_message
end

function M.HandleRequest.shutdown (request)
	M.running = false
	local response = {
		id = request.id,
		result = {}
	}
	local response_message = rpc.EncodeMessage(response)
	Log.info("Response: ", response_message)
	return response_message
end

function M.HandleNotifications.exit ()
	if M.running then
		os.exit(1)
	else
		os.exit(0)
	end
end

function M.start ()
	M.running = true
	while true do
		local request = lsp_io.GetMessage()
		if not request then
			Log.error("We did not receive a proper message")
			error("Problème we did not receive a message")
		end
		local err
		request, err = rpc.DecodeJson(request)
		if err then
			error("Problème: Decoding didn't work properly: "..err)
		end
		Log.info("Méthode: ", request.method)
		if request.id then
			-- We are in a "request" situation
			if M.HandleRequest[request.method] then
				local response = M.HandleRequest[request.method](request)
				lsp_io.SendMessage(response)
			else
				Log.error("Method ", request.method, " not implemented")
				M.HandleRequest.default(request)
			end
		else
			if M.HandleNotifications[request.method] then
				M.HandleNotifications[request.method](request)
			end
		end
	end
end

return M
