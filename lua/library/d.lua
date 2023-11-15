local D = function(self, x, y)
  self.y = y
  self.x = x
  self.name = "delay"
  self.ports = { {-1, 0 , "in-rate"}, {1, 0, "in-mod"}, {0, 1, "d-out"} }
  self:spawn(self.ports)

  local mod = self:listen(self.x + 1, self.y) or 9
  local rate = self:listen(self.x - 1, self.y) or 1

  mod = mod == 0 and 1 or mod rate = rate == 0 and 1 or rate

  local val = (self.frame % (mod * rate))
  local out = (val == 0 or mod == 1) and "*" or "."

  self:write(0, 1, out)
end

return D