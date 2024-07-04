_G._TEST = true

local decode = require 'decode'

local message = "Content-Length: 15\r\n\r\n{\"Method\":true}"

describe("Decoding functions", function ()
	it("Should find the correct Content-Length", function ()
		assert.are.equal(decode.get_content_length(message), 15)
	end)

	it("Decode corectly the message", function()
		local result, err = DecodeMessage(message)
		assert.are.same(DecodeMessage(message), {Method = true})
	end)
end)
