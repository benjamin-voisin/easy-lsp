_G._TEST = true

local decode = require 'decode'

describe("Decoding functions", function ()
	it("Should find the correct Content-Length", function ()
		local message = "Content-Length: 145\r\n\r\n{}"
		assert.are.equal(decode.get_content_length(message), 145)
	end)
end)
