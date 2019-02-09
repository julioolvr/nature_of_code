pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

LIMIT = 128
Vector2 = { x = 0, y = 0 }
Vector2.__index = Vector2

function Vector2:new(o)
  local vector = o or {}
  setmetatable(vector, self)
  return vector
end

function Vector2:add(other)
  self.x += other.x
  self.y += other.y
end

--

position = Vector2:new{ x = 20, y = 30 }
velocity = Vector2:new{ x = 1, y = 2 }

function _draw()
  cls()
  move()
  circfill(position.x, position.y)
end

function move()
  position:add(velocity)

  if position.x >= LIMIT or position.x <= 0 then velocity.x *= -1 end
  if position.y >= LIMIT or position.y <= 0 then velocity.y *= -1 end
end
