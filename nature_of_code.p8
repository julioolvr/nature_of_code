pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

player = { x = 64, y = 64 }

function player:random_step(size)
  direction = flr(rnd(4))
  size = size or 1

  if direction == 0 then self.x += size
  elseif direction == 1 then self.x -= size
  elseif direction == 2 then self.y += size
  else self.y -= size
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

function player:monte_carlo_step()
  repeat
    max_size = flr(rnd(10)) -- 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  until max_size > rnd(10) ^ 2

  step_size = flr(rnd(max_size)) + 1
  self:random_step(step_size)
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
  player:monte_carlo_step()
  player:draw()
end
