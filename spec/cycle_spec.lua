_G._TEST = true

-- Log = require('easy-lsp.log')
-- Log.outfile = "/tmp/easy-lsp.log"

local lsp_rpc = require 'easy-lsp.rpc'
local lsp_io = require 'easy-lsp.io'


local initialize_request = {
	id = 1,
	method = "initialize",
	params = {
		processId = 1,
		capabilities = {},
		clientInfo = {
			name = "test",
			version = "t",
		}
	}
}

local expected_initialize_result = {
	id = 1,
	result = {
		serverInfo = {
			name = "test",
			version = "beta",
		},
		capabilities = {},
	}
}

local initialized_notification = {
	method = "initialized",
	params = {
	},
}

local shutdown_request = {
	id = 2,
	method = "shutdown",
	params = {}
}

local expected_shutdown_result = {
	id = 2,
	result = {}
}

local exit_notification = {
	method = "exit",
	params = {}
}


describe("Simple full cycle", function ()
	it("Should perform a simple lifecycle", function ()
		local cmd = string.format("%s %s > test_lsp_output.log", "lua", "./spec/simple_lsp.lua")
		local c = io.popen(cmd, "w")
		if not c then
			print("Could not run the lsp")
			os.exit(1)
		end
		c:write(lsp_rpc.EncodeMessage(initialize_request))
		c:write(lsp_rpc.EncodeMessage(initialized_notification))
		c:write(lsp_rpc.EncodeMessage(shutdown_request))
		c:write(lsp_rpc.EncodeMessage(exit_notification))
		c:flush()
		local return_code = {c:close()}
		return_code = return_code[3]

		assert.are.equal(0, return_code)

		local result_file = io.open("./test_lsp_output.log", "r")
		if not result_file then
			print("could not read results files")
			os.exit(1)
		end
		io.input(result_file)
		local response = lsp_io.GetMessage()
		assert.are.same(expected_initialize_result, lsp_rpc.DecodeJson(response))
		response = lsp_io.GetMessage()
		assert.are.same(expected_shutdown_result, lsp_rpc.DecodeJson(response))
		result_file:close()
		os.remove("./test_lsp_output.log")
	end)
	it("Should perform a wrong cycle (exiting before shutdown request)", function ()
		local cmd = string.format("%s %s > test_lsp_output.log", "lua", "./spec/simple_lsp.lua")
		local c = io.popen(cmd, "w")
		if not c then
			print("Could not run the lsp")
			os.exit(1)
		end
		c:write(lsp_rpc.EncodeMessage(initialize_request))
		c:write(lsp_rpc.EncodeMessage(initialized_notification))
		c:write(lsp_rpc.EncodeMessage(exit_notification))
		c:flush()
		local return_code = {c:close()}
		return_code = return_code[3]

		assert.are.equal(1, return_code)

		local result_file = io.open("./test_lsp_output.log", "r")
		if not result_file then
			print("could not read results files")
			os.exit(1)
		end
		io.input(result_file)
		local response = lsp_io.GetMessage()
		assert.are.same(expected_initialize_result, lsp_rpc.DecodeJson(response))
		result_file:close()
		os.remove("./test_lsp_output.log")
	end)
end)
