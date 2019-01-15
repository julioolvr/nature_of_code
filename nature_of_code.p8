pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

player = { x = 20, y = 20 }

function player:random_step()
  direction = flr(rnd(4))

  if direction == 0 then self.x += 1
  elseif direction == 1 then self.x -= 1
  elseif direction == 2 then self.y += 1
  else self.y -= 1
  end
end

function player:biased_step()
  direction = rnd(1)

  if direction < 0.4 then self.x += 1
  elseif direction < 0.6 then self.x -= 1
  elseif direction < 0.8 then self.y += 1
  else self.y -= 1
  end
end

function player:draw()
  rectfill(
    self.x,
    self.y,
    self.x,
    self.y
  )
end

function _init()
  cls()
  color(3)
end

function _draw()
  player:biased_step()
  player:draw()
end
