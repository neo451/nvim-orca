local midi_cc = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "cc"
  self.ports = { {1, 0, "in-channel"}, {2, 0, "in-knob"}, {3, 0, "in-value"} }
  self:spawn(self.ports)

  local channel = util.clamp(self:listen(self.x + 1, self.y) or 0, 0, 16)
  local knob = self:listen(self.x + 2, self.y) or 0
  local raw_value = self:listen(self.x + 3, self.y) or 0
  local val = math.ceil((127 * raw_value) / 35)

  if self:neighbor(self.x, self.y, "*") then
    self.midi_out_device:cc(knob, val, channel)
  end
end

return midi_cc