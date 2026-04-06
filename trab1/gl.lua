local v = vertex

function square(x, y, size)
  halfside = size/2

  v(x + halfside, y + halfside, -1)
  v(x + halfside, y - halfside, -1)
  v(x - halfside, y - halfside, -1)
  v(x - halfside, y + halfside, -1)

end

local i = 0
function draw()
  local v = math.sin(i)
  color(1.0, v, 0.5)
  square(0.5, 0.5, 1.5+v)
  i=i+0.025
end
