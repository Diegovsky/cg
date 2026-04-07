local M = {}

M.cls = function(cls)
  if cls.meta == nil then
    cls.meta = {__index=cls}
  end

  return {
    create = function(self)
      return setmetatable(self, cls.meta)
    end
  }
end


M.Square = M.cls{
  new = function(cls, x, y, size, colors)
    return cls:create({
      x=x,y=y,size=(size or 1.0),colors=colors or {}
    }, {__index=M.Square})
  end,

  draw = function(self)
    halfside = self.size/2
    x, y = self.x, self.y
    local function docolor(index)
      local h = self.colors[index]
      if h ~= nil then
        color(h)
      end
    end

    begin(GL_QUADS)
    docolor(1)
    vertex{x + halfside, y + halfside, -1}
    docolor(2)
    vertex{x + halfside, y - halfside, -1}
    docolor(3)
    vertex{x - halfside, y - halfside, -1}
    docolor(4)
    vertex ({x - halfside, y + halfside, -1})
    eend()

  end
}


return M
