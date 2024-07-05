local M = {}

local rpc = require('easy-lsp.rpc')
local lsp_io = require('easy-lsp.io')
Log = require('easy-lsp.log')

Log.outfile = "/tmp/easy-lsp.log"

function M.start ()
	while true do
		local request = lsp_io.GetMessage()
		if not request then
			error("Problème we did not receive a message")
		end
		local err
		request, err = rpc.DecodeJson(request)
		if err then
			error("Problème: Decoding didn't work properly: "..err)
		end
		Log.info("Méthode: ", request.method)
		if request.method == "initialize" then
			local response = {
				id = request.id,
				result = {
					capabilities = {},
					serverInfo = {
						name = "Squirrel-Prover-LSP",
						version = "0.1.0",
					}
				}
			}
			local response_message = rpc.EncodeMessage(response)
			Log.info("Response: ", response_message)
			lsp_io.SendMessage(response_message)
		else
			Log.warn("Cannot treat this message")
		end
	end
end

return M
