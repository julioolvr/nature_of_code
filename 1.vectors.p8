pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

LIMIT = 128

position = { x = 30, y = 20 }
velocity = { x = 1, y = 2 }

function _draw()
  cls()
  move()
  circfill(position.x, position.y)
end

function move()
  position.x += velocity.x
  position.y += velocity.y

  if position.x >= LIMIT or position.x <= 0 then velocity.x *= -1 end
  if position.y >= LIMIT or position.y <= 0 then velocity.y *= -1 end
end
