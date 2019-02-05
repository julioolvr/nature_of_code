pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

SIZE = 128

player = { x = 64, y = 64 }
tx = 0
ty = 10000

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

function player:perlin_position()
  local noise_x = perlin:noise(tx, tx, tx)
  local noise_y = perlin:noise(ty, ty, ty)
  local speed = 0.01

  -- Meh, I'm not sure what's the range returned by perlin:noise
  -- It seems to be slighly higher than 0.5 so this goes out of bounds sometimes
  self.x = flr(lerp(noise_x + 0.5, 0, SIZE))
  self.y = flr(lerp(noise_y + 0.5, 0, SIZE))

  tx += speed
  ty += speed
end

function player:draw()
  rectfill(
    self.x,
    self.y,
    self.x,
    self.y
  )
end

function draw_perlin_background()
  local scale = 0.05

  for x=0,127 do
    for y=0,127 do
      local noise = perlin:noise(x * scale, y * scale, 0.1)
      color = 1

      if noise > -0.25 then color = 13 end
      if noise > -0.1 then color = 12 end
      if noise > 0 then color = 9 end
      if noise > 0.1 then color = 11 end
      if noise > 0.4 then color = 4 end
      if noise > 0.6 then color = 7 end

      pset(x, y, color)
    end
  end
end

function _init()
  cls()
  perlin:load()
  color(3)
end

function _draw()
  player:perlin_position()
  cls()
  draw_perlin_background()
  player:draw()
end

-- Perlin noise from https://stackoverflow.com/q/33425333
-- tweaked for Pico-8
-- original code by Ken Perlin: http://mrl.nyu.edu/~perlin/noise/

perlin = {}
perlin.p = {}
perlin.permutation = { 151,160,137,91,90,15,
   131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
   190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
   88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
   77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
   102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
   135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
   5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
   223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
   129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
   251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
   49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
   138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}
perlin.size = 256
perlin.gx = {}
perlin.gy = {}
perlin.randMax = 256

function perlin:load(  )
    for i=1,self.size do
        self.p[i] = self.permutation[i]
        self.p[256+i] = self.p[i]
    end
end

function perlin:noise( x, y, z )
    local X = flr(x) % 256
    local Y = flr(y) % 256
    local Z = flr(z) % 256
    x = x - flr(x)
    y = y - flr(y)
    z = z - flr(z)
    local u = fade(x)
    local v = fade(y)
    local w = fade(z)
    local A  = self.p[X+1]+Y
    local AA = self.p[A+1]+Z
    local AB = self.p[A+2]+Z
    local B  = self.p[X+2]+Y
    local BA = self.p[B+1]+Z
    local BB = self.p[B+2]+Z

    return lerp(w, lerp(v, lerp(u, grad(self.p[AA+1], x  , y  , z  ),
                                   grad(self.p[BA+1], x-1, y  , z  )),
                           lerp(u, grad(self.p[AB+1], x  , y-1, z  ),
                                   grad(self.p[BB+1], x-1, y-1, z  ))),
                   lerp(v, lerp(u, grad(self.p[AB+2], x  , y  , z-1),
                                   grad(self.p[BA+2], x-1, y  , z-1)),
                           lerp(u, grad(self.p[AB+2], x  , y-1, z-1),
                                   grad(self.p[BB+2], x-1, y-1, z-1))))
end

function fade( t )
    return t * t * t * (t * (t * 6 - 15) + 10)
end

function lerp( t, a, b )
    return a + t * (b - a)
end

function grad( hash, x, y, z )
    local h = hash % 16
    local u = h < 8 and x or y
    local v = h < 4 and y or ((h == 12 or h == 14) and x or z)
    return ((h % 2) == 0 and u or -u) + ((h % 3) == 0 and v or -v)
end
