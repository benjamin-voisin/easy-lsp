_G._TEST = true

local encode = require 'encode'

describe("Decoding functions", function ()
	it("Should find the correct Content-Length", function ()
		local message = {testing = true}
		local expected_result = "Content-Length: 16\r\n\r\n{\"testing\":true}"
		assert.are.equal(EncodeMessage(message), expected_result)
	end)
end)
