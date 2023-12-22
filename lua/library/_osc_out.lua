local tab = require("tabutil")

local losc = require("losc")
local plugin = require("losc.plugins.udp-socket")

local osc = losc.new({ plugin = plugin:new({ sendAddr = "127.0.0.1", sendPort = 57120 }) })

local function generateTypesString(msg)
	local types = ""
	for _, x in pairs(msg) do
		local typeMap = {
			["table"] = "b",
			["number"] = "f",
			["string"] = "s",
		}
		if typeMap[type(x)] then
			types = types .. typeMap[type(x)]
		else
			types = types .. "b"
		end
	end

	return types
end

local osc_out = function(self, x, y)
	self.x = x
	self.y = y
	self.name = "osc"
	self.ports = { { 1, 0, "osc-path" } }

	-- local osc_dest = { "127.0.0.1", 57120 } -- crone
	local osc_path = {}

	for x = x + 2, 35 do
		self.ports[#self.ports + 1] = { x - self.x, 0, "osc-path", "input" }
		if self:glyph_at(x + 1, self.y) == "." then
			break
		end
	end

	for i = 1, #self.ports do
		l = self:glyph_at(self.x + i, self.y)
		osc_path[i] = l == "." and "" or l
	end

	local concat_path = table.concat(osc_path)
	local values = tab.split(concat_path, ";")

	if #values > 0 then
		concat_path = values[1]
		values[1] = nil

		self:spawn(self.ports)

		if self:neighbor(self.x, self.y, "*") then
			msg = { ["address"] = "/dirt/play", values }
			msg["types"] = generateTypesString(msg)
			local b = osc.new_message(msg)
			osc.send(b)
		end
	end
end

return osc_out
