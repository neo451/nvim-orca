-- e9311284.672b020c /dirt/play sssfsfsfsfsiss "_id_" "1" "cps" 0.562500 "cycle" 1189.000000 "delta" 0.888888 "n" 0.000000 "orbit" 0 "s" "bd"

local tab = require("tabutil")

local osc = require("osc").new({
	transport = "udp",
	sendAddr = "127.0.0.1",
	sendPort = 57120,
})

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

	local osc_path = {}

	for i = x + 2, 35 do
		self.ports[#self.ports + 1] = { i - self.x, 0, "osc-path", "input" }
		if self:glyph_at(i + 1, self.y) == "." then
			break
		end
	end

	for i = 1, #self.ports do
		local l = self:glyph_at(self.x + i, self.y)
		osc_path[i] = l == "." and "" or l
	end

	local concat_path = table.concat(osc_path)
	local values = tab.split(concat_path, ";")

	if #values > 0 then
		self:spawn(self.ports)
		local msg = {}
		local param = { "orbit", "sound", "note" }
		for i, v in pairs(values) do
			msg[#msg + 1] = param[i]
			msg[#msg + 1] = tonumber(v) or v
		end
		msg["types"] = generateTypesString(msg)
		msg["address"] = "/dirt/play"
		if self:neighbor(self.x, self.y, "*") then
			local b = osc.new_message(msg)
			osc:send(b)
		end
	end
end

return osc_out
