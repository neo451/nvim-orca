-- TODO: make a float window
-- TODO: read the monome code
-- TODO: Read a existing file properly
-- TODO: Set bpm with
-- TODO: Make a proper clock imitating the original
package.path = package.path .. ";" .. string.gsub(debug.getinfo(1).source, "^@(.+/)[^/]+$", "%1") .. "library/?.lua"
local M = {}
local library = require("library")
local euclid = require("er")
local music = require("musicutil")
local keycodes = require("keycodes")
local util = require("norns_utils")

local w = 20
local h = 20
local pt = {}
local hood = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }

local orca = {
	w = w,
	h = h,
	cell = {},
	locks = {},
	info = {},
	frame = 0,
	vars = {},
	chars = keycodes.chars,
	notes = { "C", "c", "D", "d", "E", "F", "f", "G", "g", "A", "a", "B" },
}

-- TODO:
function orca:transpose(n, o)
	local nn = (n == nil or n == ".") and "C" or tostring(n)
	local oo = (o == nil or n == ".") and 3 or o
end

function orca:gen_pattern(p, s)
	return euclid.gen(p, s)
end

function orca:get_scale(s, k)
	local name = music.SCALES[s].name
	local notes = music.generate_scale_of_length(k or 1, name, 8)

	return { string.lower(name), notes }
end

function orca:note_freq(n)
	return music.note_num_to_freq(n)
end

function orca:interval_ratio(n)
	return music.interval_to_ratio(n)
end

-- function orca:add_note(ch, note, length, mono)
--   local id = self:index_at(self.x, self.y)
--   if self.active_notes[id] == nil then
--     self.active_notes[id] = {}
--   end
--   if mono then
--     self.active_notes[id][ch] = {note, length}
--   elseif not mono then
--     if self.active_notes[id][note] == note then
--       self.midi_out_device:note_off(note, nil, ch)
--     else
--       self.active_notes[id][note] = {note, length}
--     end
--   end
-- end
--
-- function orca:notes_off(ch)
--   local id = self:index_at(self.x, self.y)
--   if self.active_notes[id] ~= nil then
--     for k, v in pairs(self.active_notes[id]) do
--       local note, length = self.active_notes[id][k][1], util.clamp(self.active_notes[id][k][2], 1, 16)
--       if self.frame % length == 0 then
--         self.midi_out_device:note_off(note, nil, ch)
--         self.active_notes[id][k] = nil
--       end
--     end
--   end
-- end

function orca.up(i)
	return i and string.upper(i) or "."
end

function orca:inbounds(x, y)
	return ((x > 0 and x < self.w) and (y > 0 and y < self.h)) and true
end

function orca:replace(i)
	self.cell[self.y][self.x] = i
end

function orca:explode()
	self:replace("*")
end

function orca:glyph_at(x, y)
	if self:inbounds(x, y) then
		return self.cell[y][x] or "."
	else
		return "."
	end
end

function orca:listen(x, y)
	local l = string.lower(self:glyph_at(x, y))
	return l ~= "." and keycodes.base36[l] or false
end

function orca:locked(x, y)
	local p = self.locks[self:index_at(x, y)]
	return p and p[1] or false
end

function orca:index_at(x, y)
	return x + (self.w * y)
end

function orca:op(x, y)
	local c = self.cell[y][x]
	return (library[self.up(c)] ~= nil) and true
end

function orca:write(x, y, g)
	if not self:inbounds(self.x + x, self.y + y) then
		return false
	elseif self.cell[self.y + y][self.x + x] == g then
		return false
	else
		self.cell[self.y + y][self.x + x] = g
		return true
	end
end

function orca:spawn(p)
	local at = self:index_at(self.x, self.y)
	self.info[at] = self.name
	self.locks[at] = { false, false, true, false }

	for k = 1, #p do
		local x, y = self.x + p[k][1], self.y + p[k][2]
		self:lock(x, y, self.x < x or self.y < y and true, true, false, self.y < y and true)
		self.info[self:index_at(x, y)] = p[k][3]
	end
end

function orca:lock(x, y, locks, dot, active, out)
	local at = self:index_at(x, y)
	self.locks[at] = { locks, dot, active, out }
end

function orca:unlock(x, y, locks, dot, active, out)
	local at = self:index_at(x, y)
	self.locks[at] = { locks, false, active, out }
end

function orca:neighbor(x, y, g)
	for i = 1, 4 do
		if not self:inbounds(x + hood[i][1], y + hood[i][2]) then
			return false
		elseif self.cell[y + hood[i][2]][x + hood[i][1]] == g then
			self:unlock(x, y)
			return true
		end
	end
end

function orca:shift(s, e)
	if self:inbounds(self.x + e, self.y) then
		local data = self.cell[self.y][self.x + s]
		table.remove(self.cell[self.y], self.x + s)
		table.insert(self.cell[self.y], self.x + e, data)
	end
end

function orca:move(x, y)
	local a, b = self.y + y, self.x + x
	if self:inbounds(b, a) then
		local c = orca.cell[a][b] -- self????
		if c ~= "." and c ~= "*" then
			self:explode()
		else
			local l = self.cell[self.y][self.x]
			self:replace(".")
			self.cell[a][b] = l
		end
	else
		self:explode()
	end
end

function orca:parse()
	for y = 1, self.h do
		for x = 1, self.w do
			if self:op(x, y) then
				pt[#pt + 1] = { x, y, self.cell[y][x] }
			end
		end
	end
end

function orca:operate()
	self.locks = {}
	self.info = {}
	self:parse()

	for i = 1, #pt do
		local x, y, g = pt[i][1], pt[i][2], pt[i][3]
		if not self:locked(x, y) then
			local op = self.up(g)
			if op == g or self:neighbor(x, y, "*") then
				library[op](self, x, y)
			end
		end
	end
	pt = {}
	self.frame = self.frame + 1
end

function orca:init_field()
	for y = 1, self.h do
		self.cell[y] = {}
		for x = 1, self.w do
			self.cell[y][x] = "."
		end
	end

	self.locks = {}
	self.info = {}
end

function orca:draw_board()
	for y = 1, self.h do
		local tab = table.concat(self.cell[y])
		vim.api.nvim_buf_set_text(0, y - 1, 0, y - 1, -1, { tab })
	end
end

function orca:insert(x, y, g)
	self.cell[y][x] = g
end

local function update_table()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for y, v in pairs(lines) do
		for x = 1, #v do
			orca:insert(x, y, string.sub(v, x, x))
		end
	end
end

local function animate_interface()
	update_table()
	orca:operate()
	orca:draw_board()
end

M.animate_interface = function()
	vim.loop.new_timer():start(
		0,
		1000,
		vim.schedule_wrap(function()
			animate_interface()
		end)
	)
end

M.draw = function()
	-- update_table()
	orca:init_field()
	orca:draw_board()
end

return M
