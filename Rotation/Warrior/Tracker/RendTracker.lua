--- @class RendTracker : DotTracker
RendTracker = setmetatable({}, { __index = DotTracker })
RendTracker.__index = RendTracker

--- @return RendTracker
function RendTracker.new()
    --- @class RendTracker
    local self = DotTracker.new(ABILITY_REND, 21.5)
    setmetatable(self, RendTracker)
    return self
end
