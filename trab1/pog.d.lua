--- @meta _

--- @alias v3 number[3] | {x: number, y: number, z: number}

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
