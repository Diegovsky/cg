--- @meta _

--- @alias v3 number[] | {x: number, y: number, z: number}

---@param x number
---@param y number
---@param z number
function vertex(x, y, z) end

---@param v v3
function vertex(v) end

---@param x number
---@param y number
---@param z number
function color(x, y, z) end

---@param v v3
function color(v) end

function begin(mode) end
function eend() end

--- @type number
GL_POINTS = 0
--- @type number
GL_LINES = 0
--- @type number
GL_LINE_LOOP = 0
--- @type number
GL_LINE_STRIP = 0
--- @type number
GL_TRIANGLES = 0
--- @type number
GL_TRIANGLE_STRIP = 0
--- @type number
GL_TRIANGLE_FAN = 0
--- @type number
GL_QUADS = 0
--- @type number
GL_QUAD_STRIP = 0
--- @type number
GL_POLYGON = 0
