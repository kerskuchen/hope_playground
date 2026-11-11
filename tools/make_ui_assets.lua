-- Makes hope_playground's test UI sprites into assets/ui/ (Aseprite batch mode):
--     OUT=assets/ui aseprite -b --script tools/make_ui_assets.lua
-- Each 9-slice gets the layers attach0 (the center's left top pixel) and attach1 (its right
-- bottom pixel).
local out = os.getenv("OUT")

local function rgb(hex)
  return Color{ r = tonumber(hex:sub(1, 2), 16), g = tonumber(hex:sub(3, 4), 16), b = tonumber(hex:sub(5, 6), 16), a = 255 }
end

local outline = rgb("1b1525")
local gold = rgb("f2c35b")
local goldDark = rgb("b8862e")
local cream = rgb("f3e9cf")

-- A rounded box: an outline, a light top/left inner edge, a dark bottom/right one, a fill
local function box(img, x0, y0, w, h, c)
  for y = 0, h - 1 do
    for x = 0, w - 1 do
      local corner = (x == 0 or x == w - 1) and (y == 0 or y == h - 1)
      local color
      if corner then
        color = nil
      elseif x == 0 or y == 0 or x == w - 1 or y == h - 1 then
        color = c.outline
      elseif y == 1 or x == 1 then
        color = c.light
      elseif y == h - 2 or x == w - 2 then
        color = c.shadow
      else
        color = c.fill
      end
      if color then img:drawPixel(x0 + x, y0 + y, color) end
    end
  end
end

local function marker(sprite, name, x, y)
  local layer = sprite:newLayer()
  layer.name = name
  local image = Image(sprite.width, sprite.height, ColorMode.RGB)
  image:drawPixel(x, y, rgb("ff00ff"))
  sprite:newCel(layer, 1, image, Point(0, 0))
end

-- A sprite drawn by 'draw(image)'; 'center': {x0, y0, x1, y1} for a 9-slice
local function make(name, w, h, draw, center)
  local sprite = Sprite(w, h, ColorMode.RGB)
  draw(sprite.cels[1].image)
  sprite.layers[1].name = "image"
  if center then
    marker(sprite, "attach0", center[1], center[2])
    marker(sprite, "attach1", center[3], center[4])
  end
  sprite:saveAs(out .. "/" .. name .. ".ase")
  sprite:close()
end

local panel = { outline = outline, light = rgb("4c3d6b"), shadow = rgb("231a33"), fill = rgb("2f2545") }
local button = { outline = outline, light = rgb("8a78b8"), shadow = rgb("3d3157"), fill = rgb("5e4c88") }
local focused = { outline = gold, light = rgb("ab98dc"), shadow = rgb("4f4072"), fill = rgb("7b66b0") }
local pressed = { outline = gold, light = rgb("3d3157"), shadow = rgb("6a5896"), fill = rgb("4a3c6c") }
local track = { outline = outline, light = rgb("140f1c"), shadow = rgb("3a2f52"), fill = rgb("1e1729") }

-- Panel: a frame with a second inner line
make("ui_panel", 16, 16, function(img)
  box(img, 0, 0, 16, 16, panel)
  for i = 3, 12 do
    img:drawPixel(i, 2, rgb("3b2f55"))
    img:drawPixel(i, 13, rgb("3b2f55"))
    img:drawPixel(2, i, rgb("3b2f55"))
    img:drawPixel(13, i, rgb("3b2f55"))
  end
end, { 4, 4, 11, 11 })

make("ui_button", 12, 12, function(img) box(img, 0, 0, 12, 12, button) end, { 3, 3, 8, 8 })
make("ui_button_focused", 12, 12, function(img) box(img, 0, 0, 12, 12, focused) end, { 3, 3, 8, 8 })
make("ui_button_pressed", 12, 12, function(img) box(img, 0, 0, 12, 12, pressed) end, { 3, 3, 8, 8 })

-- Checkboxes: the check in the center
local function check(img)
  local points = { {3, 6}, {4, 7}, {5, 8}, {6, 7}, {7, 6}, {8, 5}, {8, 4}, {4, 6}, {5, 7}, {6, 6}, {7, 5}, {3, 5} }
  for _, p in ipairs(points) do img:drawPixel(p[1], p[2], cream) end
end
make("ui_checkbox", 12, 12, function(img) box(img, 0, 0, 12, 12, track) end, { 3, 3, 8, 8 })
make("ui_checkbox_focused", 12, 12, function(img) box(img, 0, 0, 12, 12, { outline = gold, light = track.light, shadow = track.shadow, fill = track.fill }) end, { 3, 3, 8, 8 })
make("ui_checkbox_checked", 12, 12, function(img) box(img, 0, 0, 12, 12, button) check(img) end, { 3, 3, 8, 8 })
make("ui_checkbox_checked_focused", 12, 12, function(img) box(img, 0, 0, 12, 12, focused) check(img) end, { 3, 3, 8, 8 })

-- Slider: a dark groove, a knob
make("ui_slider_track", 10, 6, function(img) box(img, 0, 0, 10, 6, track) end, { 2, 2, 7, 3 })
make("ui_slider_knob", 6, 12, function(img) box(img, 0, 0, 6, 12, button) end, nil)
make("ui_slider_knob_focused", 6, 12, function(img) box(img, 0, 0, 6, 12, { outline = gold, light = gold, shadow = goldDark, fill = rgb("e0a94a") }) end, nil)

-- Scroll bar thumb
make("ui_scrollbar", 3, 7, function(img)
  for y = 1, 5 do
    for x = 0, 2 do img:drawPixel(x, y, x == 1 and cream or rgb("c9bda0")) end
  end
  img:drawPixel(1, 0, rgb("c9bda0"))
  img:drawPixel(1, 6, rgb("c9bda0"))
end, { 1, 2, 1, 4 })

-- Hovered (the mouse over it): lighter, the dark outline (the focus has the gold one)
local hovered = { outline = outline, light = rgb("a493d4"), shadow = rgb("4a3d70"), fill = rgb("6f5ca0") }
make("ui_button_hovered", 12, 12, function(img) box(img, 0, 0, 12, 12, hovered) end, { 3, 3, 8, 8 })
make("ui_checkbox_hovered", 12, 12, function(img) box(img, 0, 0, 12, 12, { outline = rgb("6f5ca0"), light = track.light, shadow = track.shadow, fill = rgb("271e36") }) end, { 3, 3, 8, 8 })
make("ui_checkbox_checked_hovered", 12, 12, function(img) box(img, 0, 0, 12, 12, hovered) check(img) end, { 3, 3, 8, 8 })
make("ui_slider_knob_hovered", 6, 12, function(img) box(img, 0, 0, 6, 12, hovered) end, nil)
