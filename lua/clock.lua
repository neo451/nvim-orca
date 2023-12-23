Clock = {}

function Clock:create(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Clock:new(bpm, sampleRate, beatsPerCycle)
	bpm = bpm or 120
	sampleRate = sampleRate or (1 / 20)
	beatsPerCycle = beatsPerCycle or 4
	return Clock:create({
		bpm = bpm,
		sampleRate = sampleRate,
		beatsPerCycle = beatsPerCycle,
		clock = vim.uv.new_timer(),
	})
end

function Clock:start(func)
	local secondsPerMinute = 60
	local cps = (self.bpm / self.beatsPerCycle) / secondsPerMinute
	self.clock:start(
		0,
		cps * 1000,
		vim.schedule_wrap(function()
			func()
		end)
	)
end

function Clock:stop()
	self.clock:stop()
end

return Clock
