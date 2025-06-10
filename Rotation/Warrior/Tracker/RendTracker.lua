--- @class RendTracker : DotTracker
RendTracker = setmetatable({}, { __index = DotTracker })
RendTracker.__index = RendTracker

--- @return RendTracker
function RendTracker.new()
    --- @class RendTracker
    local self = DotTracker.new(ABILITY_REND)
    setmetatable(self, RendTracker)
    return self
end
