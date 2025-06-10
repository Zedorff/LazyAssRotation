--- @class RendTracker : DotTracker
RendTracker = setmetatable({}, { __index = DotTracker })
RendTracker.__index = RendTracker

--- @return RendTracker
function RendTracker.new()
    --- @class RendTracker
    local self = DotTracker.new(11574, ABILITY_REND)
    setmetatable(self, RendTracker)
    return self
end
