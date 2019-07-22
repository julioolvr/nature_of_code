pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

LIMIT = 128

--

Vector2 = { x = 0, y = 0 }
Vector2.__index = Vector2

function Vector2:new(o)
  return setmetatable(o or {}, self)
end

function Vector2:random()
  local x = rnd(10) - 5
  local y = rnd(10) - 5
  local vector = Vector2:new{ x = x, y = y }
  vector:normalize()
  return vector
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

function Vector2:div(scalar)
  self.x /= scalar
  self.y /= scalar
end

function Vector2:magnitude()
  return sqrt(self.x^2 + self.y^2)
end

function Vector2:normalize()
  local magnitude = self:magnitude()

  if magnitude ~= 0 then
    self:div(magnitude)
  end
end

function Vector2:limit(limit)
  local magnitude = self:magnitude()

  if magnitude > limit then
    self:normalize()
    self:mult(limit)
  end
end

--

Mover = {
  acceleration_scale = 0.01,
  max_velocity = 5,
  position = Vector2:new{ x = 20, y = 20 },
  velocity = Vector2:new{ x = 0, y = 0 },
  acceleration = Vector2:new{ x = 0, y = 0 }
}
Mover.__index = Mover

function Mover:new(o)
  return setmetatable(o or {}, self)
end

function Mover.random()
  return Mover:new{
    position = Vector2:new{ x = flr(rnd(LIMIT)), y = flr(rnd(LIMIT)) }
  }
end

function Mover:update()
  local mouse_position = get_mouse_position()
  self.acceleration = get_mouse_position()
  self.acceleration:subtract(self.position)
  local current_magnitude = self.acceleration:magnitude()
  self.acceleration:normalize()
  self.acceleration:mult(self.acceleration_scale * current_magnitude)

  self.velocity:add(self.acceleration)
  self.velocity:limit(self.max_velocity)

  self.position:add(self.velocity)
end

function Mover:display()
  circfill(self.position.x, self.position.y)
end

function Mover:check_edges()
  if self.position.x > LIMIT then self.position.x = 0 end
  if self.position.x < 0 then self.position.x = LIMIT end
  if self.position.y > LIMIT then self.position.y = 0 end
  if self.position.y < 0 then self.position.y = LIMIT end
end

--

position = Vector2:new{ x = 20, y = 30 }
velocity = Vector2:new{ x = 1, y = 2 }

center = Vector2:new{ x = LIMIT / 2, y = LIMIT / 2 }
balls = {
  Mover.random(),
  Mover.random(),
  Mover.random(),
  Mover.random(),
  Mover.random()
}

function _init()
  -- Enable devkit mode to read the mouse position
  poke(0x5f2d, 1)
end

function _draw()
  cls()

  for i=1, 5 do
    local ball = balls[i]
    ball:update()
    ball:check_edges()
    ball:display()
  end

  draw_mouse()
end

function move()
  position:add(velocity)

  if position.x >= LIMIT or position.x <= 0 then velocity.x *= -1 end
  if position.y >= LIMIT or position.y <= 0 then velocity.y *= -1 end
end

function draw_line()
  local mouse_position = get_mouse_position()
  mouse_position:subtract(center)

  mouse_position:normalize()
  mouse_position:mult(20)

  mouse_position:add(center)

  line(
    center.x,
    center.y,
    mouse_position.x,
    mouse_position.y
  )
end

function draw_mouse()
  local mouse_position = get_mouse_position()
  rectfill(mouse_position.x, mouse_position.y, mouse_position.x + 2, mouse_position.y + 2)
end

function get_mouse_position()
  return Vector2:new{ x = stat(32), y = stat(33) }
end

function print_vec(name, vec)
  print(name .. " x: " .. vec.x .. " y: " .. vec.y)
end
