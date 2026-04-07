local shapes = require'shapes'

local i = 0
local square = shapes.Square:new(1, 1, nil, {[2]={1,0,1}})
function draw()
  local v = math.sin(i)

  square:draw()
  i = i+0.1
end
