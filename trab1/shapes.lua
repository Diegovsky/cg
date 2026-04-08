local M = {}

---@class cls
---@field super cls?
class = {
  meta = {
    __index = function(self, k)
      local v = rawget(self, k)
      local super = rawget(self, 'super')
      if v == nil and super ~= nil then
        v = super[k]
      end
      return v
    end
  },
  ---@generic T : cls
  ---@param cls cls
  ---@param newcls T
  ---@return T
  extend = function(cls, newcls)
    newcls.super = cls
    return setmetatable(newcls, cls.meta)
  end,
  docolor = function(self,index)
    local h = self.colors[index]
    if h ~= nil then
      color(h)
    end
  end
}

---@class Rect : cls
--- @field x integer
--- @field y integer
--- @field z integer
--- @field height integer
--- @field width integer
--- @field colors v3[]
M.Rect = {
    width = 1,
    height = 1,
    angle = math.pi/2,
    offset=0,
    z = 0,

  --- @param cls Rect
  --- @param obj {x: integer?, y: integer?, width: integer?, height: integer?, colors: v3[]?, color: v3?}
  --- @return Rect
  new = function(cls, obj)
    obj.x = obj.x or obj[1]
    obj.y = obj.y or obj[2]
    obj.colors = obj.colors or {obj.color}
    return cls:extend(obj)
  end,

  ---@param self Rect
  draw = function(self)
    local halfheight = self.height/2
    local halfwidth = self.width/2

    local x, y, z = self.x, self.y, self.z
    local px = math.cos(self.angle)*self.offset
    local py = math.sin(self.angle)*self.offset

    begin(GL_QUADS)
    self:docolor(1)
    vertex{x - halfwidth, y - halfheight, z}
    self:docolor(2)
    vertex{x + halfwidth, y - halfheight, z}
    self:docolor(3)
    vertex{x + halfwidth+px, y + halfheight+py, z}
    self:docolor(4)
    vertex{x - halfwidth+px, y + halfheight+py, z}
    eend()

  end
}
class:extend(M.Rect)


---@class Triangle : cls
M.Triangle = {
    z = 0,
    size=1,
    angle=0,

  --- @param cls Triangle
  --- @param obj {x: integer?, y: integer?, size: integer?, angle: integer?, colors: v3[]?, color: v3?}
  --- @return Triangle
  new = function(cls, obj)
    obj.x = obj.x or obj[1]
    obj.y = obj.y or obj[2]
    obj.colors = obj.colors or {obj.color}
    return cls:extend(obj)
  end,

  draw = function(self)
      local x, y, z = self.x, self.y, self.z
      local size = self.size/2
      local angle = self.angle
      self:docolor(1)
      begin(GL_TRIANGLES)
      vertex({x, y+size, z})
      vertex({x-size, y, z})
      vertex({x+size, y, z})
      eend()
  end
}
class:extend(M.Triangle)

---@class Circle : cls
M.Circle = {
    z = 0,
    size=1,
    angle=0,

  --- @param cls Circle
  --- @param obj {x: integer?, y: integer?, size: integer?, colors: v3[]?, color: v3?}
  --- @return Circle
  new = function(cls, obj)
    obj.x = obj.x or obj[1]
    obj.y = obj.y or obj[2]
    obj.colors = obj.colors or {obj.color}
    return cls:extend(obj)
  end,

  draw = function(self)
      local x, y, z = self.x, self.y, self.z
      local size = self.size/2
      begin(GL_POLYGON)
      local c = 20
      self:docolor(1)
      for i = 0,c do
        local px = math.cos(2*math.pi*i/c)*size
        local py = math.sin(2*math.pi*i/c)*size
        vertex({x+px, y+py, z})
      end
      eend()
  end
}
class:extend(M.Circle)

return M
