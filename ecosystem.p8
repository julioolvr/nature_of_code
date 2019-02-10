pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

SCREEN_SIZE = 128

creatures = {}

function _init()
  local fly = Creature:new()

  function fly:behave()
    self.acceleration = Vector2.random()
    self.acceleration:mult(0.5)
  end

  creatures[1] = fly
end

function _draw()
  cls()

  for _, creature in pairs(creatures) do
    -- print_vec('Velocity', creature.velocity)
    -- print_vec('Acceleration', creature.acceleration)
    creature:behave()
    creature:move()
    creature:draw()
  end
end

--

Vector2 = { x = 0, y = 0 }
Vector2.__index = Vector2

function Vector2.new(o)
  return Vector2.__init__(Vector2, o)
end

function Vector2:__init__(o)
  return setmetatable(o or {}, self)
end

function Vector2.random()
  local x = rnd(10) - 5
  local y = rnd(10) - 5
  local vector = Vector2.new{ x = x, y = y }
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

Creature = {
  color = 5,
  size = 1,
  max_velocity = 5,
  velocity = Vector2.new{x = 0, y = 0},
  position = Vector2.new{x = 20, y = 20}
}

function Creature:__init__(o)
  return setmetatable(o or {}, self)
end

function Creature.new(o)
  return Creature.__init__(Creature, o)
end

function Creature:draw()
  circfill(
    self.position.x,
    self.position.y,
    self.size,
    self.color
  )
end

function Creature:move()
  self.velocity:add(self.acceleration)
  self.velocity:limit(self.max_velocity)
  self.position:add(self.velocity)

  if self.position.x > SCREEN_SIZE then self.position.x = 0 end
  if self.position.x < 0 then self.position.x = SCREEN_SIZE end
  if self.position.y > SCREEN_SIZE then self.position.y = 0 end
  if self.position.y < 0 then self.position.y = SCREEN_SIZE end
end

--

function print_vec(name, vec)
  print(name .. " x: " .. vec.x .. " y: " .. vec.y)
end
