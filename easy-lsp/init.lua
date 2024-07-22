local M = {}

local rpc = require('easy-lsp.rpc')
local lsp_io = require('easy-lsp.io')
Log = require('easy-lsp.log')

Log.outfile = "/tmp/easy-lsp.log"

M.name = "easy-lsp"
M.version = "0.1.0"

M.HandleRequest = {}
M.HandleNotifications = {}
M.FileContent = {}

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
	return response
end

function M.HandleRequest.default (request)
	local response = {
		id = request.id,
		error = {
			code = -32803,
			message = "This method has not been implemented in the LSP."
		}
	}
	return response
end

function M.HandleRequest.shutdown (request)
	M.running = false
	local response = {
		id = request.id,
		result = {}
	}
	return response
end

function M.HandleNotifications.exit ()
	if M.running then
		os.exit(1)
	else
		os.exit(0)
	end
end

M.HandleNotifications["textDocument/didOpen"] = function (notification)
	M.FileContent[notification.params.textDocument.uri] = notification.params.textDocument.text
end

M.HandleNotifications["textDocument/didChange"] = function (notification)
	M.FileContent[notification.params.textDocument.uri] = notification.params.contentChanges[1].text
end

M.HandleNotifications["textDocument/didClose"] = function (notification)
	M.FileContent[notification.params.textDocument.uri] = nil
end

M.HandleNotifications["textDocument/didSave"] = function ()
end

function M.start ()
	M.running = true
	while true do
		local request = lsp_io.GetMessage()
		if not request then
			Log.error("We did not receive a proper message")
			error("Problème we did not receive a message")
		end
		local parsed_request, err = rpc.DecodeJson(request)
		if err then
			error("Problème: Decoding didn't work properly: "..err.." Message received: "..request)
		end
		if parsed_request.id then
			-- We are in a "request" situation
			Log.info("Received a request with method ", parsed_request.method)
			if M.HandleRequest[parsed_request.method] then
				local response = M.HandleRequest[parsed_request.method](parsed_request)
				local response_message = rpc.EncodeMessage(response)
				Log.info("Response: ", response_message)
				lsp_io.SendMessage(response_message)
			else
				Log.error("Method ", parsed_request.method, " not implemented")
				M.HandleRequest.default(parsed_request)
			end
		else
			-- We receive a notification
			Log.info("Received a notification with method ", parsed_request.method)
			if M.HandleNotifications[parsed_request.method] then
				M.HandleNotifications[parsed_request.method](parsed_request)
			else
				Log.error("Notification of method ", parsed_request.method, " is not implemented")
			end
		end
	end
end

return M
