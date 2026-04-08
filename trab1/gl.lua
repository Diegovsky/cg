local shapes = require 'shapes'
local Rect = shapes.Rect

local i = 0
local offset = 0.15
local height = 0.5

bg = Rect:new {
  0, 0,
  height = 3,
  width = 10,
  colors = {
    { 1, 1, 1 },
    { 1, 1, 1 },
    { 0, 0, 1 },
    { 0, 0, 1 },
  } }

wall = Rect:new {
  -0.4+offset, -0.7,
  height=height,
  color={0.70, 0, 0.25}
}
backwall = Rect:new {
  0.2+offset, -0.7,
  height=height,
  color={0.50, 0, 0.25}
}
-- door
local doorheight = height/3
door = Rect:new {
  -0.6+offset, -0.7-doorheight,
  height=doorheight,
  width=0.1,
  color={0.40, 0, 0.25}
}

local winheight = doorheight/2
window1 = Rect:new {
  0.2, -0.8,
  height = winheight,
  width = winheight,
  color={0.7, 0.1, 0.2}
}

local window2 = window1:extend{
  x = 0.5,
}

local ceil1 = shapes.Triangle:new {-0.45, -0.45, size=0.6, color={0.9, 0.5, 0.7}}
local ceil2 =  backwall:new{y=-0.2, height=0.35, offset=0.35, angle=2*math.pi*0.5}

local entities = {
  bg,
  wall,
  backwall,
  window1,
  window2,
  door,
  ceil1,
  ceil2,
  shapes.Circle:new{-0.45,-0.32,size=0.1,color=window2.color},
}

function draw()
  local v = math.sin(i / 4)
  for k in ipairs(entities) do
    local shape = entities[#entities-k+1]
    shape:draw()
  end
  i = i + 0.1
end
