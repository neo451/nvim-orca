local M = {}
local stackmap = require("stackmap")
local function key_table()
	local t = {}
	for i in string.gmatch("abcdefghijklmnopqrstuvwxyz123456789.", "%w") do
		t[i] = "r" .. string.upper(i)
	end
  t["."] = "r."
	return t
end

local on = false
function M.toggle_stackmap()
	if on == false then
		stackmap.push("test_replace_way", "n", key_table())
    on = true
    print("replce mode on")
	else
		stackmap.pop("test_replace_way", "n")
    on = false
    print("replce mode off")
	end
end
return M
