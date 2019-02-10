pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

LIMIT = 128
Vector2 = { x = 0, y = 0 }
Vector2.__index = Vector2

function Vector2:new(o)
  return setmetatable(o or {}, self)
end

function Vector2:add(other)
  self.x += other.x
  self.y += other.y
end

function Vector2:subtract(other)
  self.x -= other.x
  self.y -= other.y
end

function Vector2:mult(scalar)
  self.x *= scalar
  self.y *= scalar
end

--

position = Vector2:new{ x = 20, y = 30 }
velocity = Vector2:new{ x = 1, y = 2 }

center = Vector2:new{ x = LIMIT / 2, y = LIMIT / 2 }

function _init()
  -- Enable devkit mode to read the mouse position
  poke(0x5f2d, 1)
end

function _draw()
  cls()
  draw_ball()
  draw_line()
end

function draw_ball()
  move()
  circfill(position.x, position.y)
end

function move()
  position:add(velocity)

  if position.x >= LIMIT or position.x <= 0 then velocity.x *= -1 end
  if position.y >= LIMIT or position.y <= 0 then velocity.y *= -1 end
end

function draw_line()
  local mouse_position = Vector2:new{ x = stat(32), y = stat(33) }
  mouse_position:subtract(center)
  mouse_position:mult(0.5)
  mouse_position:add(center)

  line(
    center.x,
    center.y,
    mouse_position.x,
    mouse_position.y
  )
end

function print_vec(name, vec)
  print(name .. " x: " .. vec.x .. " y: " .. vec.y)
end
