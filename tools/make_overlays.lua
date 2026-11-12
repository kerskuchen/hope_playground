-- Makes hope_playground's example overlays (graphics.pg: Overlay) into assets/ (Aseprite batch mode):
--     OUT=assets aseprite -b --script tools/make_overlays.lua
-- 256 x 256, tileable (value noise on a lattice that wraps), grey around 128: with SoftLight
-- (x2) mid grey leaves a pixel as it is, lighter brightens, darker darkens.
--     overlay_ground   soft patches and darker dirt, a little warm
--     overlay_wall     rock strata: wavy horizontal bands, a few specks, a little cool
local out = os.getenv("OUT")
local SIZE = 256

-- An integer lattice point's random value in [0, 1)
local function hash(x, y, seed)
  local n = (x * 374761393 + y * 668265263 + seed * 1442695041) & 0xffffffff
  n = ((n ~ (n >> 13)) * 1274126177) & 0xffffffff
  n = n ~ (n >> 16)
  return (n & 0xffff) / 65536
end

-- Value noise at (x, y) (pixels) with 'cells' lattice cells across the image (it wraps)
local function noise(x, y, cells, seed)
  local scale = cells / SIZE
  local fx, fy = x * scale, y * scale
  local x0, y0 = math.floor(fx), math.floor(fy)
  local tx, ty = fx - x0, fy - y0
  tx = tx * tx * (3 - 2 * tx)
  ty = ty * ty * (3 - 2 * ty)
  local function at(i, j) return hash((x0 + i) % cells, (y0 + j) % cells, seed) end
  local top = at(0, 0) + (at(1, 0) - at(0, 0)) * tx
  local bottom = at(0, 1) + (at(1, 1) - at(0, 1)) * tx
  return top + (bottom - top) * ty
end

-- Octaves of it (each twice as fine, half as strong), in [0, 1)
local function fbm(x, y, cells, octaves, seed)
  local sum, weight, total = 0, 1, 0
  for octave = 0, octaves - 1 do
    sum = sum + noise(x, y, cells * (1 << octave), seed + octave) * weight
    total = total + weight
    weight = weight * 0.5
  end
  return sum / total
end

local function clamp(v) return math.max(0, math.min(255, math.floor(v + 0.5))) end

-- A grey value with a tint (each channel times its factor), in steps of 6 (a pixel art look)
local function pixel(value, tint)
  local function q(v) return clamp(math.floor(v / 6 + 0.5) * 6) end
  return Color{ r = q(value * tint[1]), g = q(value * tint[2]), b = q(value * tint[3]), a = 255 }
end

local function make(name, value, tint)
  local sprite = Sprite(SIZE, SIZE, ColorMode.RGB)
  local image = sprite.cels[1].image
  for y = 0, SIZE - 1 do
    for x = 0, SIZE - 1 do
      image:drawPixel(x, y, pixel(value(x, y), tint))
    end
  end
  sprite.layers[1].name = "image"
  sprite:saveAs(out .. "/" .. name .. ".ase")
  sprite:close()
end

-- The ground: broad soft patches, darker dirt where a second noise is high
make("overlay_ground", function(x, y)
  local patches = fbm(x, y, 4, 4, 11)
  local dirt = fbm(x, y, 8, 3, 23)
  local v = 128 + (patches - 0.5) * 70
  if dirt > 0.62 then v = v - (dirt - 0.62) * 140 end
  return v
end, { 1.04, 1.0, 0.93 })

-- The walls: bands along y, bent by a slow noise, with fine grain and a few dark specks
make("overlay_wall", function(x, y)
  local bend = (fbm(x, y, 4, 2, 31) - 0.5) * 40
  local band = fbm(0, y + bend, 16, 3, 37)
  local grain = noise(x, y, 64, 41)
  local v = 128 + (band - 0.5) * 80 + (grain - 0.5) * 14
  if hash(x, y, 43) > 0.985 then v = v - 30 end
  return v
end, { 0.95, 0.98, 1.06 })
