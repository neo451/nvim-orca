local stackmap = require("stackmap")
local function key_table()
	local t = {}
	for i in string.gmatch("abcdefghijklmnopqrstuvwxyz", "%w") do
		t[i] = "r" .. i
	end
	return t
end

-- stackmap.push("test_replace_way", "n", key_table())
-- stackmap.pop("test_replace_way")

