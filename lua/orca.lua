-- TODO: write to a buffer (txt file)
-- TODO: make a float window
-- TODO: how to read all states into a table?
-- TODO: read the monome code
-- TODO: port all function into here
package.path = package.path .. ";" .. string.gsub(debug.getinfo(1).source, "^@(.+/)[^/]+$", "%1") .. "library/?.lua"
local M = {}
local library = require("library")
local euclid = require("er")
local music = require("musicutil")
local keycodes = require("keycodes")
-- local metro = require("metro")
-- local clock = require("clock")
local update_id
local running = true
local w = 9
local h = 9
local pt = {}
local hood = { { -1, 0 }, { 1, 0 }, { 0, -1 }, { 0, 1 } }

local orca = {
	w = w,
	h = h,
	cell = {
		{ "1", "A", "2", ".", "R", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", "E", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
		{ ".", ".", ".", ".", ".", ".", ".", ".", "." },
	},
	locks = {},
	info = {},
	frame = 0,
	chars = keycodes.chars,
	notes = { "C", "c", "D", "d", "E", "F", "f", "G", "g", "A", "a", "B" },
}

-- HACK: WTF IS THIS?
function orca.normalize(n)
	return n == "e" and "F" or n == "b" and "C" or n
end

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

-- HACK: NO NEED FOR NOW MAYBE???
-- function orca:erase(x,y)
--   local at = self:index(x,y)
--   self:unlock(x,y)
--   if self.cell[y][x] == "/" then
--     self.cell[y][x] = "."
--   end
-- end

function orca:index_at(x, y)
	return x + (self.w * y)
end

function orca:op(x, y)
	local c = self.cell[y][x]
	return (library[self.up(c)] ~= nil) and true
end

-- HACK: last func to call for each op
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
	print(vim.inspect(self.cell))
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
				library[op](self, x, y) -- run the operater!
			end
		end
	end
	P(self.cell)
	pt = {}
	self.frame = self.frame + 1
end

orca:operate()

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

-- function orca:reload()
-- 	self:clear()
--
-- 	redraw_metro = metro.init(function(stage)
-- 		redraw()
-- 	end, 1 / 60)
-- 	redraw_metro:start()
--
-- 	clock.transport.start()
-- end

function orca:draw_board()
	for y = 1, self.h do
		local tab = table.concat(self.cell[y], " ")
		vim.api.nvim_buf_set_lines(0, y - 1, y - 1, false, { tab })
	end
end

-- function orca:insert(x, y, g)
-- 	self.cell[y][x] = g
-- end

local clock = require("clock")

function update()
  while true do
    clock.sync(1 / 4) -- fires every quarter note
    orca:operate()
  end
end

function clock.transport.start()
	-- prevents CLOCK > RESET from creating a new clock.
	if running then
		return
	end

	print("Start Clock")
	update_id = clock.run(update)
	running = true
end

function clock.transport.stop()
	print("Stop Clock")
	clock.cancel(update_id)
	running = false
end

function init()
  orca:reload()
  update_id = clock.run(update)
end

-- function M.update()
-- 	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
-- 	for y, v in pairs(lines) do
-- 		for x = 1, #v do
-- 			orca:insert(x, y, string.sub(v, x, x))
-- 		end
-- 	end
-- 	P(orca.cell)
-- end

-- vim.api.nvim_create_autocmd({ "TextChanged" }, {
--   pattern = "*.txt",
-- 	callback = update(),
-- })

M.draw = function()
	orca:init_field()
	orca:draw_board()
end

return M
