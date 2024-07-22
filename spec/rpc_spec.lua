_G._TEST = true

local rpc = require 'easy-lsp.rpc'

describe("Decoding functions", function ()
	local message = "Content-Length: 15\r\n\r\n{\"Method\":true}"
	it("Should find the correct Content-Length", function ()
		assert.are.equal(15, rpc.get_content_length(message))
	end)

	it("Decode corectly the message", function()
		local result, err = rpc.DecodeMessage(message)
		assert.are.same({Method = true}, rpc.DecodeMessage(message))
	end)
end)

describe("Encoding functions", function ()
	it("Should make a good message with header and content", function ()
		local message = {testing = true}
		local expected_result = "Content-Length: 16\r\n\r\n{\"testing\":true}"
		assert.are.equal(expected_result, rpc.EncodeMessage(message))
	end)
end)
